export iauAnp
"""
Normalize angle into the range 0 <= a < 2pi.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   a        double     angle (radians)

Returned (function value):
   double     angle in range 0-2pi

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauAnp(a::Real)
    return ccall((:iauAnp, libsofa_c), Cdouble, (Cdouble,), convert(Float64, a))
end
