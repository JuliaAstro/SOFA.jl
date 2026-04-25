export iauSepp
"""
Angular separation between two p-vectors.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   a      double[3]    first p-vector (not necessarily unit length)
   b      double[3]    second p-vector (not necessarily unit length)

Returned (function value):
         double       angular separation (radians, always positive)

Notes:

1. If either vector is null, a zero result is returned.

2. The angular separation is most simply formulated in terms of
   scalar product.  However, this gives poor accuracy for angles
   near zero and pi.  The present algorithm uses both cross product
   and dot product, to deliver full accuracy whatever the size of
   the angle.

Called:
   iauPxp       vector product of two p-vectors
   iauPm        modulus of p-vector
   iauPdp       scalar product of two p-vectors

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauSepp(double a[3], double b[3])

function iauSepp(a::AbstractVector{<:Real}, b::AbstractVector{<:Real})
   return ccall((:iauSepp, libsofa_c), Cdouble,
       (Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Array{Float64, 1}, a),
       convert(Array{Float64, 1}, b))
end