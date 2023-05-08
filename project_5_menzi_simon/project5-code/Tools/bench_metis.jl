#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    benchmark_metis()

Run a benchmark of different meshes with METIS partitioning method.

# Examples
```julia-repl
julia> benchmark_metis()
```
"""
function benchmark_metis()
    #   1.  Load luxembourg_osm.mat and usroads.mat
    meshes_roads = ["luxembourg_osm" "usroads"]
    meshes_maps = ["GR-3117" "CH-4468" "VN-4031" "NO-9935" "RU-40527" "GB-5846" "CL-13042"]

    #   Init result array
    pAll = Array{Any}(undef, length(meshes_roads), length(algs) + 1)

    for (i, n_levels) in enumerate([4, 5])
        for (j, mesh) in enumerate(meshes_roads)
            exponent = 2^i
            println("Benchmarking recursive bisection for mesh $mesh with $exponent partitions")
            #   Define path to mat file
            path = joinpath(dirname(@__DIR__),"Meshes","Roads",mesh*".mat");

            #   Read data
            A, coords = read_mat_graph(path);

            A = Metis.graph(A; weights=true, check_hermitian=false)
            
            #   1st row
            pAll[i, 1] = mesh
            println("Starting METIS routines")
            println("---------------------------")
            
            #   2.  Call metis_part to:
            #       a) Recursively partition the graphs in 16 and 32 subsets.
            #       b) Perform direct k-way partitioning of the graphs in 16 and 32 subsets.
            #   METIS routines
            #   a)  METIS KWAY
            println("Starting METIS")
            # Starting METIS method KWAY
            println("Computing recursive bisection for METIS for mesh $mesh with $n_levels partitions with KWAY")
            pMetis = metis_part(A, exponent, :KWAY);
            pAll[i, j] = count_edge_cut(A, pMetis)

            #   b)  METIS RECURSIVE 
            # Starting METIS method RECURSIVE
            println("Computing recursive bisection for METIS for mesh $mesh with $n_levels partitions with RECURSIVE")
            pMetis = metis_part(A, n_levels, :RECURSIVE);
            pAll[i, j + 1] = count_edge_cut(A, pMetis)


        end
        
        for (j, mesh) in enumerate(meshes_maps)
            path = joinpath(dirname(@__DIR__),"Meshes","Countries","csv",mesh*".csv")
            A, coords = read_csv_graph(path)

            #   a)  METIS KWAY
            println("Starting METIS")
            # Starting METIS method KWAY
            println("Computing recursive bisection for METIS for mesh $mesh with $exponent partitions with KWAY")
            pMetis = metis_part(A, exponent, :KWAY);
            pAll[i, j + 4] = count_edge_cut(A, pMetis)

            #   b)  METIS RECURSIVE 
            # Starting METIS method RECURSIVE
            println("Computing recursive bisection for METIS for mesh $mesh with $exponent partitions with RECURSIVE")
            pMetis = metis_part(A, exponent, :RECURSIVE);
            pAll[i, j + 5] = count_edge_cut(A, pMetis)

            
        end

    end
    #   3.  Visualize the results for 32 partitions.

    io = IOBuffer()
    #  Print result table
    header =(["Partitions" "Luxemburg" "Luxemburg" "" "usroads-48" "usroads-48" "Greece" "Greece" "Switzerland" "Switzerland" "Vietnam" "Vietnam" "Norway" "Norway" "Russia" "Russia" "Great Britain" "Great Britain" "Chile" "Chile"],
             ["" "KWAY" "RECURSIVE" "KWAY" "RECURSIVE" "KWAY" "RECURSIVE" "KWAY" "RECURSIVE" "KWAY" "RECURSIVE" "KWAY" "RECURSIVE" "KWAY" "RECURSIVE" "KWAY" "RECURSIVE" "KWAY" "RECURSIVE"])              
    
    # header=(hcat)
    pretty_table(io, pAll; header = header, crop = :none, header_crayon = crayon"bold cyan")



    #   Save result table
    open("metis_benchmark.txt", "w") do file
        print(file, String(take!(io)))
    end
end