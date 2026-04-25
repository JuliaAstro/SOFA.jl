export iauStarpv
"""
Convert star catalog coordinates to position+velocity vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given (Note 1):
   ra     double        right ascension (radians)
   dec    double        declination (radians)
   pmr    double        RA proper motion (radians/year)
   pmd    double        Dec proper motion (radians/year)
   px     double        parallax (arcseconds)
   rv     double        radial velocity (km/s, positive = receding)

Returned (Note 2):
   pv     double[2][3]  pv-vector (au, au/day)

Returned (function value):
         int           status:
                           0 = no warnings
                           1 = distance overridden (Note 6)
                           2 = excessive speed (Note 7)
                           4 = solution didn't converge (Note 8)
                        else = binary logical OR of the above

Notes:

1. The star data accepted by this function are "observables" for an
   imaginary observer at the solar-system barycenter.  Proper motion
   and radial velocity are, strictly, in terms of barycentric
   coordinate time, TCB.  For most practical applications, it is
   permissible to neglect the distinction between TCB and ordinary
   "proper" time on Earth (TT/TAI).  The result will, as a rule, be
   limited by the intrinsic accuracy of the proper-motion and
   radial-velocity data;  moreover, the pv-vector is likely to be
   merely an intermediate result, so that a change of time unit
   would cancel out overall.

   In accordance with normal star-catalog conventions, the object's
   right ascension and declination are freed from the effects of
   secular aberration.  The frame, which is aligned to the catalog
   equator and equinox, is Lorentzian and centered on the SSB.

2. The resulting position and velocity pv-vector is with respect to
   the same frame and, like the catalog coordinates, is freed from
   the effects of secular aberration.  Should the "coordinate
   direction", where the object was located at the catalog epoch, be
   required, it may be obtained by calculating the magnitude of the
   position vector pv[0][0-2] dividing by the speed of light in
   au/day to give the light-time, and then multiplying the space
   velocity pv[1][0-2] by this light-time and adding the result to
   pv[0][0-2].

   Summarizing, the pv-vector returned is for most stars almost
   identical to the result of applying the standard geometrical
   "space motion" transformation.  The differences, which are the
   subject of the Stumpff paper referenced below, are:

   (i) In stars with significant radial velocity and proper motion,
   the constantly changing light-time distorts the apparent proper
   motion.  Note that this is a classical, not a relativistic,
   effect.

   (ii) The transformation complies with special relativity.

3. Care is needed with units.  The star coordinates are in radians
   and the proper motions in radians per Julian year, but the
   parallax is in arcseconds; the radial velocity is in km/s, but
   the pv-vector result is in au and au/day.

4. The RA proper motion is in terms of coordinate angle, not true
   angle.  If the catalog uses arcseconds for both RA and Dec proper
   motions, the RA proper motion will need to be divided by cos(Dec)
   before use.

5. Straight-line motion at constant speed, in the inertial frame,
   is assumed.

6. An extremely small (or zero or negative) parallax is interpreted
   to mean that the object is on the "celestial sphere", the radius
   of which is an arbitrary (large) value (see the constant PXMIN).
   When the distance is overridden in this way, the status,
   initially zero, has 1 added to it.

7. If the space velocity is a significant fraction of c (see the
   constant VMAX), it is arbitrarily set to zero.  When this action
   occurs, 2 is added to the status.

8. The relativistic adjustment involves an iterative calculation.
   If the process fails to converge within a set number (IMAX) of
   iterations, 4 is added to the status.

9. The inverse transformation is performed by the function
   iauPvstar.

Called:
   iauS2pv      spherical coordinates to pv-vector
   iauPm        modulus of p-vector
   iauZp        zero p-vector
   iauPn        decompose p-vector into modulus and direction
   iauPdp       scalar product of two p-vectors
   iauSxp       multiply p-vector by scalar
   iauPmp       p-vector minus p-vector
   iauPpp       p-vector plus p-vector

Reference:

   Stumpff, P., 1985, Astron.Astrophys. 144, 232-240.

This revision:  2017 March 16

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauStarpv(double ra, double dec,
#               double pmr, double pmd, double px, double rv,
#               double pv[2][3])

function iauStarpv(ra::Real, dec::Real, pmr::Real, pmd::Real,
                   px::Real, rv::Real)

   pv = zeros(Float64, 3, 2)

   status = ccall((:iauStarpv, libsofa_c), Cint,
       (Cdouble, Cdouble, Cdouble, Cdouble,
       Cdouble, Cdouble, Ptr{Cdouble}),
       convert(Float64, ra), convert(Float64, dec),
       convert(Float64, pmr), convert(Float64, pmd),
       convert(Float64, px), convert(Float64, rv),
       pv)

   return status, SMatrix{2,3}(pv')
end