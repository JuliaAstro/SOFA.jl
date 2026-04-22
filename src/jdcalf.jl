export iauJdcalf
"""
Julian Date to Gregorian Calendar, expressed in a form convenient
for formatting messages:  rounded to a specified precision.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   ndp       int      number of decimal places of days in fraction
   dj1,dj2   double   dj1+dj2 = Julian Date (Note 1)

Returned:
   iymdf     int[4]   year, month, day, fraction in Gregorian
                     calendar

Returned (function value):
            int      status:
                        -1 = date out of range
                        0 = OK
                        +1 = NDP not 0-9 (interpreted as 0)

Notes:

1. The Julian Date is apportioned in any convenient way between
   the arguments dj1 and dj2.  For example, JD=2450123.7 could
   be expressed in any of these ways, among others:

            dj1            dj2

      2450123.7           0.0       (JD method)
      2451545.0       -1421.3       (J2000 method)
      2400000.5       50123.2       (MJD method)
      2450123.5           0.2       (date & time method)

2. In early eras the conversion is from the "Proleptic Gregorian
   Calendar";  no account is taken of the date(s) of adoption of
   the Gregorian Calendar, nor is the AD/BC numbering convention
   observed.

3. Refer to the function iauJd2cal.

4. NDP should be 4 or less if internal overflows are to be
   avoided on machines which use 16-bit integers.

Called:
   iauJd2cal    JD to Gregorian calendar

Reference:

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992),
   Section 12.92 (p604).

This revision:  2016 December 2

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauJdcalf(int ndp, double dj1, double dj2, int iymdf[4])
function iauJdcalf(ndp::Int, dj1::Real, dj2::Real)
   iymdf = zeros(Int32, 4)

   status = ccall((:iauJdcalf, libsofa_c), Cint, 
       (Cint, Cdouble, Cdouble, Ptr{Cint}), 
       convert(Int32, ndp), convert(Float64, dj1), convert(Float64, dj2), iymdf)

   if status != 0
       @warn "iauJdcalf return non-zero exit code"
   end

   return status, SVector{4}(iymdf)
end