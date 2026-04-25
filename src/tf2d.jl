export iauTf2d
"""
**  Convert hours, minutes, seconds to days.
**
**  This function is part of the International Astronomical Union's
**  SOFA (Standards of Fundamental Astronomy) software collection.
**
**  Status:  support function.
**
**  Given:
**     s         char    sign:  '-' = negative, otherwise positive
**     ihour     int     hours
**     imin      int     minutes
**     sec       double  seconds
**
**  Returned:
**     days      double  interval in days
**
**  Returned (function value):
**               int     status:  0 = OK
**                                1 = ihour outside range 0-23
**                                2 = imin outside range 0-59
**                                3 = sec outside range 0-59.999...
**
**  Notes:
**
**  1)  The result is computed even if any of the range checks fail.
**
**  2)  Negative ihour, imin and/or sec produce a warning status, but
**      the absolute value is used in the conversion.
**
**  3)  If there are multiple errors, the status value reflects only the
**      first, the smallest taking precedence.
**
**  This revision:  2013 June 18
**
**  SOFA release 2018-01-30
**
**  Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauTf2d(char s, int ihour, int imin, double sec, double *days)
function iauTf2d(s::Char, ihour::Int, imin::Int, sec::Real)
    ref_days  = Ref{Float64}(0.0)

    status = ccall((:iauTf2d, libsofa_c), Cint,
        (Cchar, Cint, Cint, Cdouble, Ref{Cdouble}),
        convert(UInt8, s),
        convert(Int32, ihour),
        convert(Int32, imin),
        convert(Float64, sec),
        ref_days)

    return status, ref_days[]
end