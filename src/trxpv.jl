export iauTrxpv
"""
Multiply a pv-vector by the transpose of an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   r        double[3][3]    r-matrix
   pv       double[2][3]    pv-vector

Returned:
   trpv     double[2][3]    r * pv

Note:
   It is permissible for pv and trpv to be the same array.

Called:
   iauTr        transpose r-matrix
   iauRxpv      product of r-matrix and pv-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauTrxpv(double r[3][3], double pv[2][3], double trpv[2][3])

function iauTrxpv(r::AbstractMatrix{<:Real}, pv::AbstractMatrix{<:Real})
   trpv = zeros(Float64, 3, 2)

   ccall((:iauTrxpv, libsofa_c), Cvoid,
       (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Array{Float64, 2}, r'),
       convert(Array{Float64, 2}, pv'),
       trpv)

   return SMatrix{2,3}(trpv')
end