export iauPm
"""
Modulus of p-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   p      double[3]     p-vector

Returned (function value):
         double        modulus

This revision:  2013 August 7

SOFA release 2021-01-25

Copyright (C) 2021 IAU SOFA Board.  See notes at end.
"""
function iauPm(p::AbstractVector{<:Real})
    return ccall((:iauPm, libsofa_c), Cdouble, (Ptr{Cdouble},), p)
end
