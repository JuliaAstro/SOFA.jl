export iauTpxev
"""
In the tangent plane projection, given celestial direction cosines
for a star and the tangent point, solve for the star's rectangular
coordinates in the tangent plane.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   v         double[3]  direction cosines of star (Note 4)
   v0        double[3]  direction cosines of tangent point (Note 4)

Returned:
   *xi,*eta  double     tangent plane coordinates of star

Returned (function value):
            int        status: 0 = OK
                                 1 = star too far from axis
                                 2 = antistar on tangent plane
                                 3 = antistar too far from axis

Notes:

1. The tangent plane projection is also called the "gnomonic
   projection" and the "central projection".

2. The eta axis points due north in the adopted coordinate system.
   If the direction cosines represent observed (RA,Dec), the tangent
   plane coordinates (xi,eta) are conventionally called the
   "standard coordinates".  If the direction cosines are with
   respect to a right-handed triad, (xi,eta) are also right-handed.
   The units of (xi,eta) are, effectively, radians at the tangent
   point.

3. The method used is to extend the star vector to the tangent
   plane and then rotate the triad so that (x,y) becomes (xi,eta).
   Writing (a,b) for the celestial spherical coordinates of the
   star, the sequence of rotations is (a+pi/2) around the z-axis
   followed by (pi/2-b) around the x-axis.

4. If vector v0 is not of unit length, or if vector v is of zero
   length, the results will be wrong.

5. If v0 points at a pole, the returned (xi,eta) will be based on
   the arbitrary assumption that the longitude coordinate of the
   tangent point is zero.

6. This function is a member of the following set:

      spherical      vector         solve for

      iauTpxes    > iauTpxev <       xi,eta
      iauTpsts      iauTpstv          star
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

# int iauTpxev(double v[3], double v0[3], double *xi, double *eta)

function iauTpxev(v::AbstractVector{<:Real}, v0::AbstractVector{<:Real})
   ref_xi = Ref{Float64}(0.0)
   ref_eta = Ref{Float64}(0.0)

   status = ccall((:iauTpxev, libsofa_c), Cint,
       (Ptr{Cdouble}, Ptr{Cdouble},
       Ref{Cdouble}, Ref{Cdouble}),
       convert(Array{Float64, 1}, v),
       convert(Array{Float64, 1}, v0),
       ref_xi, ref_eta)

   return status, ref_xi[], ref_eta[]
end