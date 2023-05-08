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
    # meshes = ["airfoil1" "netz4504_dual" "stufe" "3elt" "barth4" "ukerbe1" "crack" "mesh3e1"]

    meshes = ["crack"]
    # meshes = ["crack"]

    #   List the algorithms to recursively run and compare
    algs = ["Spectral" "Spectral" "Metis" "Metis" "Coordinate" "Coordinate" "Inertial" "Inertial"]

    #   Init result array
    pAll = Array{Any}(undef, length(meshes), length(algs) + 1)

    #   Loop through meshes
    for (i, mesh) in enumerate(meshes)
        #   Define path to mat file
        path = joinpath(dirname(@__DIR__),"Meshes","2D",mesh*".mat");
        
        for (j, n_levels) in enumerate([3, 4])
            n_parts = 2^n_levels
        
            #   Read data
            A, coords = read_mat_graph(path)

            #   1st row
            pAll[i, 1] = mesh

            #   Recursive routines
            #   1.  Spectral
            println("Computing recursive bisection for spectral partitioning for mesh $mesh with $n_parts partitions")
            pSpectral = rec_bisection(spectral_part, n_levels, A)
            pAll[i, 1 + j] = count_edge_cut(A, pSpectral)

            #   2.  METIS
            println("Computing recursive bisection for METIS for mesh $mesh with $n_parts partitions")
            pMetis = metis_part(A, n_parts, :RECURSIVE);
            pAll[i, 3 + j] = count_edge_cut(A, pMetis)
            
            #   3.  Coordinate
            println("Computing recursive bisection for coordinate partitioning for mesh $mesh with $n_parts partitions")
            pCoordinate = rec_bisection("coordinate_part", n_levels, A, coords)
            pAll[i, 5 + j] = count_edge_cut(A, pCoordinate)
            
            #   4.  Inertial
            println("Computing recursive bisection for inertial partitioning for mesh $mesh with $n_parts partitions")
            pInertial = rec_bisection(inertial_part, n_levels, A, coords)
            pAll[i, 7 + j] = count_edge_cut(A, pInertial)

            if mesh == "crack" && n_parts == 16
                println("Plotting graphs for mesh $mesh with $n_parts levels")
                # figSpectral = draw_graph(A, coords, pSpectral)
                # save(mesh * "_spectral_" * string(n_parts) * ".pdf", figSpectral)

                # figMetis = draw_graph(A, coords, pMetis)
                # save(mesh * "_metis_" * string(n_parts) * ".pdf", figMetis)
            
                # figCoordinate = draw_graph(A, coords, pCoordinate)
                # save(mesh * "_coordinate_" * string(n_parts) * ".pdf", figCoordinate)

                figInertial = draw_graph(A, coords, pInertial)
                save(mesh * "_inertial_" * string(n_parts) * ".pdf", figInertial)
            end
        end
    end

    io = IOBuffer()

    #   Print result table
    header =(hcat(["Mesh"], algs), ["" "8 n_parts" "16 n_parts" "8 n_parts" "16 n_parts" "8 n_parts" "16 n_parts" "8 n_parts" "16 n_parts"])
    pretty_table(io, pAll; header = header, crop = :none, header_crayon = crayon"bold cyan")
    
    open("recursive_benchmark.txt", "w") do file
        print(file, String(take!(io)))
    end
    
end

