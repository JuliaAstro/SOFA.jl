export iauEqeq94
"""
Equation of the equinoxes, IAU 1994 model.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  canonical model.

### Given
   date1,date2   double     TDB date (Note 1)

Returned (function value):
                 double     equation of the equinoxes (Note 2)

### Notes

1) The date date1+date2 is a Julian Date, apportioned in any
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

2) The result, which is in radians, operates in the following sense:

      Greenwich apparent ST = GMST + equation of the equinoxes

Called:
   iauAnpm      normalize angle into range +/- pi
   iauNut80     nutation, IAU 1980
   iauObl80     mean obliquity, IAU 1980

### References

   IAU Resolution C7, Recommendation 3 (1994).

   Capitaine, N. & Gontier, A.-M., 1993, Astron.Astrophys., 275,
   645-650.

This revision:  2017 October 12

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauEqeq94(date1::Real, date2::Real)
   return ccall((:iauEqeq94, libsofa_c), Cdouble,
      (Cdouble, Cdouble),
      convert(Float64, date1), convert(Float64, date2))
end
