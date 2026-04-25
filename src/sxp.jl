export iauSxp
"""
Multiply a p-vector by a scalar.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   s      double        scalar
   p      double[3]     p-vector

Returned:
   sp     double[3]     s * p

Note:
   It is permissible for p and sp to be the same array.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauSxp(double s, double p[3], double sp[3])

function iauSxp(s::Real, p::AbstractVector{<:Real})
   sp = zeros(Float64, 3)

   ccall((:iauSxp, libsofa_c), Cvoid,
       (Cdouble, Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Float64, s),
       convert(Array{Float64, 1}, p),
       sp)

   return SVector{3}(sp)
end