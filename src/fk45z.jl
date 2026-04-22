export iauFk45z
"""
Convert a B1950.0 FK4 star position to J2000.0 FK5, assuming zero
proper motion in the FK5 system.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

This function converts a star's catalog data from the old FK4
(Bessel-Newcomb) system to the later IAU 1976 FK5 (Fricke) system,
in such a way that the FK5 proper motion is zero.  Because such a
star has, in general, a non-zero proper motion in the FK4 system,
the routine requires the epoch at which the position in the FK4
system was determined.

Given:
   - r1950,d1950    double   B1950.0 FK4 RA,Dec at epoch (rad)
   - bepoch         double   Besselian epoch (e.g. 1979.3D0)

Returned:
   - r2000,d2000    double   J2000.0 FK5 RA,Dec (rad)

Notes:

1. The epoch bepoch is strictly speaking Besselian, but if a
   Julian epoch is supplied the result will be affected only to a
   negligible extent.

2. The method is from Appendix 2 of Aoki et al. (1983), but using
   the constants of Seidelmann (1992).  See the routine iauFk425
   for a general introduction to the FK4 to FK5 conversion.

3. Conversion from equinox B1950.0 FK4 to equinox J2000.0 FK5 only
   is provided for.  Conversions for different starting and/or
   ending epochs would require additional treatment for precession,
   proper motion and E-terms.

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
   motions for all stars, whether polar or not.  At epoch 2000.0,
   and measuring "on the sky" rather than in terms of RA change, the
   errors resulting from this simplification are less than
   1 milliarcsecond in position and 1 milliarcsecond per century in
   proper motion.

References:

   Aoki, S. et al., 1983, "Conversion matrix of epoch B1950.0
   FK4-based positions of stars to epoch J2000.0 positions in
   accordance with the new IAU resolutions".  Astron.Astrophys.
   128, 263-267.

   Seidelmann, P.K. (ed), 1992, "Explanatory Supplement to the
   Astronomical Almanac", ISBN 0-935702-68-7.

Called:
   - iauAnp       normalize angle into range 0 to 2pi
   - iauC2s       p-vector to spherical
   - iauEpb2jd    Besselian epoch to Julian date
   - iauEpj       Julian date to Julian epoch
   - iauPdp       scalar product of two p-vectors
   - iauPmp       p-vector minus p-vector
   - iauPpsp      p-vector plus scaled p-vector
   - iauPvu       update a pv-vector
   - iauS2c       spherical to p-vector

This revision:   2018 December 5

SOFA release 2019-07-22

Copyright (C) 2019 IAU SOFA Board.  See notes at end.
"""

# void iauFk45z(double r1950, double d1950, double bepoch,
#               double *r2000, double *d2000)

function iauFk45z(r1950::Real, d1950::Real, bepoch::Real)
   ref_r2000 = Ref{Float64}(0.0)
   ref_d2000 = Ref{Float64}(0.0)
   
   ccall((:iauFk45z, libsofa_c), Cvoid,
         (Cdouble, Cdouble, Cdouble,
         Ref{Cdouble}, Ref{Cdouble}, ),
         convert(Float64, r1950), convert(Float64, d1950),
         convert(Float64, bepoch),
         ref_r2000, ref_d2000)

   return ref_r2000[], ref_d2000[]
end