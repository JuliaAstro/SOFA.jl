export iauTf2a
"""
Convert hours, minutes, seconds to radians.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
    s         char    sign:  '-' = negative, otherwise positive
    ihour     int     hours
    imin      int     minutes
    sec       double  seconds

Returned:
    rad       double  angle in radians

Returned (function value):
            int     status:  0 = OK
                            1 = ihour outside range 0-23
                            2 = imin outside range 0-59
                            3 = sec outside range 0-59.999...

Notes:

1.  The result is computed even if any of the range checks fail.

2.  Negative ihour, imin and/or sec produce a warning status, but
    the absolute value is used in the conversion.

3.  If there are multiple errors, the status value reflects only the
    first, the smallest taking precedence.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauTf2a(char s, int ihour, int imin, double sec, double *rad)
function iauTf2a(s::Char, ihour::Int, imin::Int, sec::Real)
    ref_rad  = Ref{Float64}(0.0)

    status = ccall((:iauTf2a, libsofa_c), Cint, 
        (Cchar, Cint, Cint, Cdouble, Ref{Cdouble}), 
        convert(UInt8, s),
        convert(Int32, ihour),
        convert(Int32, imin),
        convert(Float64, sec),
        ref_rad)

    return status, ref_rad[]
end