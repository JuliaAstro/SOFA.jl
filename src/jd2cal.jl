export iauJd2cal
"""
Julian Date to Gregorian year, month, day, and fraction of a day.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   dj1,dj2   double   Julian Date (Notes 1, 2)

Returned (arguments):
   iy        int      year
   im        int      month
   id        int      day
   fd        double   fraction of day

Returned (function value):
            int      status:
                        0 = OK
                        -1 = unacceptable date (Note 1)

Notes:

1. The earliest valid date is -68569.5 (-4900 March 1).  The
   largest value accepted is 1e9.

2. The Julian Date is apportioned in any convenient way between
   the arguments dj1 and dj2.  For example, JD=2450123.7 could
   be expressed in any of these ways, among others:

         dj1             dj2

      2450123.7           0.0       (JD method)
      2451545.0       -1421.3       (J2000 method)
      2400000.5       50123.2       (MJD method)
      2450123.5           0.2       (date & time method)

3. In early eras the conversion is from the "proleptic Gregorian
   calendar";  no account is taken of the date(s) of adoption of
   the Gregorian calendar, nor is the AD/BC numbering convention
   observed.

Reference:

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992),
   Section 12.92 (p604).

This revision:  2017 January 12

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauJd2cal(double dj1, double dj2,
#               int *iy, int *im, int *id, double *fd)

function iauJd2cal(dj1::Real, dj2::Real)
   ref_iy = Ref{Int32}(0.0)
   ref_im = Ref{Int32}(0.0)
   ref_id = Ref{Int32}(0.0)
   ref_fd = Ref{Float64}(0.0)

   status = ccall((:iauJd2cal, libsofa_c), Cint, 
       (Cdouble, Cdouble, Ref{Cint}, Ref{Cint}, Ref{Cint}, Ref{Cdouble}), 
       convert(Float64, dj1), convert(Float64, dj2), ref_iy, ref_im, ref_id, ref_fd)

   if status != 0
       @warn "iauJd2cal return non-zero exit code"
   end

   return status, ref_iy[], ref_im[], ref_id[], ref_fd[]
end