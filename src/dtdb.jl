export iauDtdb
"""
An approximation to TDB-TT, the difference between barycentric
dynamical time and terrestrial time, for an observer on the Earth.

The different time scales - proper, coordinate and realized - are
related to each other:

         TAI             <-  physically realized
            :
         offset            <-  observed (nominally +32.184s)
            :
         TT              <-  terrestrial time
            :
   rate adjustment (L_G)   <-  definition of TT
            :
         TCG             <-  time scale for GCRS
            :
   "periodic" terms      <-  iauDtdb  is an implementation
            :
   rate adjustment (L_C)   <-  function of solar-system ephemeris
            :
         TCB             <-  time scale for BCRS
            :
   rate adjustment (-L_B)  <-  definition of TDB
            :
         TDB             <-  TCB scaled to track TT
            :
   "periodic" terms      <-  -iauDtdb is an approximation
            :
         TT              <-  terrestrial time

Adopted values for the various constants can be found in the IERS
Conventions (McCarthy & Petit 2003).

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   date1,date2   double  date, TDB (Notes 1-3)
   ut            double  universal time (UT1, fraction of one day)
   elong         double  longitude (east positive, radians)
   u             double  distance from Earth spin axis (km)
   v             double  distance north of equatorial plane (km)

Returned (function value):
                  double  TDB-TT (seconds)

Notes:

1. The date date1+date2 is a Julian Date, apportioned in any
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

   Although the date is, formally, barycentric dynamical time (TDB),
   the terrestrial dynamical time (TT) can be used with no practical
   effect on the accuracy of the prediction.

2. TT can be regarded as a coordinate time that is realized as an
   offset of 32.184s from International Atomic Time, TAI.  TT is a
   specific linear transformation of geocentric coordinate time TCG,
   which is the time scale for the Geocentric Celestial Reference
   System, GCRS.

3. TDB is a coordinate time, and is a specific linear transformation
   of barycentric coordinate time TCB, which is the time scale for
   the Barycentric Celestial Reference System, BCRS.

4. The difference TCG-TCB depends on the masses and positions of the
   bodies of the solar system and the velocity of the Earth.  It is
   dominated by a rate difference, the residual being of a periodic
   character.  The latter, which is modeled by the present function,
   comprises a main (annual) sinusoidal term of amplitude
   approximately 0.00166 seconds, plus planetary terms up to about
   20 microseconds, and lunar and diurnal terms up to 2 microseconds.
   These effects come from the changing transverse Doppler effect
   and gravitational red-shift as the observer (on the Earth's
   surface) experiences variations in speed (with respect to the
   BCRS) and gravitational potential.

5. TDB can be regarded as the same as TCB but with a rate adjustment
   to keep it close to TT, which is convenient for many applications.
   The history of successive attempts to define TDB is set out in
   Resolution 3 adopted by the IAU General Assembly in 2006, which
   defines a fixed TDB(TCB) transformation that is consistent with
   contemporary solar-system ephemerides.  Future ephemerides will
   imply slightly changed transformations between TCG and TCB, which
   could introduce a linear drift between TDB and TT;  however, any
   such drift is unlikely to exceed 1 nanosecond per century.

6. The geocentric TDB-TT model used in the present function is that of
   Fairhead & Bretagnon (1990), in its full form.  It was originally
   supplied by Fairhead (private communications with P.T.Wallace,
   1990) as a Fortran subroutine.  The present C function contains an
   adaptation of the Fairhead code.  The numerical results are
   essentially unaffected by the changes, the differences with
   respect to the Fairhead & Bretagnon original being at the 1e-20 s
   level.

   The topocentric part of the model is from Moyer (1981) and
   Murray (1983), with fundamental arguments adapted from
   Simon et al. 1994.  It is an approximation to the expression
   ( v / c ) . ( r / c ), where v is the barycentric velocity of
   the Earth, r is the geocentric position of the observer and
   c is the speed of light.

   By supplying zeroes for u and v, the topocentric part of the
   model can be nullified, and the function will return the Fairhead
   & Bretagnon result alone.

7. During the interval 1950-2050, the absolute accuracy is better
   than +/- 3 nanoseconds relative to time ephemerides obtained by
   direct numerical integrations based on the JPL DE405 solar system
   ephemeris.

8. It must be stressed that the present function is merely a model,
   and that numerical integration of solar-system ephemerides is the
   definitive method for predicting the relationship between TCG and
   TCB and hence between TT and TDB.

References:

   Fairhead, L., & Bretagnon, P., Astron.Astrophys., 229, 240-247
   (1990).

   IAU 2006 Resolution 3.

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
   IERS Technical Note No. 32, BKG (2004)

   Moyer, T.D., Cel.Mech., 23, 33 (1981).

   Murray, C.A., Vectorial Astrometry, Adam Hilger (1983).

   Seidelmann, P.K. et al., Explanatory Supplement to the
   Astronomical Almanac, Chapter 2, University Science Books (1992).

   Simon, J.L., Bretagnon, P., Chapront, J., Chapront-Touze, M.,
   Francou, G. & Laskar, J., Astron.Astrophys., 282, 663-683 (1994).

This revision:  2018 January 2

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauDtdb(double date1, double date2,
#                double ut, double elong, double u, double v)

function iauDtdb(date1::Real, date2::Real,
                 ut::Real, elong::Real,
                 u::Real, v::Real)

   tdb_tt = ccall((:iauDtdb, libsofa_c), Cdouble,
            (Cdouble, Cdouble, Cdouble,
            Cdouble, Cdouble, Cdouble),
            convert(Float64, date1), convert(Float64, date2),
            convert(Float64, ut), convert(Float64, elong),
            convert(Float64, u), convert(Float64, v))

   return tdb_tt
end