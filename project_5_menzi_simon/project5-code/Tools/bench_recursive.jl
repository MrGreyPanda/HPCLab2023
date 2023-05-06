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
        # Starting spectral method recursively with 8 partions
        pSpectral8 = rec_bisection(spectral_part, 8, A, coords, )
        pAll[i, 2] = count_edge_cut(A, pSpectral8)
        # Starting spectral method recursively with 16 partions
        pSpectral16 = rec_bisection(spectral_part, 16, A, coords, )
        pAll[i, 3] = count_edge_cut(A, pSpectral16)

        
        #   2.  METIS
        println("Starting METIS")
        # Starting METIS method recursively with 8 partions
        pMetis8 = rec_bisection(metis_part, 8, A, coords, )
        pAll[i, 4] = count_edge_cut(A, pMetis8)
        # Starting METIS method recursively with 16 partions
        pMetis16 = rec_bisection(metis_part, 16, A, coords, )
        pAll[i, 5] = count_edge_cut(A, pMetis16)

        #   3.  Coordinate
        println("Starting Coordinate")
        # Starting Coordinate method recursively with 8 partions
        pCoordinate8 = rec_bisection(coordinate_part, 8, A, coords, )
        pAll[i, 6] = count_edge_cut(A, pCoordinate8)
        # Starting Coordinate method recursively with 16 partions
        pCoordinate16 = rec_bisection(coordinate_part, 16, A, coords, )
        pAll[i, 7] = count_edge_cut(A, pCoordinate16)

        #   4.  Inertial
        println("Starting Ineratial")
        # Starting Inertial method recursively with 8 partions
        pInertial8 = rec_bisection(inertial_part, 8, A, coords, )
        pAll[i, 8] = count_edge_cut(A, pInertial8)
        # Starting Inertial method recursively with 16 partions
        pInertial16 = rec_bisection(inertial_part, 16, A, coords, )
        pAll[i, 9] = count_edge_cut(A, pInertial16)

    end

    #   Print result table
    header =(hcat(["Mesh"], algs), ["" "8 parts" "16 parts" "8 parts" "16 parts" "8 parts" "16 parts" "8 parts" "16 parts"])
    pretty_table(pAll; header = header, crop = :none, header_crayon = crayon"bold cyan")
end
