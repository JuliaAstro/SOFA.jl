export iauCal2jd
"""
Gregorian Calendar to Julian Date.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   iy,im,id  int     year, month, day in Gregorian calendar (Note 1)

Returned:
   djm0      double  MJD zero-point: always 2400000.5
   djm       double  Modified Julian Date for 0 hrs

Returned (function value):
            int     status:
                        0 = OK
                        -1 = bad year   (Note 3: JD not computed)
                        -2 = bad month  (JD not computed)
                        -3 = bad day    (JD computed)

Notes:

1. The algorithm used is valid from -4800 March 1, but this
   implementation rejects dates before -4799 January 1.

2. The Julian Date is returned in two pieces, in the usual SOFA
   manner, which is designed to preserve time resolution.  The
   Julian Date is available as a single number by adding djm0 and
   djm.

3. In early eras the conversion is from the "Proleptic Gregorian
   Calendar";  no account is taken of the date(s) of adoption of
   the Gregorian Calendar, nor is the AD/BC numbering convention
   observed.

Reference:

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992),
   Section 12.92 (p604).

This revision:  2013 August 7

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauCal2jd(int iy, int im, int id, double *djm0, double *djm)

function iauCal2jd(iy::Real, im::Real, id::Real)

   # Allocate return value
   ref_djm0 = Ref{Float64}(0.0)
   ref_djm  = Ref{Float64}(0.0)

   status = ccall((:iauCal2jd, libsofa_c), Cint, 
         (Cint, Cint, Cint, 
         Ref{Cdouble}, Ref{Cdouble}), 
         convert(Int32, iy), convert(Int32, im), convert(Int32, id),
         ref_djm0, ref_djm)

   # Warn on non-zero status code
   if status == -1
      @warn "bad year (Note 3: JD not computed"
   elseif status == -2
      @warn "bad month"
   elseif status == -3
      @warn "bad day"
   end

   return status, ref_djm0[], ref_djm[]
end
