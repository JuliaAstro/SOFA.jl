export iauH2fk5
"""
Transform Hipparcos star data into the FK5 (J2000.0) system.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given (all Hipparcos, epoch J2000.0):
   rh      double    RA (radians)
   dh      double    Dec (radians)
   drh     double    proper motion in RA (dRA/dt, rad/Jyear)
   ddh     double    proper motion in Dec (dDec/dt, rad/Jyear)
   pxh     double    parallax (arcsec)
   rvh     double    radial velocity (km/s, positive = receding)

Returned (all FK5, equinox J2000.0, epoch J2000.0):
   r5      double    RA (radians)
   d5      double    Dec (radians)
   dr5     double    proper motion in RA (dRA/dt, rad/Jyear)
   dd5     double    proper motion in Dec (dDec/dt, rad/Jyear)
   px5     double    parallax (arcsec)
   rv5     double    radial velocity (km/s, positive = receding)

Notes:

1. This function transforms Hipparcos star positions and proper
   motions into FK5 J2000.0.

2. The proper motions in RA are dRA/dt rather than
   cos(Dec)*dRA/dt, and are per year rather than per century.

3. The FK5 to Hipparcos transformation is modeled as a pure
   rotation and spin;  zonal errors in the FK5 catalog are not
   taken into account.

4. See also iauFk52h, iauFk5hz, iauHfk5z.

Called:
   iauStarpv    star catalog data to space motion pv-vector
   iauFk5hip    FK5 to Hipparcos rotation and spin
   iauRv2m      r-vector to r-matrix
   iauRxp       product of r-matrix and p-vector
   iauTrxp      product of transpose of r-matrix and p-vector
   iauPxp       vector product of two p-vectors
   iauPmp       p-vector minus p-vector
   iauPvstar    space motion pv-vector to star catalog data

Reference:

   F.Mignard & M.Froeschle, Astron.Astrophys., 354, 732-739 (2000).

This revision:  2017 October 12

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauH2fk5(double rh, double dh,
#               double drh, double ddh, double pxh, double rvh,
#               double *r5, double *d5,
#               double *dr5, double *dd5, double *px5, double *rv5)

function iauH2fk5(rh::Real, dh::Real, drh::Real, ddh::Real, pxh::Real, rvh::Real)
   ref_r5  = Ref{Float64}(0.0)
   ref_d5  = Ref{Float64}(0.0)
   ref_dr5 = Ref{Float64}(0.0)
   ref_dd5 = Ref{Float64}(0.0)
   ref_px5 = Ref{Float64}(0.0)
   ref_rv5 = Ref{Float64}(0.0)
   
   ccall((:iauH2fk5, libsofa_c), Cdouble,
         (Cdouble, Cdouble, Cdouble, Cdouble,
         Cdouble, Cdouble, 
         Ref{Cdouble},  Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble},
         Ref{Cdouble}, Ref{Cdouble}, ),
         convert(Float64, rh), convert(Float64, dh),
         convert(Float64, drh), convert(Float64, ddh),
         convert(Float64, pxh), convert(Float64, rvh),
         ref_r5, ref_d5, ref_dr5, ref_dd5, ref_px5, ref_rv5)

   return ref_r5[], ref_d5[], ref_dr5[], ref_dd5[], ref_px5[], ref_rv5[]
end