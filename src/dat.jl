export iauDat
"""
For a given UTC date, calculate Delta(AT) = TAI-UTC.

   :------------------------------------------:
   :                                          :
   :                 IMPORTANT                :
   :                                          :
   :  A new version of this function must be  :
   :  produced whenever a new leap second is  :
   :  announced.  There are four items to     :
   :  change on each such occasion:           :
   :                                          :
   :  1) A new line must be added to the set  :
   :     of statements that initialize the    :
   :     array "changes".                     :
   :                                          :
   :  2) The constant IYV must be set to the  :
   :     current year.                        :
   :                                          :
   :  3) The "Latest leap second" comment     :
   :     below must be set to the new leap    :
   :     second date.                         :
   :                                          :
   :  4) The "This revision" comment, later,  :
   :     must be set to the current date.     :
   :                                          :
   :  Change (2) must also be carried out     :
   :  whenever the function is re-issued,     :
   :  even if no leap seconds have been       :
   :  added.                                  :
   :                                          :
   :  Latest leap second:  2016 December 31   :
   :                                          :
   :__________________________________________:

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  user-replaceable support function.

Given:
   iy     int      UTC:  year (Notes 1 and 2)
   im     int            month (Note 2)
   id     int            day (Notes 2 and 3)
   fd     double         fraction of day (Note 4)

Returned:
   deltat double   TAI minus UTC, seconds

Returned (function value):
         int      status (Note 5):
                     1 = dubious year (Note 1)
                     0 = OK
                     -1 = bad year
                     -2 = bad month
                     -3 = bad day (Note 3)
                     -4 = bad fraction (Note 4)
                     -5 = internal error (Note 5)

Notes:

1. UTC began at 1960 January 1.0 (JD 2436934.5) and it is improper
   to call the function with an earlier date.  If this is attempted,
   zero is returned together with a warning status.

   Because leap seconds cannot, in principle, be predicted in
   advance, a reliable check for dates beyond the valid range is
   impossible.  To guard against gross errors, a year five or more
   after the release year of the present function (see the constant
   IYV) is considered dubious.  In this case a warning status is
   returned but the result is computed in the normal way.

   For both too-early and too-late years, the warning status is +1.
   This is distinct from the error status -1, which signifies a year
   so early that JD could not be computed.

2. If the specified date is for a day which ends with a leap second,
   the TAI-UTC value returned is for the period leading up to the
   leap second.  If the date is for a day which begins as a leap
   second ends, the TAI-UTC returned is for the period following the
   leap second.

3. The day number must be in the normal calendar range, for example
   1 through 30 for April.  The "almanac" convention of allowing
   such dates as January 0 and December 32 is not supported in this
   function, in order to avoid confusion near leap seconds.

4. The fraction of day is used only for dates before the
   introduction of leap seconds, the first of which occurred at the
   end of 1971.  It is tested for validity (0 to 1 is the valid
   range) even if not used;  if invalid, zero is used and status -4
   is returned.  For many applications, setting fd to zero is
   acceptable;  the resulting error is always less than 3 ms (and
   occurs only pre-1972).

5. The status value returned in the case where there are multiple
   errors refers to the first error detected.  For example, if the
   month and day are 13 and 32 respectively, status -2 (bad month)
   will be returned.  The "internal error" status refers to a
   case that is impossible but causes some compilers to issue a
   warning.

6. In cases where a valid result is not available, zero is returned.

References:

1. For dates from 1961 January 1 onwards, the expressions from the
   file ftp://maia.usno.navy.mil/ser7/tai-utc.dat are used.

2. The 5ms timestep at 1961 January 1 is taken from 2.58.1 (p87) of
   the 1992 Explanatory Supplement.

Called:
   iauCal2jd    Gregorian calendar to JD

This revision:  2017 October 7

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauDat(int iy, int im, int id, double fd, double *deltat )

function iauDat(iy::Real, im::Real, id::Real, fd::Real)
   # Allocate return values
   ref_dat = Ref{Float64}(0.0)

   status = ccall((:iauDat, libsofa_c), Cint,
                  (Cint, Cint, Cint, Cdouble, Ref{Cdouble}),
                  convert(Int32, iy), convert(Int32, im),
                  convert(Int32, id), convert(Float64, fd),
                  ref_dat)

   if status != 0
       @warn "Non-zero return code form iauD2dtf: $status"
   end

   return status, ref_dat[]
end