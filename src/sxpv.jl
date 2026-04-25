export iauSxpv
"""
Multiply a pv-vector by a scalar.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   s       double          scalar
   pv      double[2][3]    pv-vector

Returned:
   spv     double[2][3]    s * pv

Note:
   It is permissible for pv and spv to be the same array

Called:
   iauS2xpv     multiply pv-vector by two scalars

This revision:  2013 August 7

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauSxpv(double s, double pv[2][3], double spv[2][3])

function iauSxpv(s::Real, pv::AbstractMatrix{<:Real})
   spv = zeros(Float64, 3, 2)

   ccall((:iauSxpv, libsofa_c), Cvoid,
       (Cdouble, Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Float64, s),
       convert(Array{Float64, 2}, pv'),
       spv)

   return SMatrix{2,3}(spv')
end