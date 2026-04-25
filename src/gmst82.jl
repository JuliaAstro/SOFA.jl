export iauGmst82
"""
Universal Time to Greenwich mean sidereal time (IAU 1982 model).

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  canonical model.

Given:
   dj1,dj2    double    UT1 Julian Date (see note)

Returned (function value):
               double    Greenwich mean sidereal time (radians)

Notes:

1. The UT1 date dj1+dj2 is a Julian Date, apportioned in any
   convenient way between the arguments dj1 and dj2.  For example,
   JD(UT1)=2450123.7 could be expressed in any of these ways,
   among others:

            dj1            dj2

      2450123.7          0          (JD method)
         2451545        -1421.3       (J2000 method)
      2400000.5       50123.2       (MJD method)
      2450123.5         0.2         (date & time method)

   The JD method is the most natural and convenient to use in
   cases where the loss of several decimal digits of resolution
   is acceptable.  The J2000 and MJD methods are good compromises
   between resolution and convenience.  The date & time method is
   best matched to the algorithm used:  maximum accuracy (or, at
   least, minimum noise) is delivered when the dj1 argument is for
   0hrs UT1 on the day in question and the dj2 argument lies in the
   range 0 to 1, or vice versa.

2. The algorithm is based on the IAU 1982 expression.  This is
   always described as giving the GMST at 0 hours UT1.  In fact, it
   gives the difference between the GMST and the UT, the steady
   4-minutes-per-day drawing-ahead of ST with respect to UT.  When
   whole days are ignored, the expression happens to equal the GMST
   at 0 hours UT1 each day.

3. In this function, the entire UT1 (the sum of the two arguments
   dj1 and dj2) is used directly as the argument for the standard
   formula, the constant term of which is adjusted by 12 hours to
   take account of the noon phasing of Julian Date.  The UT1 is then
   added, but omitting whole days to conserve accuracy.

Called:
   iauAnp       normalize angle into range 0 to 2pi

References:

   Transactions of the International Astronomical Union,
   XVIII B, 67 (1983).

   Aoki et al., Astron.Astrophys., 105, 359-361 (1982).

This revision:  2017 October 12

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauGmst82(double dj1, double dj2)

function iauGmst82(dj1::Real, dj2::Real)
   return ccall((:iauGmst82, libsofa_c), Cdouble,
               (Cdouble, Cdouble),
               convert(Float64, dj1), convert(Float64, dj2))
end