export iauP2s
"""
P-vector to spherical polar coordinates.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   p        double[3]    p-vector

Returned:
   theta    double       longitude angle (radians)
   phi      double       latitude angle (radians)
   r        double       radial distance

Notes:

1) If P is null, zero theta, phi and r are returned.

2) At either pole, zero theta is returned.

Called:
   iauC2s       p-vector to spherical
   iauPm        modulus of p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauP2s(double p[3], double *theta, double *phi, double *r)
function iauP2s(p::AbstractVector{<:Real})
   ref_theta = Ref{Float64}(0.0)
   ref_phi   = Ref{Float64}(0.0)
   ref_r     = Ref{Float64}(0.0)

   ccall((:iauP2s, libsofa_c), Cvoid,
       (Ptr{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}),
       convert(Array{Float64, 1}, p),
       ref_theta, ref_phi, ref_r)

   return ref_theta[], ref_phi[], ref_r[]
end