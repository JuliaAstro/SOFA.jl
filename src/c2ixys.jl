export iauC2ixys
"""
Form the celestial to intermediate-frame-of-date matrix given the CIP
X,Y and the CIO locator s.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   x,y      double         Celestial Intermediate Pole (Note 1)
   s        double         the CIO locator s (Note 2)

Returned:
   rc2i     double[3][3]   celestial-to-intermediate matrix (Note 3)

Notes:

1. The Celestial Intermediate Pole coordinates are the x,y
   components of the unit vector in the Geocentric Celestial
   Reference System.

2. The CIO locator s (in radians) positions the Celestial
   Intermediate Origin on the equator of the CIP.

3. The matrix rc2i is the first stage in the transformation from
   celestial to terrestrial coordinates:

      [TRS] = RPOM * R_3(ERA) * rc2i * [CRS]

            = RC2T * [CRS]

   where [CRS] is a vector in the Geocentric Celestial Reference
   System and [TRS] is a vector in the International Terrestrial
   Reference System (see IERS Conventions 2003), ERA is the Earth
   Rotation Angle and RPOM is the polar motion matrix.

Called:
   iauIr        initialize r-matrix to identity
   iauRz        rotate around Z-axis
   iauRy        rotate around Y-axis

Reference:

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
   IERS Technical Note No. 32, BKG (2004)

This revision:  2014 November 7

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauC2ixys(double x, double y, double s, double rc2i[3][3])

function iauC2ixys(x::Real, y::Real, s::Real)

   # Allocate return value
   rc2i = zeros(Float64, 3, 3)

   ccall((:iauC2ixys, libsofa_c), Cvoid, 
         (Cdouble, Cdouble, Cdouble,
         Ptr{Cdouble}), 
         convert(Float64, x), convert(Float64, y), convert(Float64, s),
         rc2i)

   return SMatrix{3,3}(rc2i')
end