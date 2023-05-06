#   M.L. for High Performance Computing Lab @USI & @ETHZ - malik.lechekhab@usi.ch 
"""
    rec_bisection(method, levels, A, coords=zeros(0), vn=zeros(0))

Compute recursive partitioning of graph `A` using a specified `method` and number of `levels`.

If the `method` is `coords`-based, coordinates must be passed.

# Examples
```julia-repl
julia> rec_bisection("spectralPart", 3, A)
 5
 ⋮
 2

julia> rec_bisection("coordinatePart", 3, A, coords)
 1
 ⋮
 8
```
"""
function rec_bisection(method, levels::Int, A, coords=Matrix{Float64}(undef,0,0), vn::AbstractVector=Vector{Int}())
    minpoints = 8
    n = size(A, 1)

    p = zeros(Int, n)
    
    if isempty(vn)
        println("Create vn")
        vn = collect(1:n)
    end

    if n < minpoints || levels < 1
        return Vector{Int}()
    else
        if !isempty(coords)
            p = method(A, coords)
            idx1 = findall(x -> x == 1, p)
            idx2 = findall(x -> x == 2, p)
            coords1 = coords[idx1, :]
            coords2 = coords[idx2, :]
        else
            p = method(A)
            idx1 = findall(x -> x == 1, p)
            idx2 = findall(x -> x == 2, p)
            coords1 = coords2 = zeros(0)
        end

        if isempty(idx1) || isempty(idx2)
            return Vector{Int}()
        end
        

        vn1 = vn[idx1]
        vn2 = vn[idx2]

        A1 = A[idx1, idx1]
        A2 = A[idx2, idx2]

        if levels > 1
            levels -= 1
            p1 = rec_bisection(method, levels, A1, coords1, vn1)
            p2 = rec_bisection(method, levels, A2, coords2, vn2)
            return vcat(p1, p2 .+ (isempty(p1) ? 0 : maximum(p1)))[sortperm(vcat(vn1, vn2), rev=true)]
        end

        return p[sortperm(vn)]
    end
end
