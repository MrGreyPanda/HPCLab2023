
#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 

function degree_matrix(A::Matrix{Int})
    n = size(A, 1)
    D = zeros(Int, n, n)
    for i in 1:n
        D[i, i] = sum(A[i, :])
    end
    return D

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
    
    #   1.  Construct the Laplacian matrix.
    D = degree_matrix(A)
    L = D - A
  
    #   2.  Compute its eigendecomposition.
    F = eigen(L)
    
    #   3.  Label the vertices with the entries of the Fiedler vector.
    fiedler_vec = F.vectors[:, 2]
    fiedler_val = F.values[2]

    #   4.  Partition them around their median value, or 0.


    #   5.  Return the indicator vector

    # RANDOM PARTITIONING - REMOVE AFTER COMPLETION OF THE EXERCISE
    n = size(A)[1];
    rng = MersenneTwister(1234);
    p = bitrand(rng, n);
    return p

end