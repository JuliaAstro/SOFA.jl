export iauAnpm
"""
Normalize angle into the range -pi <= a < +pi.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   a        double     angle (radians)

Returned (function value):
   double     angle in range +/-pi

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauAnpm(a::Real)
    return ccall((:iauAnpm, libsofa_c), Cdouble, (Cdouble,), convert(Float64, a))
end
