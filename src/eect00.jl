export iauEect00
"""
Equation of the equinoxes complementary terms, consistent with
IAU 2000 resolutions.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  canonical model.

### Given
   date1,date2  double   TT as a 2-part Julian Date (Note 1)

Returned (function value):
                double   complementary terms (Note 2)

### Notes

1) The TT date date1+date2 is a Julian Date, apportioned in any
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

2) The "complementary terms" are part of the equation of the
   equinoxes (EE), classically the difference between apparent and
   mean Sidereal Time:

      GAST = GMST + EE

   with:

      EE = dpsi * cos(eps)

   where dpsi is the nutation in longitude and eps is the obliquity
   of date.  However, if the rotation of the Earth were constant in
   an inertial frame the classical formulation would lead to
   apparent irregularities in the UT1 timescale traceable to side-
   effects of precession-nutation.  In order to eliminate these
   effects from UT1, "complementary terms" were introduced in 1994
   (IAU, 1994) and took effect from 1997 (Capitaine and Gontier,
   1993):

      GAST = GMST + CT + EE

   By convention, the complementary terms are included as part of
   the equation of the equinoxes rather than as part of the mean
   Sidereal Time.  This slightly compromises the "geometrical"
   interpretation of mean sidereal time but is otherwise
   inconsequential.

   The present function computes CT in the above expression,
   compatible with IAU 2000 resolutions (Capitaine et al., 2002, and
   IERS Conventions 2003).

Called:
   iauFal03     mean anomaly of the Moon
   iauFalp03    mean anomaly of the Sun
   iauFaf03     mean argument of the latitude of the Moon
   iauFad03     mean elongation of the Moon from the Sun
   iauFaom03    mean longitude of the Moon's ascending node
   iauFave03    mean longitude of Venus
   iauFae03     mean longitude of Earth
   iauFapa03    general accumulated precession in longitude

### References

   Capitaine, N. & Gontier, A.-M., Astron.Astrophys., 275,
   645-650 (1993)

   Capitaine, N., Wallace, P.T. and McCarthy, D.D., "Expressions to
   implement the IAU 2000 definition of UT1", Astron.Astrophys., 406,
   1135-1149 (2003)

   IAU Resolution C7, Recommendation 3 (1994)

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
   IERS Technical Note No. 32, BKG (2004)

This revision:  2017 October 12

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauEect00(date1::Real, date2::Real)
    return ccall(
        (:iauEect00, libsofa_c), Cdouble,
        (Cdouble, Cdouble),
        convert(Float64, date1), convert(Float64, date2)
    )
end
