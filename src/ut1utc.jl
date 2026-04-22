export iauUt1utc
"""
Time scale transformation:  Universal Time, UT1, to Coordinated
Universal Time, UTC.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

Given:
   ut11,ut12  double   UT1 as a 2-part Julian Date (Note 1)
   dut1       double   Delta UT1: UT1-UTC in seconds (Note 2)

Returned:
   utc1,utc2  double   UTC as a 2-part quasi Julian Date (Notes 3,4)

Returned (function value):
               int      status: +1 = dubious year (Note 5)
                                 0 = OK
                              -1 = unacceptable date

Notes:

1. ut11+ut12 is Julian Date, apportioned in any convenient way
   between the two arguments, for example where ut11 is the Julian
   Day Number and ut12 is the fraction of a day.  The returned utc1
   and utc2 form an analogous pair, except that a special convention
   is used, to deal with the problem of leap seconds - see Note 3.

2. Delta UT1 can be obtained from tabulations provided by the
   International Earth Rotation and Reference Systems Service.  The
   value changes abruptly by 1s at a leap second;  however, close to
   a leap second the algorithm used here is tolerant of the "wrong"
   choice of value being made.

3. JD cannot unambiguously represent UTC during a leap second unless
   special measures are taken.  The convention in the present
   function is that the returned quasi JD day UTC1+UTC2 represents
   UTC days whether the length is 86399, 86400 or 86401 SI seconds.

4. The function iauD2dtf can be used to transform the UTC quasi-JD
   into calendar date and clock time, including UTC leap second
   handling.

5. The warning status "dubious year" flags UTCs that predate the
   introduction of the time scale or that are too far in the future
   to be trusted.  See iauDat for further details.

Called:
   iauJd2cal    JD to Gregorian calendar
   iauDat       delta(AT) = TAI-UTC
   iauCal2jd    Gregorian calendar to JD

References:

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
   IERS Technical Note No. 32, BKG (2004)

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauUt1utc(double ut11, double ut12, double dut1,
#               double *utc1, double *utc2)

function iauUt1utc(ut11::Real, ut12::Real, dta::Real)
   ref_tt1 = Ref{Float64}(0.0)
   ref_tt2 = Ref{Float64}(0.0)

   status = ccall((:iauUt1utc, libsofa_c), Cint,
                   (Cdouble, Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
                   convert(Float64, ut11), convert(Float64, ut12), convert(Float64, dta),
                   ref_tt1, ref_tt2)

   return status, ref_tt1[], ref_tt2[]
end