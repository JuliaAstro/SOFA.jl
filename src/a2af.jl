export iauA2af
"""
Decompose radians into degrees, arcminutes, arcseconds, fraction.
This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
- `ndp::Integer` resolution (Note 1)
- `angle::Real`  angle in radians

Returned:
- `sign::Char`    `'+'` or `'-'`
- `idmsf::Vector{Int32}`  degrees, arcminutes, arcseconds, fraction

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

2. The largest positive useful value for ndp is determined by the size of angle,
   the format of doubles on the target platform, and the risk of overflowing
   idmsf[3].  On a typical platform, for angle up to 2pi, the available
   floating-point precision might correspond to ndp=12.  However, the practical
   limit is typically ndp=9, set by the capacity of a 32-bit int, or ndp=4 if int
   is only 16 bits.

3. The absolute value of angle may exceed 2pi.  In cases where it does not, it
   is up to the caller to test for and handle the case where angle is very nearly
   2pi and rounds up to 360 degrees, by testing for idmsf[0]=360 and setting
   idmsf[0-3] to zero.

This revision:  2013 June 18

SOFA release 2018-01-30
"""
function iauA2af(ndp::Int, angle::Real)
    sign  = Array{UInt8}(undef, 1)
    idmsf = Array{Int32}(undef, 4)

    ccall((:iauA2af, libsofa_c), Cvoid,
        (Cint, Cdouble, Ptr{UInt8}, Ptr{Cint}),
        convert(Int32, ndp), convert(Float64, angle), sign, idmsf)


    return Char(sign[1]), idmsf
end
