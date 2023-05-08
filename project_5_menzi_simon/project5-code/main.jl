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
println("Running benchmark_recursive")
benchmark_recursive()
println("")
# println("Running benchmark_metis")
# benchmark_metis()
# println("Creating the csv files")
# save_csv_mats()

# Draw Fiedler
# println("Drawing the fiedler...")
# A, coords = read_mat_graph("./Meshes/2D/airfoil1.mat");
# fig = draw_fiedler(A, coords)
# save("airfoil1_fiedler.pdf", fig)