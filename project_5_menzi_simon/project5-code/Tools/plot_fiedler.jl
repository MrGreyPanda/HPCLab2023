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
    D = degree_matrix(A)
    D_vec = diag(D)
    L = D - A
    val, vec = eigs(L, nev=2, which=:SM, ritzvec=true, maxiter=10000)
    # fiedler_vec1 = F.vectors[:, 1]
    fiedler_vec = vec[:, 2]
    # fiedler_val1 = F.values[1]
    fiedler_val = val[2]
    p = ones(Int, size(A)[1])
    p[fiedler_vec .> 0] .= 2
    fiedler_vec ./= norm(fiedler_vec)
    

    #   3.  Compute the indicator vector

    #   4.  Plot using e.g. Makie.scatter
    println("Creating plot...")
    fig = Figure()
    ax = Axis3(fig[1, 1], aspect=(1, 1, 1))

    scatter!(x, y, fiedler_vec, color = p, colormap= :Spectral_11, markersize = 5)
    return fig

end