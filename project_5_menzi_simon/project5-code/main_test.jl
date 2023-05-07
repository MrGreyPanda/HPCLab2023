#   I/O packages
using DelimitedFiles, MAT
#   Math packages
using Arpack, LinearAlgebra, Metis, Random, SparseArrays, Statistics
#   Plot packages
using Graphs, SGtSNEpi, Colors, CairoMakie, PrettyTables
#   Tools
include("./Tools/add_paths.jl");
#   Generate adjacency matrices and vertices coordinates
path_file = "./Meshes/2D/airfoil1.mat"
A, coords = read_mat_graph(path_file);
#   Bisect, draw & save the airfoil1
p = rec_bisection("coordinate_part", 3, A, coords)
fig = draw_graph(A, coords, p)
save("airfoil1.pdf", fig)