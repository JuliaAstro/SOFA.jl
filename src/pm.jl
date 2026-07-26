export iauPm
"""
Modulus of p-vector.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   p      double[3]     p-vector

Returned (function value):
         double        modulus

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauPm(p::AbstractVector{<:Real})
    return ccall((:iauPm, libsofa_c), Cdouble, (Ptr{Cdouble},), p)
end
