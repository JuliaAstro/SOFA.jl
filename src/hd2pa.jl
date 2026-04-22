export iauHd2pa
"""
Parallactic angle for a given hour angle and declination.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   ha     double     hour angle
   dec    double     declination
   phi    double     site latitude

Returned (function value):
         double     parallactic angle

Notes:

1.  All the arguments are angles in radians.

2.  The parallactic angle at a point in the sky is the position
   angle of the vertical, i.e. the angle between the directions to
   the north celestial pole and to the zenith respectively.

3.  The result is returned in the range -pi to +pi.

4.  At the pole itself a zero result is returned.

5.  The latitude phi is pi/2 minus the angle between the Earth's
   rotation axis and the adopted zenith.  In many applications it
   will be sufficient to use the published geodetic latitude of the
   site.  In very precise (sub-arcsecond) applications, phi can be
   corrected for polar motion.

6.  Should the user wish to work with respect to the astronomical
   zenith rather than the geodetic zenith, phi will need to be
   adjusted for deflection of the vertical (often tens of
   arcseconds), and the zero point of the hour angle ha will also
   be affected.

Reference:
   Smart, W.M., "Spherical Astronomy", Cambridge University Press,
   6th edition (Green, 1977), p49.

Last revision:   2017 September 12

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauHd2pa (double ha, double dec, double phi)

function iauHd2pa(ha::Real, dec::Real, phi::Real)
   return ccall((:iauHd2pa, libsofa_c), Cdouble, 
         (Cdouble, Cdouble, Cdouble), 
          convert(Float64, ha), convert(Float64, dec),
          convert(Float64, phi))
end