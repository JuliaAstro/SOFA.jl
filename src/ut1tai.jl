export iauUt1tai
"""
Time scale transformation:  Universal Time, UT1, to International
Atomic Time, TAI.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

Given:
   ut11,ut12  double    UT1 as a 2-part Julian Date
   dta        double    UT1-TAI in seconds

Returned:
   tai1,tai2  double    TAI as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Notes:

1. ut11+ut12 is Julian Date, apportioned in any convenient way
   between the two arguments, for example where ut11 is the Julian
   Day Number and ut12 is the fraction of a day.  The returned
   tai1,tai2 follow suit.

2. The argument dta, i.e. UT1-TAI, is an observed quantity, and is
   available from IERS tabulations.

Reference:

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauUt1tai(double ut11, double ut12, double dta,
#               double *tai1, double *tai2)

function iauUt1tai(ut11::Real, ut12::Real, dta::Real)
   ref_tai1 = Ref{Float64}(0.0)
   ref_tai2 = Ref{Float64}(0.0)

   status = ccall((:iauUt1tai, libsofa_c), Cint,
                   (Cdouble, Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
                   convert(Float64, ut11), convert(Float64, ut12), convert(Float64, dta),
                   ref_tai1, ref_tai2)

   return status, ref_tai1[], ref_tai2[]
end