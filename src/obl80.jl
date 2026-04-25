export iauObl80
"""
Mean obliquity of the ecliptic, IAU 1980 model.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  canonical model.

Given:
   date1,date2   double    TT as a 2-part Julian Date (Note 1)

Returned (function value):
                  double    obliquity of the ecliptic (radians, Note 2)

Notes:

1. The TT date date1+date2 is a Julian Date, apportioned in any
   convenient way between the two arguments.  For example,
   JD(TT)=2450123.7 could be expressed in any of these ways,
   among others:

         date1          date2

      2450123.7           0.0       (JD method)
      2451545.0       -1421.3       (J2000 method)
      2400000.5       50123.2       (MJD method)
      2450123.5           0.2       (date & time method)

   The JD method is the most natural and convenient to use in
   cases where the loss of several decimal digits of resolution
   is acceptable.  The J2000 method is best matched to the way
   the argument is handled internally and will deliver the
   optimum resolution.  The MJD method and the date & time methods
   are both good compromises between resolution and convenience.

2. The result is the angle between the ecliptic and mean equator of
   date date1+date2.

Reference:

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992),
   Expression 3.222-1 (p114).

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauObl80(double date1, double date2)

function iauObl80(date1::Real, date2::Real)
   return ccall((:iauObl80, libsofa_c), Cdouble,
        (Cdouble, Cdouble),
        convert(Float64, date1), convert(Float64, date2))
end