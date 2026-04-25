export iauTrxp
"""
Multiply a p-vector by the transpose of an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   r        double[3][3]   r-matrix
   p        double[3]      p-vector

Returned:
   trp      double[3]      r * p

Note:
   It is permissible for p and trp to be the same array.

Called:
   iauTr        transpose r-matrix
   iauRxp       product of r-matrix and p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauTrxp(double r[3][3], double p[3], double trp[3])

function iauTrxp(r::AbstractMatrix{<:Real}, p::AbstractVector{<:Real})
   trp = zeros(Float64, 3)

   ccall((:iauTrxp, libsofa_c), Cvoid,
       (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Array{Float64, 2}, r'),
       convert(Array{Float64, 1}, p),
       trp)

   return SVector{3}(trp)
end