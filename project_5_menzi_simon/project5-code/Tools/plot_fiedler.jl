#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    draw_fiedler(A, coords)

Plot the entries of the Fiedler vector of graph `A`.
"""
function draw_fiedler(A, coords)
    
    #   1.  Get x and y coordinates
    x = coords[:, 1]
    y = coords[:, 2]


    #   2.  Compute fiedler vector entries
    L = degree_matrix(A) - A
    F = eigen(L)
    fiedler_vec1 = F.vectors[:, 1]
    fiedler_vec2 = F.vectors[:, 2]
    fiedler_val1 = F.values[1]
    fiedler_val2 = F.values[2]

    #   3.  Compute the indicator vector
    p = ones(Int, size(A)[1])
    p[fiedler_vec1 .> 0] .= 2


    #   4.  Plot using e.g. Makie.scatter
    scatter(coords[:, 1], coords[:, 2], fiedler_vec, color = p, markersize = 2)

end