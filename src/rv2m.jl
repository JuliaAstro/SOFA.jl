export iauRv2m
"""
Form the r-matrix corresponding to a given r-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   w        double[3]      rotation vector (Note 1)

Returned:
   r        double[3][3]    rotation matrix

Notes:

1. A rotation matrix describes a rotation through some angle about
   some arbitrary axis called the Euler axis.  The "rotation vector"
   supplied to This function has the same direction as the Euler
   axis, and its magnitude is the angle in radians.

2. If w is null, the unit matrix is returned.

3. The reference frame rotates clockwise as seen looking along the
   rotation vector from the origin.

This revision:  2015 January 30

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauRv2m(double w[3], double r[3][3])
function iauRv2m(w::AbstractVector{<:Real})
   r = zeros(Float64, 3, 3)

   ccall((:iauRv2m, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}),
          w, r)

   return SMatrix{3,3}(r')
end