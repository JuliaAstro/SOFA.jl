export iauRxp
"""
Multiply a p-vector by an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
    r        double[3][3]    r-matrix
    p        double[3]       p-vector

### Returned
    rp       double[3]       r * p

Note:
    It is permissible for p and rp to be the same array.

Called:
    iauCp        copy p-vector

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauRxp(r::AbstractMatrix{<:Real}, p::AbstractVector{<:Real})
    rp = zeros(Float64, 3)
    ccall(
        (:iauRxp, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
        convert(Matrix{Float64}, r'),
        convert(Vector{Float64}, p),
        rp
    )

    return SVector{3}(rp)
end
