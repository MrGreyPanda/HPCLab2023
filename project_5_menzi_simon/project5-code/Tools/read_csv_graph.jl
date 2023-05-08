#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
#   Data extraction method
function create_adjacency_matrix(data)
    n = maximum(data)
    A = zeros(Int64, n, n)
    rows = Int[]
    cols = Int[]
    vals = Int[]

    for (i, j) in eachrow(data)
        rows = push!(rows, i)
        cols = push!(cols, j)
        vals = push!(vals, 1)

        rows = push!(rows, j)
        cols = push!(cols, i)
        vals = push!(vals, 1)
    end
    
    A = sparse(rows, cols, vals, n, n)
    return A
end


"""
    read_csv_graph(path_file)

Extract the data located in the csv `path_file`.
"""
function read_csv_graph(path_file)
    # Steps
    #   1.  Load the .csv files
    #       see readdlm(...)
    data = readdlm(path_file *"-adj.csv", ',', UInt, skipstart=1)
    coords = readdlm(path_file*"-pts.csv", ',', Float64, skipstart=1)

    #   2.  Construct the adjacency matrix A
    A = create_adjacency_matrix(data)

    #   3.  Visualize and save the result 
    #       use drawGraph(A, coords)
    
    #   4.  Return the matrix A and the coordinates 
    #       return(A, coords)
    return(A, coords)
end