#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    draw_fiedler(A, coords)

Plot the entries of the Fiedler vector of graph `A`.
"""
function draw_fiedler(A, coords)
    
    #   1.  Get x and y coordinates
    #   2.  Compute fiedler vector entries
    #   3.  Compute the indicator vector
    p = spectral_part(A)

    #   4.  Plot using e.g. Makie.scatter
    scatter(coords[:, 1], coords[:, 2], color = p, markersize = 2)

end