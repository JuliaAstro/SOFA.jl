export iauTaiut1
"""
Time scale transformation:  International Atomic Time, TAI, to
Universal Time, UT1.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

Given:
   tai1,tai2  double    TAI as a 2-part Julian Date
   dta        double    UT1-TAI in seconds

Returned:
   ut11,ut12  double    UT1 as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Notes:

1. tai1+tai2 is Julian Date, apportioned in any convenient way
   between the two arguments, for example where tai1 is the Julian
   Day Number and tai2 is the fraction of a day.  The returned
   UT11,UT12 follow suit.

2. The argument dta, i.e. UT1-TAI, is an observed quantity, and is
   available from IERS tabulations.

Reference:

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauTaiut1(double tai1, double tai2, double dta,
#               double *ut11, double *ut12)

function iauTaiut1(tai1::Real, tai2::Real, dta::Real)
   ref_ut11 = Ref{Float64}(0.0)
   ref_ut12 = Ref{Float64}(0.0)

   status = ccall((:iauTaiut1, libsofa_c), Cint,
                   (Cdouble, Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
                   convert(Float64, tai1), convert(Float64, tai2), convert(Float64, dta),
                   ref_ut11, ref_ut12)

   return status, ref_ut11[], ref_ut12[]
end