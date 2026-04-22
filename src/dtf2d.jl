export iauDtf2d
"""
Encode date and time fields into 2-part Julian Date (or in the case
of UTC a quasi-JD form that includes special provision for leap
seconds).

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   scale     char[]  time scale ID (Note 1)
   iy,im,id  int     year, month, day in Gregorian calendar (Note 2)
   ihr,imn   int     hour, minute
   sec       double  seconds

Returned:
   d1,d2     double  2-part Julian Date (Notes 3,4)

Returned (function value):
            int     status: +3 = both of next two
                              +2 = time is after end of day (Note 5)
                              +1 = dubious year (Note 6)
                              0 = OK
                              -1 = bad year
                              -2 = bad month
                              -3 = bad day
                              -4 = bad hour
                              -5 = bad minute
                              -6 = bad second (<0)

Notes:

1. scale identifies the time scale.  Only the value "UTC" (in upper
   case) is significant, and enables handling of leap seconds (see
   Note 4).

2. For calendar conventions and limitations, see iauCal2jd.

3. The sum of the results, d1+d2, is Julian Date, where normally d1
   is the Julian Day Number and d2 is the fraction of a day.  In the
   case of UTC, where the use of JD is problematical, special
   conventions apply:  see the next note.

4. JD cannot unambiguously represent UTC during a leap second unless
   special measures are taken.  The SOFA internal convention is that
   the quasi-JD day represents UTC days whether the length is 86399,
   86400 or 86401 SI seconds.  In the 1960-1972 era there were
   smaller jumps (in either direction) each time the linear UTC(TAI)
   expression was changed, and these "mini-leaps" are also included
   in the SOFA convention.

5. The warning status "time is after end of day" usually means that
   the sec argument is greater than 60.0.  However, in a day ending
   in a leap second the limit changes to 61.0 (or 59.0 in the case
   of a negative leap second).

6. The warning status "dubious year" flags UTCs that predate the
   introduction of the time scale or that are too far in the future
   to be trusted.  See iauDat for further details.

7. Only in the case of continuous and regular time scales (TAI, TT,
   TCG, TCB and TDB) is the result d1+d2 a Julian Date, strictly
   speaking.  In the other cases (UT1 and UTC) the result must be
   used with circumspection;  in particular the difference between
   two such results cannot be interpreted as a precise time
   interval.

Called:
   iauCal2jd    Gregorian calendar to JD
   iauDat       delta(AT) = TAI-UTC
   iauJd2cal    JD to Gregorian calendar

This revision:  2013 July 26

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
# int iauDtf2d(const char *scale, int iy, int im, int id,
#              int ihr, int imn, double sec, double *d1, double *d2)
function iauDtf2d(scale::String, iy::Real, im::Real, id::Real, ihr::Real, imn::Real, sec::Real)
   ref_d1 = Ref{Float64}(0.0)
   ref_d2 = Ref{Float64}(0.0)

   status = ccall((:iauDtf2d, libsofa_c), Cint,
                  (Cstring, Cint, Cint, Cint, Cint, Cint, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
                  scale, convert(Int32, iy), convert(Int32, im), convert(Int32, id),
                  convert(Int32, ihr), convert(Int32, imn), convert(Float64, sec), ref_d1, ref_d2)

   if status != 0
      @warn "Non-zero return code form iauDtf2d"
   end

   return status, ref_d1[], ref_d2[]
end