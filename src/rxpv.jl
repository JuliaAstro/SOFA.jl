export iauRxpv
"""
Multiply a pv-vector by an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   r        double[3][3]    r-matrix
   pv       double[2][3]    pv-vector

Returned:
   rpv      double[2][3]    r * pv

Note:
   It is permissible for pv and rpv to be the same array.

Called:
   iauRxp       product of r-matrix and p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauRxpv(double r[3][3], double pv[2][3], double rpv[2][3])
function iauRxpv(r::AbstractMatrix{<:Real}, pv::AbstractMatrix{<:Real})
   rpv = zeros(Float64, 3, 2)
   ccall((:iauRxpv, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
         convert(Array{Float64, 2}, r'),
         convert(Array{Float64, 2}, pv'),
         rpv)

   return SMatrix{2,3}(rpv')
end