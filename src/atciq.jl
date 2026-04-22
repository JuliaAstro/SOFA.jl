export iauAtciq
"""
Quick ICRS, epoch J2000.0, to CIRS transformation, given precomputed
star-independent astrometry parameters.

Use of this function is appropriate when efficiency is important and
where many star positions are to be transformed for one date.  The
star-independent parameters can be obtained by calling one of the
functions iauApci[13], iauApcg[13], iauApco[13] or iauApcs[13].

If the parallax and proper motions are zero the iauAtciqz function
can be used instead.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   rc,dc  double     ICRS RA,Dec at J2000.0 (radians)
   pr     double     RA proper motion (radians/year; Note 3)
   pd     double     Dec proper motion (radians/year)
   px     double     parallax (arcsec)
   rv     double     radial velocity (km/s, +ve if receding)
   astrom iauASTROM* star-independent astrometry parameters:
      pmt    double       PM time interval (SSB, Julian years)
      eb     double[3]    SSB to observer (vector, au)
      eh     double[3]    Sun to observer (unit vector)
      em     double       distance from Sun to observer (au)
      v      double[3]    barycentric observer velocity (vector, c)
      bm1    double       sqrt(1-|v|^2): reciprocal of Lorenz factor
      bpn    double[3][3] bias-precession-nutation matrix
      along  double       longitude + s' (radians)
      xpl    double       polar motion xp wrt local meridian (radians)
      ypl    double       polar motion yp wrt local meridian (radians)
      sphi   double       sine of geodetic latitude
      cphi   double       cosine of geodetic latitude
      diurab double       magnitude of diurnal aberration vector
      eral   double       "local" Earth rotation angle (radians)
      refa   double       refraction constant A (radians)
      refb   double       refraction constant B (radians)

Returned:
   ri,di   double    CIRS RA,Dec (radians)

Notes:

1. All the vectors are with respect to BCRS axes.

2. Star data for an epoch other than J2000.0 (for example from the
   Hipparcos catalog, which has an epoch of J1991.25) will require a
   preliminary call to iauPmsafe before use.

3. The proper motion in RA is dRA/dt rather than cos(Dec)*dRA/dt.

Called:
   iauPmpx      proper motion and parallax
   iauLdsun     light deflection by the Sun
   iauAb        stellar aberration
   iauRxp       product of r-matrix and pv-vector
   iauC2s       p-vector to spherical
   iauAnp       normalize angle into range 0 to 2pi

This revision:   2013 October 9

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

function iauAtciq(rc::Real, dc::Real,
                   pr::Real, pd::Real,
                   px::Real, rv::Real,
                   astrom::iauASTROM)

   # Allocate return value
   ref_astrom = Ref{iauASTROM}(astrom)
   ref_ri     = Ref{Float64}(0.0)
   ref_di     = Ref{Float64}(0.0)

   ccall((:iauAtciq, libsofa_c), Cvoid,
            (Cdouble, Cdouble,
            Cdouble, Cdouble,
            Cdouble, Cdouble, Ref{iauASTROM},
            Ref{Cdouble}, Ref{Cdouble}),
            convert(Float64, rc),
            convert(Float64, dc),
            convert(Float64, pr),
            convert(Float64, pd),
            convert(Float64, px),
            convert(Float64, rv),
            ref_astrom, ref_ri, ref_di)


   return ref_ri[], ref_di[]
end
