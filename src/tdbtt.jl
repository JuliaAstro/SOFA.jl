export iauTdbtt
"""
Time scale transformation:  Barycentric Dynamical Time, TDB, to
Terrestrial Time, TT.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

Given:
   tdb1,tdb2  double    TDB as a 2-part Julian Date
   dtr        double    TDB-TT in seconds

Returned:
   tt1,tt2    double    TT as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Notes:

1. tdb1+tdb2 is Julian Date, apportioned in any convenient way
   between the two arguments, for example where tdb1 is the Julian
   Day Number and tdb2 is the fraction of a day.  The returned
   tt1,tt2 follow suit.

2. The argument dtr represents the quasi-periodic component of the
   GR transformation between TT and TCB.  It is dependent upon the
   adopted solar-system ephemeris, and can be obtained by numerical
   integration, by interrogating a precomputed time ephemeris or by
   evaluating a model such as that implemented in the SOFA function
   iauDtdb.   The quantity is dominated by an annual term of 1.7 ms
   amplitude.

3. TDB is essentially the same as Teph, the time argument for the
   JPL solar system ephemerides.

References:

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
   IERS Technical Note No. 32, BKG (2004)

   IAU 2006 Resolution 3

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauTdbtt(double tdb1, double tdb2, double dtr,
#              double *tt1, double *tt2 )

function iauTdbtt(tdb1::Real, tdb2::Real, dtr::Real)
   ref_tt1 = Ref{Float64}(0.0)
   ref_tt2 = Ref{Float64}(0.0)

   status = ccall((:iauTdbtt, libsofa_c), Cint,
                   (Cdouble, Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
                   convert(Float64, tdb1), convert(Float64, tdb2), convert(Float64, dtr),
                   ref_tt1, ref_tt2)

   return status, ref_tt1[], ref_tt2[]
end