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
    center_of_mass = sum(coords, dims=1) / n
    x = sum(coords[:,1]) / n
    y = sum(coords[:,2]) / n

    #   2.  Construct the matrix M. (see pdf of the assignment)
    S_xx = sum(coords[:, 1] .- x)
    S_yy = sum(coords[:, 2] .- y)
    S_xy = dot(coords[:, 1], coords[:, 2]) 
        + x * y 
        - sum(coords[:, 1] .* y) 
        - sum(coords[:, 2] .* x)

    M = [S_yy S_xy;
         S_xy S_xx]


    #   3.  Compute the eigenvector associated with the smallest eigenvalue of M.
    # eigv = eigvecs(M)[:, 1]
    F = eigen(M)
    eigv = F.vectors[:,1]

    #   4.  Partition the nodes around line L 
    #       (you may use the function partition(coords, eigv))
    p = zeros(Float64, size(A)[1])

    V1, V2 = partition(coords, eigv)
    p[V1] .= 1
    p[V2] .= 2
    
    #   5.  Return the indicator vector
    return p

end