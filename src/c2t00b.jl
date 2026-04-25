export iauC2t00b
"""
Form the celestial to terrestrial matrix given the date, the UT1 and
the polar motion, using the IAU 2000B nutation model.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   tta,ttb  double         TT as a 2-part Julian Date (Note 1)
   uta,utb  double         UT1 as a 2-part Julian Date (Note 1)
   xp,yp    double         coordinates of the pole (radians, Note 2)

Returned:
   rc2t     double[3][3]   celestial-to-terrestrial matrix (Note 3)

Notes:

1. The TT and UT1 dates tta+ttb and uta+utb are Julian Dates,
   apportioned in any convenient way between the arguments uta and
   utb.  For example, JD(UT1)=2450123.7 could be expressed in any of
   these ways, among others:

            uta            utb

      2450123.7           0.0       (JD method)
      2451545.0       -1421.3       (J2000 method)
      2400000.5       50123.2       (MJD method)
      2450123.5           0.2       (date & time method)

   The JD method is the most natural and convenient to use in
   cases where the loss of several decimal digits of resolution is
   acceptable.  The J2000 and MJD methods are good compromises
   between resolution and convenience.  In the case of uta,utb, the
   date & time method is best matched to the Earth rotation angle
   algorithm used:  maximum precision is delivered when the uta
   argument is for 0hrs UT1 on the day in question and the utb
   argument lies in the range 0 to 1, or vice versa.

2. The arguments xp and yp are the coordinates (in radians) of the
   Celestial Intermediate Pole with respect to the International
   Terrestrial Reference System (see IERS Conventions 2003),
   measured along the meridians to 0 and 90 deg west respectively.

3. The matrix rc2t transforms from celestial to terrestrial
   coordinates:

      [TRS] = RPOM * R_3(ERA) * RC2I * [CRS]

            = rc2t * [CRS]

   where [CRS] is a vector in the Geocentric Celestial Reference
   System and [TRS] is a vector in the International Terrestrial
   Reference System (see IERS Conventions 2003), RC2I is the
   celestial-to-intermediate matrix, ERA is the Earth rotation
   angle and RPOM is the polar motion matrix.

4. The present function is faster, but slightly less accurate (about
   1 mas), than the iauC2t00a function.

Called:
   iauC2i00b    celestial-to-intermediate matrix, IAU 2000B
   iauEra00     Earth rotation angle, IAU 2000
   iauPom00     polar motion matrix
   iauC2tcio    form CIO-based celestial-to-terrestrial matrix

Reference:

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
   IERS Technical Note No. 32, BKG (2004)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauC2t00b(double tta, double ttb, double uta, double utb,
#                double xp, double yp, double rc2t[3][3])

function iauC2t00b(tta::Real, ttb::Real, uta::Real, utb::Real, xp::Real, yp::Real)

   # Allocate return value
   rc2t = zeros(Float64, 3, 3)

   ccall((:iauC2t00b, libsofa_c), Cvoid,
         (Cdouble, Cdouble, Cdouble,
         Cdouble, Cdouble, Cdouble,
         Ptr{Cdouble}),
         convert(Float64, tta), convert(Float64, ttb),
         convert(Float64, uta), convert(Float64, utb),
         convert(Float64, xp), convert(Float64, yp),
         rc2t)

   return SMatrix{3,3}(rc2t')
end