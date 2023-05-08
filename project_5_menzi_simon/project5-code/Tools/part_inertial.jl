#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    inertial_part(A, coords)

Compute the bi-partions of graph `A` using inertial method based on the `coords` of the graph.

# Examples
```julia-repl
julia> inertial_part(A, coords)
 1
 ⋮
 2
```
"""
function inertial_part(A, coords)
    @assert size(A)[1] == size(coords)[1] "Dimension mismatch: number of rows in A must match the number of rows in coords"

    
    #   1.  Compute the center of mass.
    n = size(coords)[1]
    x_bar = sum(coords[:,1]) / n
    y_bar = sum(coords[:,2]) / n
    x = coords[:,1]
    y = coords[:,2]
    center = [x_bar, y_bar]

    #   2.  Construct the matrix M. (see pdf of the assignment)
    S_xx = sum((x .- x_bar).^2)
    S_yy = sum((y .- y_bar).^2)
    # S_xy = dot(x, y) + x_bar * y_bar 
    #      - sum(x .* y_bar) 
    #      - sum(y .* x_bar)
    S_xy = sum((x .- x_bar) .* (y .- y_bar))

    M = [[S_xx S_xy]
         [S_xy S_yy]]



    #   3.  Compute the eigenvector associated with the smallest eigenvalue of M.
    # eigv = eigvecs(M)[:, 1]
    val, vec = eigs(M, nev=1, which=:SM, ritzvec=true)
    i = sortperm(val)
    eigv = vec[:,i]
    eigv = eigv / norm(eigv)
    eigv = [eigv[2], -eigv[1]]

    
    #   4.  Partition the nodes around line L 
    #       (you may use the function partition(coords, eigv))
    p = ones(Int, n)
    V1, V2 = partition(coords, eigv)
    p[V2] .= 2
    
    #   5.  Return the indicator vector
    return p

end