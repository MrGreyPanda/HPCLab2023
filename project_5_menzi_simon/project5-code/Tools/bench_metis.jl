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
    for (i, mesh) in enumerate(meshes)
        #   Define path to mat file
        path = joinpath(dirname(@__DIR__),"Meshes","Roads",mesh*".mat");

        #   Read data
        A, coords = read_mat_graph(path);

        A = Metis.graph(A; weights=true, check_hermitian=false)

        #   1st row
        pAll[i, 1] = mesh
        println("Starting METIS routines")
        println("---------------------------")

        #   METIS routines
        #   1.  METIS
        println("Starting METIS")
        # Starting METIS method recursively with 16 partions
        pMetis16 = rec_bisection("metis_part", 16, A, coords)
        pAll[i, 2] = count_edge_cut(A, pMetis16)
        # Starting METIS method recursively with 16 partions
        pMetis32 = rec_bisection("metis_part", 32, A, coords)
        pAll[i, 3] = count_edge_cut(A, pMetis32)

        #   2.  METIS
        println("Starting METIS")
        # Starting METIS method recursively with 16 partions
        
    end
    
    #   2.  Call metis_part to:
    #       a) Recursively partition the graphs in 16 and 32 subsets.
    #       b) Perform direct k-way partitioning of the graphs in 16 and 32 subsets.

    #   3.  Visualize the results for 32 partitions.
end