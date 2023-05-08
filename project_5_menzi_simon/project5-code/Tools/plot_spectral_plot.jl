#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 

function plot_special(A, coords)
    
    p = spectral_part(A)
    #   1.  Get x and y coordinates

    D = degree_matrix(A)
    L = D - A
    val, vec = eigs(L, nev=3, which=:SM, ritzvec=true, maxiter=10000)
    eigen_vec2 = vec[:, 2]
    eigen_vec3 = vec[:, 3]

    spectral_points = [eigen_vec2 eigen_vec3]
    
    fig1 = draw_graph(A, coords, p)
    fig2 = draw_graph(A, spectral_points, p)
    return fig1, fig2
end