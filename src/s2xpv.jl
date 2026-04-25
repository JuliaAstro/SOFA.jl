export iauS2xpv
"""
**  Multiply a pv-vector by two scalars.
**
**  This function is part of the International Astronomical Union's
**  SOFA (Standards Of Fundamental Astronomy) software collection.
**
**  Status:  vector/matrix support function.
**
**  Given:
**     s1     double         scalar to multiply position component by
**     s2     double         scalar to multiply velocity component by
**     pv     double[2][3]   pv-vector
**
**  Returned:
**     spv    double[2][3]   pv-vector: p scaled by s1, v scaled by s2
**
**  Note:
**     It is permissible for pv and spv to be the same array.
**
**  Called:
**     iauSxp       multiply p-vector by scalar
**
**  This revision:  2013 June 18
**
**  SOFA release 2018-01-30
**
**  Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauS2xpv(double s1, double s2, double pv[2][3], double spv[2][3])

function iauS2xpv(s1::Real, s2::Real, pv::AbstractMatrix{<:Real})
   spv = zeros(Float64, 3, 2)

   ccall((:iauS2xpv, libsofa_c), Cvoid,
       (Cdouble, Cdouble,
       Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Float64, s1),
       convert(Float64, s2),
       convert(Array{Float64, 2}, pv'),
       spv)

   return SMatrix{2,3}(spv')
end