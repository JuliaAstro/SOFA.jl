export iauPn
"""
Convert a p-vector into modulus and unit vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   p        double[3]      p-vector

Returned:
   r        double         modulus
   u        double[3]      unit vector

Notes:

1. If p is null, the result is null.  Otherwise the result is a unit
   vector.

2. It is permissible to re-use the same array for any of the
   arguments.

Called:
   iauPm        modulus of p-vector
   iauZp        zero p-vector
   iauSxp       multiply p-vector by scalar

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPn(double p[3], double *r, double u[3])

function iauPn(p::AbstractVector{<:Real})
   # Allocate return values
   ref_r = Ref{Float64}(0.0)
   u = zeros(Float64, 3)

   ccall((:iauPn, libsofa_c), Cvoid, 
        (Ptr{Cdouble}, Ref{Cdouble}, Ptr{Cdouble}),
         convert(Array{Float64, 1}, p), ref_r, u)

   return ref_r[], SVector{3}(u)
end