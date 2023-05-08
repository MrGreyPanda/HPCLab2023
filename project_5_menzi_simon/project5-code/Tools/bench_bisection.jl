#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    benchmark_bisection()

Run a benchmark of different meshes with different partitioning method.

# Examples
```julia-repl
julia> benchmark_bisection()
```
"""
function benchmark_bisection()
    #   List the meshes to compare
    meshes = ["mesh1e1" "mesh2e1" "mesh3e1" "mesh3em5" "airfoil1" "netz4504_dual" "stufe" "3elt" "barth4" "ukerbe1" "crack"]

    #   List the algorithms to compare
    algs = ["Coordinate" "Metis" "Spectral" "Inertial"]

    #   Init comparison table
    pAll = Array{Any}(undef, length(meshes), length(algs) + 1)

    #   Loop through meshes
    for (i, mesh) in enumerate(meshes)
        println("Mesh: ", mesh)

        #   Define path to mat file
        path = joinpath(dirname(@__DIR__),"Meshes","2D",mesh*".mat");

        #   Read data
        println("Reading data...")
        A, coords = read_mat_graph(path);

        #   1st row
        pAll[i, 1] = mesh

        #   Coordinate bisection
        # println("Coordinate bisection...")
        # pCoordinate = coordinate_part(A, coords);
        # pAll[i, 2] = count_edge_cut(A, pCoordinate);

        # #   METIS bisection
        # println("METIS bisection...")
        # pMetis = metis_part(A, 2, :KWAY);
        # pAll[i, 3] = count_edge_cut(A, pMetis);

        # #   Spectral bisection
        # println("Spectral bisection...")
        # pSpectral = spectral_part(A);
        # pAll[i, 4] = count_edge_cut(A, pSpectral);

        #   Inertial bisection
        println("Inertial bisection...")
        pInertial = inertial_part(A, coords);
        pAll[i, 5] = count_edge_cut(A, pInertial); 
        fig = draw_graph(A, coords, pInertial)
        save("$(mesh)_inertial.pdf", fig)
    end

    io = IOBuffer()

    #   Print table
    header =(hcat(["Mesh"], algs), ["" "" "v.5.1.0" "" ""])
    pretty_table(io, pAll; header = header, crop = :none, header_crayon = crayon"bold green")

    open("bisection_benchmark.txt", "w") do file
        print(file, String(take!(io)))
    end

end
