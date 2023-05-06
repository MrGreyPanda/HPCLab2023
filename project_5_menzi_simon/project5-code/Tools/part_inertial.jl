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
    center_of_mass = sum(coords, dims=1) / size(coords)[1]

    # #   2.  Construct the matrix M. (see pdf of the assignment)
    M = zeros(size(A))
    for i in 1:size(A)[1]
        for j in 1:size(A)[1]
            M[i, j] = (coords[i, 1] - center_of_mass[1]) * (coords[j, 1] - center_of_mass[1]) + (coords[i, 2] - center_of_mass[2]) * (coords[j, 2] - center_of_mass[2])
        end
    end

    # #   3.  Compute the eigenvector associated with the smallest eigenvalue of M.
    # eigv = eigvecs(M)[:, 1]
    eigv = eigs(M, nev=1, which=:SR, ritzvec=true)[2][:, 1]

    #   4.  Partition the nodes around line L 
    #       (you may use the function partition(coords, eigv))
    p = zeros(Float64, size(A)[1])

    V1, V2 = partition(coords', eigv)
    p[V1] .= 1
    p[V2] .= 2
    p = Int.(p)
    #   5.  Return the indicator vector
    return p

end