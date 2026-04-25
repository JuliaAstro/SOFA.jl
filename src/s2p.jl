export iauS2p
"""
Convert spherical polar coordinates to p-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   theta   double       longitude angle (radians)
   phi     double       latitude angle (radians)
   r       double       radial distance

Returned:
   p       double[3]    Cartesian coordinates

Called:
   iauS2c       spherical coordinates to unit vector
   iauSxp       multiply p-vector by scalar

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
# void iauS2p(double theta, double phi, double r, double p[3])
function iauS2p(theta::Real, phi::Real, r::Real)
   p = zeros(Float64, 3)

   ccall((:iauS2p, libsofa_c), Cvoid,
       (Cdouble, Cdouble, Cdouble, Ptr{Cdouble}),
       convert(Float64, theta),
       convert(Float64, phi),
       convert(Float64, r),
       p)

   return SVector{3}(p)
end