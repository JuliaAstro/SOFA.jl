export iauAnp
"""
Normalize angle into the range 0 <= a < 2pi.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   a        double     angle (radians)

Returned (function value):
   double     angle in range 0-2pi

This revision:  2021 May 11

SOFA release 2021-05-12

Copyright (C) 2021 IAU SOFA Board.  See notes at end.
"""
function iauAnp(a::Real)
    return ccall((:iauAnp, libsofa_c), Cdouble, (Cdouble,), convert(Float64, a))
end
