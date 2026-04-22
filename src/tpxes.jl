export iauTpxes
"""
In the tangent plane projection, given celestial spherical
coordinates for a star and the tangent point, solve for the star's
rectangular coordinates in the tangent plane.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   a,b       double  star's spherical coordinates
   a0,b0     double  tangent point's spherical coordinates

Returned:
   *xi,*eta  double  rectangular coordinates of star image (Note 2)

Returned (function value):
            int     status:  0 = OK
                              1 = star too far from axis
                              2 = antistar on tangent plane
                              3 = antistar too far from axis

Notes:

1. The tangent plane projection is also called the "gnomonic
   projection" and the "central projection".

2. The eta axis points due north in the adopted coordinate system.
   If the spherical coordinates are observed (RA,Dec), the tangent
   plane coordinates (xi,eta) are conventionally called the
   "standard coordinates".  For right-handed spherical coordinates,
   (xi,eta) are also right-handed.  The units of (xi,eta) are,
   effectively, radians at the tangent point.

3. All angular arguments are in radians.

4. This function is a member of the following set:

      spherical      vector         solve for

      > iauTpxes <    iauTpxev         xi,eta
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

# int iauTpxes(double a, double b, double a0, double b0,
#              double *xi, double *eta)

function iauTpxes(a::Real, b::Real,
                  a0::Real, b0::Real)
   ref_xi = Ref{Float64}(0.0)
   ref_eta = Ref{Float64}(0.0)

   status = ccall((:iauTpxes, libsofa_c), Cint, 
       (Cdouble, Cdouble, Cdouble, Cdouble,
       Ref{Cdouble}, Ref{Cdouble}), 
       convert(Float64, a),
       convert(Float64, b),
       convert(Float64, a0),
       convert(Float64, b0),
       ref_xi, ref_eta)

   return status, ref_xi[], ref_eta[]
end