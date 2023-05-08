#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
#   Main file of Project 5

#   I/O packages
using DelimitedFiles, MAT
#   Math packages
using Arpack, LinearAlgebra, Metis, Random, SparseArrays, Statistics
#   Plot packages
using Graphs, SGtSNEpi, Colors, CairoMakie, PrettyTables
#   Tools
include("./Tools/add_paths.jl");

#   Generate adjacency matrices and vertices coordinates
# path_file = "./Meshes/2D/airfoil1.mat" # or "/path/to/project/Sources/Meshes/Meshes/2D/airfoil1.mat
# A, coords = read_mat_graph(path_file);

# path_file = "./Meshes/Countries/csv/RU-40527"
# A, coords = read_csv_graph(path_file);
# fig = draw_graph(A, coords)
# mesh = split(path_file, "/")[end]
# save("$(mesh).pdf", fig)

#   Draw & save the airfoil1
# println("Drawing the airfoil1...")
# fig = draw_graph(A, coords)
# save("airfoil1.pdf", fig)
# fig = draw_fiedler(A, coords)
# save("airfoil1_fiedler.pdf", fig)

#   Run benchmark
# println("Running benchmark_bisection")
# benchmark_bisection()
# println("")
# println("Running benchmark_recursive")
# benchmark_recursive()
# println("")
# println("Running benchmark_metis")
# benchmark_metis()
meshes = ["CH-4468", "CL-13042", "GB-5946", "GR-3117", "NO-9935", "RU-40527", "VN-4031"]

for mesh in meshes
    path = joinpath(dirname(@__DIR__),"Meshes","Countries","csv",mesh)
    A, coords = read_csv_graph(path)
    path_graph = joinpath(dirname(@__DIR__),"Meshes","Countries","csv",mesh*"_graph.mat")

    # Create a nested dictionary to store the matrices
    variables = Dict(
        "Problem" => Dict(
            "A" => A,
            "aux" => Dict(
                "coord" => coords
            )
        )
    )

    # Save the matrices to a .mat file
    file = matopen(path_graph, "w")
    write(file, variables)
    close(file)
end