export iauRxp
"""
Multiply a p-vector by an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
    r        double[3][3]    r-matrix
    p        double[3]       p-vector

Returned:
    rp       double[3]       r * p

Note:
    It is permissible for p and rp to be the same array.

Called:
    iauCp        copy p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauRxp(double r[3][3], double p[3], double rp[3])
function iauRxp(r::AbstractMatrix{<:Real}, p::AbstractVector{<:Real})
    rp = zeros(Float64, 3)
    ccall((:iauRxp, libsofa_c), Cvoid,
          (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          convert(Array{Float64, 2}, r'),
          convert(Array{Float64, 1}, p),
          rp)

    return SVector{3}(rp)
 end