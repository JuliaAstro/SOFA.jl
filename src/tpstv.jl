export iauTpstv
"""
In the tangent plane projection, given the star's rectangular
coordinates and the direction cosines of the tangent point, solve
for the direction cosines of the star.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   xi,eta  double     rectangular coordinates of star image (Note 2)
   v0      double[3]  tangent point's direction cosines

Returned:
   v       double[3]  star's direction cosines

1. The tangent plane projection is also called the "gnomonic
   projection" and the "central projection".

2. The eta axis points due north in the adopted coordinate system.
   If the direction cosines represent observed (RA,Dec), the tangent
   plane coordinates (xi,eta) are conventionally called the
   "standard coordinates".  If the direction cosines are with
   respect to a right-handed triad, (xi,eta) are also right-handed.
   The units of (xi,eta) are, effectively, radians at the tangent
   point.

3. The method used is to complete the star vector in the (xi,eta)
   based triad and normalize it, then rotate the triad to put the
   tangent point at the pole with the x-axis aligned to zero
   longitude.  Writing (a0,b0) for the celestial spherical
   coordinates of the tangent point, the sequence of rotations is
   (b-pi/2) around the x-axis followed by (-a-pi/2) around the
   z-axis.

4. If vector v0 is not of unit length, the returned vector v will
   be wrong.

5. If vector v0 points at a pole, the returned vector v will be
   based on the arbitrary assumption that the longitude coordinate
   of the tangent point is zero.

6. This function is a member of the following set:

      spherical      vector         solve for

      iauTpxes      iauTpxev         xi,eta
      iauTpsts    > iauTpstv <        star
      iauTpors      iauTporv         origin

References:

   Calabretta M.R. & Greisen, E.W., 2002, "Representations of
   celestial coordinates in FITS", Astron.Astrophys. 395, 1077

   Green, R.M., "Spherical Astronomy", Cambridge University Press,
   1987, Chapter 13.

This revision:   2018 January 2

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauTpstv(double xi, double eta, double v0[3], double v[3])

function iauTpstv(xi::Real, eta::Real, v0::AbstractVector{<:Real})
   v = zeros(Float64, 3)

   ccall((:iauTpstv, libsofa_c), Cvoid, 
       (Cdouble, Cdouble,
       Ptr{Cdouble}, Ptr{Cdouble}), 
       convert(Float64, xi),
       convert(Float64, eta),
       convert(Array{Float64, 1}, v0),
       v)

   return SVector{3}(v)
end