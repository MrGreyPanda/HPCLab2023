#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    benchmark_recursive()

Run a benchmark of different meshes with different recursive partitioning method.

# Examples
```julia-repl
julia> function benchmark_recursive()
()
```
"""
function benchmark_recursive()
    #   List the meshes to compare
    meshes = ["airfoil1" "netz4504_dual" "stufe" "3elt" "barth4" "ukerbe1" "crack"]

    #   List the algorithms to recursively run and compare
    algs = ["Spectral" "Spectral" "Metis" "Metis" "Coordinate" "Coordinate" "Inertial" "Inertial"]

    #   Init result array
    pAll = Array{Any}(undef, length(meshes), length(algs) + 1)

    #   Loop through meshes
    for (i, mesh) in enumerate(meshes)
        #   Define path to mat file
        path = joinpath(dirname(@__DIR__),"Meshes","2D",mesh*".mat");

        #   Read data
        A, coords = read_mat_graph(path);

        #   1st row
        pAll[i, 1] = mesh
        println("Starting recursive routines")
        println("---------------------------")

        #   Recursive routines
        #   1.  Spectral
        println("Starting spectral")
        pSpectral8 = rec_bisection("spectral_part", 8, A, coords, )
        pAll[i, 2] = count_edge_cut(A, pSpectral8)

        pSpectral16 = rec_bisection("spectral_part", 16, A, coords, )


        pCoordinate = coordinate_part(A, coords);
        pAll[i, 2] = count_edge_cut(A, pCoordinate);
        
        #   2.  METIS
        println("Starting METIS")

        #   3.  Coordinate
        println("Starting Coordinate")

        #   4.  Inertial
        println("Starting Ineratial")

    end

    #   Print result table
    header =(hcat(["Mesh"], algs), ["" "8 parts" "16 parts" "8 parts" "16 parts" "8 parts" "16 parts" "8 parts" "16 parts"])
    pretty_table(pAll; header = header, crop = :none, header_crayon = crayon"bold cyan")
end
