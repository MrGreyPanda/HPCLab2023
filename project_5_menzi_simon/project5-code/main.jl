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
path_file = "./Meshes/2D/airfoil1.mat" # or "/path/to/project/Sources/Meshes/Meshes/2D/airfoil1.mat
A, coords = read_mat_graph(path_file);

#   Draw & save the airfoil1
println("Drawing the airfoil1...")
fig = draw_graph(A, coords)
save("airfoil1.pdf", fig)

#   Run benchmark
println("Running benchmark...")
benchmark_bisection()
benchmark_recursive()
benchmark_metis()
