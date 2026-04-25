export iauFk52h
"""
Transform FK5 (J2000.0) star data into the Hipparcos system.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given (all FK5, equinox J2000.0, epoch J2000.0):
   r5      double    RA (radians)
   d5      double    Dec (radians)
   dr5     double    proper motion in RA (dRA/dt, rad/Jyear)
   dd5     double    proper motion in Dec (dDec/dt, rad/Jyear)
   px5     double    parallax (arcsec)
   rv5     double    radial velocity (km/s, positive = receding)

Returned (all Hipparcos, epoch J2000.0):
   rh      double    RA (radians)
   dh      double    Dec (radians)
   drh     double    proper motion in RA (dRA/dt, rad/Jyear)
   ddh     double    proper motion in Dec (dDec/dt, rad/Jyear)
   pxh     double    parallax (arcsec)
   rvh     double    radial velocity (km/s, positive = receding)

Notes:

   1> This function transforms FK5 star positions and proper motions
   into the system of the Hipparcos catalog.

2. The proper motions in RA are dRA/dt rather than
   cos(Dec)*dRA/dt, and are per year rather than per century.

3. The FK5 to Hipparcos transformation is modeled as a pure
   rotation and spin;  zonal errors in the FK5 catalog are not
   taken into account.

4. See also iauH2fk5, iauFk5hz, iauHfk5z.

Called:
   iauStarpv    star catalog data to space motion pv-vector
   iauFk5hip    FK5 to Hipparcos rotation and spin
   iauRxp       product of r-matrix and p-vector
   iauPxp       vector product of two p-vectors
   iauPpp       p-vector plus p-vector
   iauPvstar    space motion pv-vector to star catalog data

Reference:

   F.Mignard & M.Froeschle, Astron.Astrophys., 354, 732-739 (2000).

This revision:  2017 October 12

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauFk52h(double r5, double d5,
#               double dr5, double dd5, double px5, double rv5,
#               double *rh, double *dh,
#               double *drh, double *ddh, double *pxh, double *rvh)

function iauFk52h(r5::Real, d5::Real, dr5::Real, dd5::Real, px5::Real, rv5::Real)
   ref_rh  = Ref{Float64}(0.0)
   ref_dh  = Ref{Float64}(0.0)
   ref_drh = Ref{Float64}(0.0)
   ref_ddh = Ref{Float64}(0.0)
   ref_pxh = Ref{Float64}(0.0)
   ref_rvh = Ref{Float64}(0.0)

   ccall((:iauFk52h, libsofa_c), Cdouble,
         (Cdouble, Cdouble, Cdouble, Cdouble,
         Cdouble, Cdouble,
         Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble},
         Ref{Cdouble}, Ref{Cdouble}, ),
         convert(Float64, r5), convert(Float64, d5),
         convert(Float64, dr5), convert(Float64, dd5),
         convert(Float64, px5), convert(Float64, rv5),
         ref_rh, ref_dh, ref_drh, ref_ddh, ref_pxh, ref_rvh)

   return ref_rh[], ref_dh[], ref_drh[], ref_ddh[], ref_pxh[], ref_rvh[]
end