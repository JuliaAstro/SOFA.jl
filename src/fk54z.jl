export iauFk54z
"""
Convert a J2000.0 FK5 star position to B1950.0 FK4, assuming zero
proper motion in FK5 and parallax.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   - r2000,d2000    double   J2000.0 FK5 RA,Dec (rad)
   - bepoch         double   Besselian epoch (e.g. 1950.0)

Returned:
   - r1950,d1950    double   B1950.0 FK4 RA,Dec (rad) at epoch BEPOCH
   - dr1950,dd1950  double   B1950.0 FK4 proper motions (rad/trop.yr)

Notes:

1. In contrast to the iauFk524  routine, here the FK5 proper
   motions, the parallax and the radial velocity are presumed zero.

2. This function converts a star position from the IAU 1976 FK5
   (Fricke) system to the former FK4 (Bessel-Newcomb) system, for
   cases such as distant radio sources where it is presumed there is
   zero parallax and no proper motion.  Because of the E-terms of
   aberration, such objects have (in general) non-zero proper motion
   in FK4, and the present routine returns those fictitious proper
   motions.

3. Conversion from B1950.0 FK4 to J2000.0 FK5 only is provided for.
   Conversions involving other equinoxes would require additional
   treatment for precession.

4. The position returned by this routine is in the B1950.0 FK4
   reference system but at Besselian epoch BEPOCH.  For comparison
   with catalogs the BEPOCH argument will frequently be 1950.0. (In
   this context the distinction between Besselian and Julian epoch
   is insignificant.)

5. The RA component of the returned (fictitious) proper motion is
   dRA/dt rather than cos(Dec)*dRA/dt.

Called:
   - iauAnp       normalize angle into range 0 to 2pi
   - iauC2s       p-vector to spherical
   - iauFk524     FK4 to FK5
   - iauS2c       spherical to p-vector

This revision:   2018 December 5

SOFA release 2019-07-22

Copyright (C) 2019 IAU SOFA Board.  See notes at end.
"""

# void iauFk54z(double r2000, double d2000, double bepoch,
#               double *r1950, double *d1950,
#               double *dr1950, double *dd1950)

function iauFk54z(r2000::Real, d2000::Real, bepoch::Real)
   ref_r1950  = Ref{Float64}(0.0)
   ref_d1950  = Ref{Float64}(0.0)
   ref_dr1950 = Ref{Float64}(0.0)
   ref_dd1950 = Ref{Float64}(0.0)

   ccall((:iauFk54z, libsofa_c), Cvoid,
         (Cdouble, Cdouble, Cdouble,
         Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, ),
         convert(Float64, r2000), convert(Float64, d2000),
         convert(Float64, bepoch),
         ref_r1950, ref_d1950, ref_dr1950, ref_dd1950)

   return ref_r1950[], ref_d1950[], ref_dr1950[], ref_dd1950[]
end