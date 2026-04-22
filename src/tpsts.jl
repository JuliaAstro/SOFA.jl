export iauTpsts
"""
In the tangent plane projection, given the star's rectangular
coordinates and the spherical coordinates of the tangent point,
solve for the spherical coordinates of the star.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   xi,eta    double  rectangular coordinates of star image (Note 2)
   a0,b0     double  tangent point's spherical coordinates

Returned:
   *a,*b     double  star's spherical coordinates

1. The tangent plane projection is also called the "gnomonic
   projection" and the "central projection".

2. The eta axis points due north in the adopted coordinate system.
   If the spherical coordinates are observed (RA,Dec), the tangent
   plane coordinates (xi,eta) are conventionally called the
   "standard coordinates".  If the spherical coordinates are with
   respect to a right-handed triad, (xi,eta) are also right-handed.
   The units of (xi,eta) are, effectively, radians at the tangent
   point.

3. All angular arguments are in radians.

4. This function is a member of the following set:

      spherical      vector         solve for

      iauTpxes      iauTpxev         xi,eta
      > iauTpsts <    iauTpstv          star
      iauTpors      iauTporv         origin

Called:
   iauAnp       normalize angle into range 0 to 2pi

References:

   Calabretta M.R. & Greisen, E.W., 2002, "Representations of
   celestial coordinates in FITS", Astron.Astrophys. 395, 1077

   Green, R.M., "Spherical Astronomy", Cambridge University Press,
   1987, Chapter 13.

This revision:   2018 January 2

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauTpsts(double xi, double eta, double a0, double b0,
#               double *a, double *b)

function iauTpsts(xi::Real, eta::Real,
                  a0::Real, b0::Real)
   ref_a = Ref{Float64}(0.0)
   ref_b = Ref{Float64}(0.0)

   ccall((:iauTpsts, libsofa_c), Cvoid, 
       (Cdouble, Cdouble, Cdouble, Cdouble,
       Ref{Cdouble}, Ref{Cdouble}), 
       convert(Float64, xi),
       convert(Float64, eta),
       convert(Float64, a0),
       convert(Float64, b0),
       ref_a, ref_b)

   return ref_a[], ref_b[]
end