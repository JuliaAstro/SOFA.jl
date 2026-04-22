export iauRm2v
"""
Express an r-matrix as an r-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   r        double[3][3]    rotation matrix

Returned:
   w        double[3]       rotation vector (Note 1)

Notes:

1. A rotation matrix describes a rotation through some angle about
   some arbitrary axis called the Euler axis.  The "rotation vector"
   returned by this function has the same direction as the Euler axis,
   and its magnitude is the angle in radians.  (The magnitude and
   direction can be separated by means of the function iauPn.)

2. If r is null, so is the result.  If r is not a rotation matrix
   the result is undefined;  r must be proper (i.e. have a positive
   determinant) and real orthogonal (inverse = transpose).

3. The reference frame rotates clockwise as seen looking along
   the rotation vector from the origin.

This revision:  2015 January 30

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauRm2v(double r[3][3], double w[3])

function iauRm2v(r::AbstractMatrix{<:Real})
   w = zeros(Float64, 3)

   ccall((:iauRm2v, libsofa_c), Cvoid, 
         (Ptr{Cdouble}, Ptr{Cdouble}),
          convert(Array{Float64, 2}, r'),
          w)

   return SVector{3}(w)
end