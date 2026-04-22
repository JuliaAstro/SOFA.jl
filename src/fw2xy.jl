export iauFw2xy
"""
CIP X,Y given Fukushima-Williams bias-precession-nutation angles.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   gamb     double    F-W angle gamma_bar (radians)
   phib     double    F-W angle phi_bar (radians)
   psi      double    F-W angle psi (radians)
   eps      double    F-W angle epsilon (radians)

Returned:
   x,y      double    CIP unit vector X,Y

Notes:

1. Naming the following points:

         e = J2000.0 ecliptic pole,
         p = GCRS pole
         E = ecliptic pole of date,
   and   P = CIP,

   the four Fukushima-Williams angles are as follows:

      gamb = gamma = epE
      phib = phi = pE
      psi = psi = pEP
      eps = epsilon = EP

2. The matrix representing the combined effects of frame bias,
   precession and nutation is:

      NxPxB = R_1(-epsA).R_3(-psi).R_1(phib).R_3(gamb)

   The returned values x,y are elements [2][0] and [2][1] of the
   matrix.  Near J2000.0, they are essentially angles in radians.

Called:
   iauFw2m      F-W angles to r-matrix
   iauBpn2xy    extract CIP X,Y coordinates from NPB matrix

Reference:

   Hilton, J. et al., 2006, Celest.Mech.Dyn.Astron. 94, 351

This revision:  2013 September 2

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""


# void iauFw2xy(double gamb, double phib, double psi, double eps,
#               double *x, double *y)

function iauFw2xy(gamb::Real, phib::Real, psi::Real, eps::Real)
   ref_x = Ref{Float64}(0.0)
   ref_y = Ref{Float64}(0.0)

   ccall((:iauFw2xy, libsofa_c), Cvoid, 
         (Cdouble, Cdouble, Cdouble, Cdouble,
         Ref{Cdouble}, Ref{Cdouble}), 
          convert(Float64, gamb), convert(Float64, phib),
          convert(Float64, psi), convert(Float64, eps),
          ref_x, ref_y)

   return ref_x[], ref_y[]
end