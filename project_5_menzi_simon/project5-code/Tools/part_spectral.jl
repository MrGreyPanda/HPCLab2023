
#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 

function degree_matrix(A)
    n = size(A, 1)
    D = zeros(Float64, n, n)
    for i in 1:n
        D[i, i] = sum(A[i, :])
    end
    return D
end

"""
    spectral_part(A)

Compute the bi-partions of graph `A` using spectral method.


# Examples
```julia-repl
julia> spectral_part(A)
 1
 ⋮
 2
```
"""
function spectral_part(A)
    n = size(A)[1]

    if n > 4*10^4
        @warn "graph is large. Computing eigen values may take too long."     
    end
    
    # #   1.  Construct the Laplacian matrix.
    D = degree_matrix(A)
    L = D - A
  
    # # #   2.  Compute its eigendecomposition.
    F = eigen(L)
    
    # # #   3.  Label the vertices with the entries of the Fiedler vector.
    fiedler_vec = F.vectors[:, 2]
    fiedler_val = F.values[2]

    #   4.  Partition them around their median value, or 0.
    #   The threshold of the partition is 0 as I want to have a roughly balanced partition and a minimum cut.
    p = ones(Int, n)
    for (i, val) in enumerate(fiedler_vec)
        if val > 0
            p[i] = 2
        end
    end

    p = Int.(p)
    #   5.  Return the indicator vector
    return p
end
