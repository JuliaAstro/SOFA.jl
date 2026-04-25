export iauPpsp
"""
P-vector plus scaled p-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   a      double[3]     first p-vector
   s      double        scalar (multiplier for b)
   b      double[3]     second p-vector

Returned:
   apsb   double[3]     a + s*b

Note:
   It is permissible for any of a, b and apsb to be the same array.

Called:
   iauSxp       multiply p-vector by scalar
   iauPpp       p-vector plus p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPpsp(double a[3], double s, double b[3], double apsb[3])
function iauPpsp(a::AbstractVector{<:Real}, s::Real, b::AbstractVector{<:Real})
   apsb = zeros(Float64, 3)
   ccall((:iauPpsp, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Cdouble, Ptr{Cdouble}, Ptr{Cdouble}),
         convert(Array{Float64, 1}, a),
         convert(Float64, s),
         convert(Array{Float64, 1}, b),
         apsb)

   return SVector{3}(apsb)
end