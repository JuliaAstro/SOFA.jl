export iauS2pv
"""
Convert position/velocity from spherical to Cartesian coordinates.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   theta    double          longitude angle (radians)
   phi      double          latitude angle (radians)
   r        double          radial distance
   td       double          rate of change of theta
   pd       double          rate of change of phi
   rd       double          rate of change of r

Returned:
   pv       double[2][3]    pv-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauS2pv(double theta, double phi, double r,
#              double td, double pd, double rd,
#              double pv[2][3])

function iauS2pv(theta::Real, phi::Real, r::Real,
                td::Real, pd::Real, rd::Real)
   pv = zeros(Float64, 3, 2)

   ccall((:iauS2pv, libsofa_c), Cvoid,
       (Cdouble, Cdouble, Cdouble,
       Cdouble, Cdouble, Cdouble,
       Ptr{Cdouble}),
       convert(Float64, theta),
       convert(Float64, phi),
       convert(Float64, r),
       convert(Float64, td),
       convert(Float64, pd),
       convert(Float64, rd),
       pv)

   return SMatrix{2,3}(pv')
end