export iauPap
"""
Position-angle from two p-vectors.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   a      double[3]  direction of reference point
   b      double[3]  direction of point whose PA is required

Returned (function value):
         double     position angle of b with respect to a (radians)

Notes:

1. The result is the position angle, in radians, of direction b with
   respect to direction a.  It is in the range -pi to +pi.  The
   sense is such that if b is a small distance "north" of a the
   position angle is approximately zero, and if b is a small
   distance "east" of a the position angle is approximately +pi/2.

2. The vectors a and b need not be of unit length.

3. Zero is returned if the two directions are the same or if either
   vector is null.

4. If vector a is at a pole, the result is ill-defined.

Called:
   iauPn        decompose p-vector into modulus and direction
   iauPm        modulus of p-vector
   iauPxp       vector product of two p-vectors
   iauPmp       p-vector minus p-vector
   iauPdp       scalar product of two p-vectors

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauPap(double a[3], double b[3])
function iauPap(a::AbstractVector{<:Real}, b::AbstractVector{<:Real})
   return ccall((:iauPap, libsofa_c), Cdouble,
       (Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Array{Float64, 1}, a),
       convert(Array{Float64, 1}, b))
end