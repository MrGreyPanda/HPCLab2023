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
    meshes = ["luxembourg_osm" "usroads"]
    algs = ["Metis" "Metis"]

    #   Init result array
    pAll = Array{Any}(undef, length(meshes), length(algs) + 1)
    for (j, n_levels) in enumerate([3, 4])
        for (i, mesh) in enumerate(meshes)
            n_parts = 2^j
            println("Benchmarking recursive bisection for mesh $mesh with $n_parts partitions")
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
            # Starting METIS method recursively with 16 partions
            println("Computing recursive bisection for METIS for mesh $mesh with $n_levels partitions with KWAY")
            pMetis = metis_part(A, n_parts, :KWAY);
            pAll[i, j] = count_edge_cut(A, pMetis)

            #   b)  METIS RECURSIVE 
            # Starting METIS method recursively with 32 partions
            println("Computing recursive bisection for METIS for mesh $mesh with $n_levels partitions with RECURSIVE")
            pMetis = metis_part(A, n_levels, :RECURSIVE);
            pAll[i, j + 1] = count_edge_cut(A, pMetis)
        end
    end
    #   3.  Visualize the results for 32 partitions.
    #   Print result table
    header =(hcat(["Partitions"], ""), ["" "Luxemburg" "" "usroads-48" "" "Greece" "" "Switzerland" "" "Vietnam" "" "Norway" "" "Russia"])
    pretty_table(pAll; header = header, crop = :none, header_crayon = crayon"bold cyan")
end