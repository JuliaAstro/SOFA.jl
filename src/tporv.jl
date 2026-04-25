export iauTporv
"""
In the tangent plane projection, given the rectangular coordinates
of a star and its direction cosines, determine the direction
cosines of the tangent point.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   xi,eta   double    rectangular coordinates of star image (Note 2)
   v        double[3] star's direction cosines (Note 3)

Returned:
   v01      double[3] tangent point's direction cosines, Solution 1
   v02      double[3] tangent point's direction cosines, Solution 2

Returned (function value):
               int     number of solutions:
                     0 = no solutions returned (Note 4)
                     1 = only the first solution is useful (Note 5)
                     2 = both solutions are useful (Note 5)

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

3. The vector v must be of unit length or the result will be wrong.

4. Cases where there is no solution can arise only near the poles.
   For example, it is clearly impossible for a star at the pole
   itself to have a non-zero xi value, and hence it is meaningless
   to ask where the tangent point would have to be.

5. Also near the poles, cases can arise where there are two useful
   solutions.  The return value indicates whether the second of the
   two solutions returned is useful;  1 indicates only one useful
   solution, the usual case.

6. The basis of the algorithm is to solve the spherical triangle
   PSC, where P is the north celestial pole, S is the star and C is
   the tangent point.  Calling the celestial spherical coordinates
   of the star and tangent point (a,b) and (a0,b0) respectively, and
   writing rho^2 = (xi^2+eta^2) and r^2 = (1+rho^2), and
   transforming the vector v into (a,b) in the normal way, side c is
   then (pi/2-b), side p is sqrt(xi^2+eta^2) and side s (to be
   found) is (pi/2-b0), while angle C is given by sin(C) = xi/rho
   and cos(C) = eta/rho;  angle P (to be found) is (a-a0).  After
   solving the spherical triangle, the result (a0,b0) can be
   expressed in vector form as v0.

7. This function is a member of the following set:

      spherical      vector         solve for

      iauTpxes      iauTpxev         xi,eta
      iauTpsts      iauTpstv          star
      iauTpors    > iauTporv <       origin

References:

   Calabretta M.R. & Greisen, E.W., 2002, "Representations of
   celestial coordinates in FITS", Astron.Astrophys. 395, 1077

   Green, R.M., "Spherical Astronomy", Cambridge University Press,
   1987, Chapter 13.

This revision:   2018 January 2

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauTporv(double xi, double eta, double v[3],
#              double v01[3], double v02[3])

function iauTporv(xi::Real, eta::Real, v::AbstractVector{<:Real})
   v01 = zeros(Float64, 3)
   v02 = zeros(Float64, 3)

   status = ccall((:iauTporv, libsofa_c), Cint,
       (Cdouble, Cdouble, Ref{Cdouble},
       Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Float64, xi),
       convert(Float64, eta),
       convert(Array{Float64, 1}, v),
       v01, v02)

   return status, SVector{3}(v01), SVector{3}(v02)
end