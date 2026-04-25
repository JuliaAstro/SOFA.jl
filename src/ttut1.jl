export iauTtut1
"""
Time scale transformation:  Terrestrial Time, TT, to Universal Time,
UT1.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

Given:
   tt1,tt2    double    TT as a 2-part Julian Date
   dt         double    TT-UT1 in seconds

Returned:
   ut11,ut12  double    UT1 as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Notes:

1. tt1+tt2 is Julian Date, apportioned in any convenient way between
   the two arguments, for example where tt1 is the Julian Day Number
   and tt2 is the fraction of a day.  The returned ut11,ut12 follow
   suit.

2. The argument dt is classical Delta T.

Reference:

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauTtut1(double tt1, double tt2, double dt,
#              double *ut11, double *ut12)

function iauTtut1(tt1::Real, tt2::Real, dt::Real)
   ref_tdb1 = Ref{Float64}(0.0)
   ref_tdb2 = Ref{Float64}(0.0)

   status = ccall((:iauTtut1, libsofa_c), Cint,
                   (Cdouble, Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
                   convert(Float64, tt1), convert(Float64, tt2), convert(Float64, dt),
                   ref_tdb1, ref_tdb2)

   return status, ref_tdb1[], ref_tdb2[]
end