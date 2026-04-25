export iauUt1tt
"""
Time scale transformation:  Universal Time, UT1, to Terrestrial
Time, TT.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

Given:
   ut11,ut12  double    UT1 as a 2-part Julian Date
   dt         double    TT-UT1 in seconds

Returned:
   tt1,tt2    double    TT as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Notes:

1. ut11+ut12 is Julian Date, apportioned in any convenient way
   between the two arguments, for example where ut11 is the Julian
   Day Number and ut12 is the fraction of a day.  The returned
   tt1,tt2 follow suit.

2. The argument dt is classical Delta T.

Reference:

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauUt1tt(double ut11, double ut12, double dt,
#              double *tt1, double *tt2)

function iauUt1tt(ut11::Real, ut12::Real, dt::Real)
   ref_tt1 = Ref{Float64}(0.0)
   ref_tt2 = Ref{Float64}(0.0)

   status = ccall((:iauUt1tt, libsofa_c), Cint,
                   (Cdouble, Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
                   convert(Float64, ut11), convert(Float64, ut12), convert(Float64, dt),
                   ref_tt1, ref_tt2)

   return status, ref_tt1[], ref_tt2[]
end