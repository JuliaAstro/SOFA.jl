export iauC2s
"""
P-vector to spherical coordinates.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   p      double[3]    p-vector

Returned:
   theta  double       longitude angle (radians)
   phi    double       latitude angle (radians)

Notes:

1. The vector p can have any magnitude; only its direction is used.

2. If p is null, zero theta and phi are returned.

3. At either pole, zero theta is returned.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauC2s(double p[3], double *theta, double *phi)

function iauC2s(p::AbstractVector{<:Real})

   # Allocate return value
   ref_theta = Ref{Float64}(0.0)
   ref_phi   = Ref{Float64}(0.0)

   ccall((:iauC2s, libsofa_c), Cvoid,
         (Ptr{Cdouble},
         Ref{Cdouble}, Ref{Cdouble}),
         convert(Array{Float64, 1}, p),
         ref_theta, ref_phi)

   return ref_theta[], ref_phi[]
end