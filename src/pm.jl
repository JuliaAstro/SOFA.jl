export iauPm
"""
Modulus of p-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   p      double[3]     p-vector

Returned (function value):
         double        modulus

This revision:  2013 August 7

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauPm(double p[3])
function iauPm(p::AbstractVector{<:Real})

   return ccall((:iauPm, libsofa_c), Cdouble,
       (Ptr{Cdouble},), p)
end