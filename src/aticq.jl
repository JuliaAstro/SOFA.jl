export iauAticq
"""
Quick CIRS RA,Dec to ICRS astrometric place, given the star-
independent astrometry parameters.

Use of this function is appropriate when efficiency is important and
where many star positions are all to be transformed for one date.
The star-independent astrometry parameters can be obtained by
calling one of the functions iauApci[13], iauApcg[13], iauApco[13]
or iauApcs[13].

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   ri,di  double     CIRS RA,Dec (radians)
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
   rc,dc  double     ICRS astrometric RA,Dec (radians)

Notes:

1. Only the Sun is taken into account in the light deflection correction.

2. Iterative techniques are used for the aberration and light
   deflection corrections so that the functions iauAtic13 (or
   iauAticq) and iauAtci13 (or iauAtciq) are accurate inverses;
   even at the edge of the Sun's disk the discrepancy is only about
   1 nanoarcsecond.

Called:
   iauS2c       spherical coordinates to unit vector
   iauTrxp      product of transpose of r-matrix and p-vector
   iauZp        zero p-vector
   iauAb        stellar aberration
   iauLdsun     light deflection by the Sun
   iauC2s       p-vector to spherical
   iauAnp       normalize angle into range +/- pi

This revision:   2013 October 9

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
# void iauAticq(double ri, double di, iauASTROM *astrom,
#               double *rc, double *dc)

function iauAticq(ri::Real, di::Real, astrom::iauASTROM)
   # Allocate return values
   ref_astrom = Ref{iauASTROM}(astrom)
   ref_rc     = Ref{Float64}(0.0)
   ref_dc     = Ref{Float64}(0.0)

   status = ccall((:iauAticq, libsofa_c), Cint, 
            (Cdouble, Cdouble, Ref{iauASTROM}, 
            Ref{Cdouble}, Ref{Cdouble}), 
            convert(Float64, ri), convert(Float64, di), 
            ref_astrom, ref_rc, ref_dc)

    return ref_rc[], ref_dc[]
end
