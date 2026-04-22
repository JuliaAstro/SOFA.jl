export iauFk425
"""
Convert B1950.0 FK4 star catalog data to J2000.0 FK5.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

This function converts a star's catalog data from the old FK4
(Bessel-Newcomb) system to the later IAU 1976 FK5 (Fricke) system.

Given: (all B1950.0, FK4)
   - r1950,d1950    double   B1950.0 RA,Dec (rad)
   - dr1950,dd1950  double   B1950.0 proper motions (rad/trop.yr)
   - p1950          double   parallax (arcsec)
   - v1950          double   radial velocity (km/s, +ve = moving away)

Returned: (all J2000.0, FK5)
   - r2000,d2000    double   J2000.0 RA,Dec (rad)
   - dr2000,dd2000  double   J2000.0 proper motions (rad/Jul.yr)
   - p2000          double   parallax (arcsec)
   - v2000          double   radial velocity (km/s, +ve = moving away)

Notes:

1. The proper motions in RA are dRA/dt rather than cos(Dec)*dRA/dt,
   and are per year rather than per century.

2. The conversion is somewhat complicated, for several reasons:

   . Change of standard epoch from B1950.0 to J2000.0.

   . An intermediate transition date of 1984 January 1.0 TT.

   . A change of precession model.

   . Change of time unit for proper motion (tropical to Julian).

   . FK4 positions include the E-terms of aberration, to simplify
      the hand computation of annual aberration.  FK5 positions
      assume a rigorous aberration computation based on the Earth's
      barycentric velocity.

   . The E-terms also affect proper motions, and in particular cause
      objects at large distances to exhibit fictitious proper
      motions.

   The algorithm is based on Smith et al. (1989) and Yallop et al.
   (1989), which presented a matrix method due to Standish (1982) as
   developed by Aoki et al. (1983), using Kinoshita's development of
   Andoyer's post-Newcomb precession.  The numerical constants from
   Seidelmann (1992) are used canonically.

3. Conversion from B1950.0 FK4 to J2000.0 FK5 only is provided for.
   Conversions for different epochs and equinoxes would require
   additional treatment for precession, proper motion and E-terms.

4. In the FK4 catalog the proper motions of stars within 10 degrees
   of the poles do not embody differential E-terms effects and
   should, strictly speaking, be handled in a different manner from
   stars outside these regions.  However, given the general lack of
   homogeneity of the star data available for routine astrometry,
   the difficulties of handling positions that may have been
   determined from astrometric fields spanning the polar and non-
   polar regions, the likelihood that the differential E-terms
   effect was not taken into account when allowing for proper motion
   in past astrometry, and the undesirability of a discontinuity in
   the algorithm, the decision has been made in this SOFA algorithm
   to include the effects of differential E-terms on the proper
   motions for all stars, whether polar or not.  At epoch J2000.0,
   and measuring "on the sky" rather than in terms of RA change, the
   errors resulting from this simplification are less than
   1 milliarcsecond in position and 1 milliarcsecond per century in
   proper motion.

Called:
   - iauAnp       normalize angle into range 0 to 2pi
   - iauPv2s      pv-vector to spherical coordinates
   - iauPdp       scalar product of two p-vectors
   - iauPvmpv     pv-vector minus pv_vector
   - iauPvppv     pv-vector plus pv_vector
   - iauS2pv      spherical coordinates to pv-vector
   - iauSxp       multiply p-vector by scalar

References:

   - Aoki, S. et al., 1983, "Conversion matrix of epoch B1950.0
   FK4-based positions of stars to epoch J2000.0 positions in
   accordance with the new IAU resolutions".  Astron.Astrophys.
   128, 263-267.

   - Seidelmann, P.K. (ed), 1992, "Explanatory Supplement to the
   Astronomical Almanac", ISBN 0-935702-68-7.

   - Smith, C.A. et al., 1989, "The transformation of astrometric
   catalog systems to the equinox J2000.0".  Astron.J. 97, 265.

   - Standish, E.M., 1982, "Conversion of positions and proper motions
   from B1950.0 to the IAU system at J2000.0".  Astron.Astrophys.,
   115, 1, 20-22.

   - Yallop, B.D. et al., 1989, "Transformation of mean star places
   from FK4 B1950.0 to FK5 J2000.0 using matrices in 6-space".
   Astron.J. 97, 274.

This revision:   2018 December 5

SOFA release 2019-07-22

Copyright (C) 2019 IAU SOFA Board.  See notes at end.
"""

# void iauFk425(double r1950, double d1950,
#               double dr1950, double dd1950,
#               double p1950, double v1950,
#               double *r2000, double *d2000,
#               double *dr2000, double *dd2000,
#               double *p2000, double *v2000)

function iauFk425(r1950::Real, d1950::Real, dr1950::Real, dd1950::Real,
                  p1950::Real, v1950::Real)
   ref_r2000 = Ref{Float64}(0.0)
   ref_d2000 = Ref{Float64}(0.0)
   ref_dr2000 = Ref{Float64}(0.0)
   ref_dd2000 = Ref{Float64}(0.0)
   ref_p2000 = Ref{Float64}(0.0)
   ref_v2000 = Ref{Float64}(0.0)
   
   ccall((:iauFk425, libsofa_c), Cvoid,
         (Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble,
         Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, 
         Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, ),
         convert(Float64, r1950), convert(Float64, d1950),
         convert(Float64, dr1950), convert(Float64, dd1950),
         convert(Float64, p1950), convert(Float64, v1950),
         ref_r2000, ref_d2000,
         ref_dr2000, ref_dd2000,
         ref_p2000, ref_v2000)

   return ref_r2000[], ref_d2000[], ref_dr2000[], ref_dd2000[], ref_p2000[], ref_v2000[]
end