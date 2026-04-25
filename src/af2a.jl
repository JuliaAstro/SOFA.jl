export iauAf2a
"""
Convert degrees, arcminutes, arcseconds to radians.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
|   s      |  char   | sign:  '-' = negative, otherwise positive
|   ideg   |  int    | degrees
|   iamin  |  int    | arcminutes
|   asec   |  double | arcseconds

Returned:
    rad       double  angle in radians

Returned (function value):
    int status:
               - 0 = OK
               - 1 = ideg outside range 0-359
               - 2 = iamin outside range 0-59
               - 3 = asec outside range 0-59.999...
Notes:
1. The result is computed even if any of the range checks fail.

2. Negative ideg, iamin and/or asec produce a warning status, but
    the absolute value is used in the conversion.

3. If there are multiple errors, the status value reflects only the
    first, the smallest taking precedence.

    This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauAf2a(sign::Char, ideg::Int, iamin::Int, asec::Real)
    rad  = zeros(Float64, 1)

    status = ccall((:iauAf2a, libsofa_c), Cint,
        (Cchar, Cint, Cint, Cdouble, Ptr{Cdouble}),
        convert(UInt8, sign),
        convert(Int32, ideg),
        convert(Int32, iamin),
        convert(Float64, asec),
        rad)

    return status, rad[1]
end
