export iauA2tf
"""
Decompose radians into hours, minutes, seconds, fraction.

 This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

 Status:  vector/matrix support function.

 Given:
   ndp     int     resolution (Note 1)
   angle   double  angle in radians

 Returned:
   sign    char    '+' or '-'
   ihmsf   int[4]  hours, minutes, seconds, fraction

 Called:
   iauD2tf      decompose days to hms

 Notes:

1. The argument ndp is interpreted as follows:

   | ndp | resolution   |
   | :-: | :----------: |
   | :   | ...00,000,000 |
   | -7  | 10,000,000   |
   | -6  | 1,000,000    |
   | -5  | 100,000      |
   | -4  | 10,000       |
   | -3  | 1,000        |
   | -2  | 100          |
   | -1  | 10           |
   |  0  | 1            |
   |  1  | 0.1          |
   |  2  | 0.01         |
   |  3  | 0.001        |
   |  :  | 0.000...     |

2. The largest positive useful value for ndp is determined by the
    size of angle, the format of doubles on the target platform, and
    the risk of overflowing ihmsf[4].  On a typical platform, for
    angle up to 2pi, the available floating-point precision might
    correspond to ndp=12.  However, the practical limit is typically
    ndp=9, set by the capacity of a 32-bit int, or ndp=4 if int is
    only 16 bits.

3. The absolute value of angle may exceed 2pi.  In cases where it
    does not, it is up to the caller to test for and handle the
    case where angle is very nearly 2pi and rounds up to 24 hours,
    by testing for ihmsf[1]=24 and setting ihmsf[1:4] to zero.

This revision:  2013 July 31

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauA2tf(ndp::Int, angle::Real)
    sign  = Array{UInt8}(undef, 1)
    ihmsf = Array{Int32}(undef, 4)

    ccall((:iauA2tf, libsofa_c), Cvoid, 
        (Cint, Cdouble, Ptr{UInt8}, Ptr{Cint}), 
        convert(Int32, ndp), convert(Float64, angle), sign, ihmsf)


    return Char(sign[1]), ihmsf
end
