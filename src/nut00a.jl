export iauNut00a
"""
Nutation, IAU 2000A model (MHB2000 luni-solar and planetary nutation
with free core nutation omitted).

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  canonical model.

Given:
   date1,date2   double   TT as a 2-part Julian Date (Note 1)

Returned:
   dpsi,deps     double   nutation, luni-solar + planetary (Note 2)

Notes:

1. The TT date date1+date2 is a Julian Date, apportioned in any
   convenient way between the two arguments.  For example,
   JD(TT)=2450123.7 could be expressed in any of these ways,
   among others:

         date1          date2

      2450123.7           0.0       (JD method)
      2451545.0       -1421.3       (J2000 method)
      2400000.5       50123.2       (MJD method)
      2450123.5           0.2       (date & time method)

   The JD method is the most natural and convenient to use in
   cases where the loss of several decimal digits of resolution
   is acceptable.  The J2000 method is best matched to the way
   the argument is handled internally and will deliver the
   optimum resolution.  The MJD method and the date & time methods
   are both good compromises between resolution and convenience.

2. The nutation components in longitude and obliquity are in radians
   and with respect to the equinox and ecliptic of date.  The
   obliquity at J2000.0 is assumed to be the Lieske et al. (1977)
   value of 84381.448 arcsec.

   Both the luni-solar and planetary nutations are included.  The
   latter are due to direct planetary nutations and the
   perturbations of the lunar and terrestrial orbits.

3. The function computes the MHB2000 nutation series with the
   associated corrections for planetary nutations.  It is an
   implementation of the nutation part of the IAU 2000A precession-
   nutation model, formally adopted by the IAU General Assembly in
   2000, namely MHB2000 (Mathews et al. 2002), but with the free
   core nutation (FCN - see Note 4) omitted.

4. The full MHB2000 model also contains contributions to the
   nutations in longitude and obliquity due to the free-excitation
   of the free-core-nutation during the period 1979-2000.  These FCN
   terms, which are time-dependent and unpredictable, are NOT
   included in the present function and, if required, must be
   independently computed.  With the FCN corrections included, the
   present function delivers a pole which is at current epochs
   accurate to a few hundred microarcseconds.  The omission of FCN
   introduces further errors of about that size.

5. The present function provides classical nutation.  The MHB2000
   algorithm, from which it is adapted, deals also with (i) the
   offsets between the GCRS and mean poles and (ii) the adjustments
   in longitude and obliquity due to the changed precession rates.
   These additional functions, namely frame bias and precession
   adjustments, are supported by the SOFA functions iauBi00  and
   iauPr00.

6. The MHB2000 algorithm also provides "total" nutations, comprising
   the arithmetic sum of the frame bias, precession adjustments,
   luni-solar nutation and planetary nutation.  These total
   nutations can be used in combination with an existing IAU 1976
   precession implementation, such as iauPmat76,  to deliver GCRS-
   to-true predictions of sub-mas accuracy at current dates.
   However, there are three shortcomings in the MHB2000 model that
   must be taken into account if more accurate or definitive results
   are required (see Wallace 2002):

      (i) The MHB2000 total nutations are simply arithmetic sums,
         yet in reality the various components are successive Euler
         rotations.  This slight lack of rigor leads to cross terms
         that exceed 1 mas after a century.  The rigorous procedure
         is to form the GCRS-to-true rotation matrix by applying the
         bias, precession and nutation in that order.

      (ii) Although the precession adjustments are stated to be with
         respect to Lieske et al. (1977), the MHB2000 model does
         not specify which set of Euler angles are to be used and
         how the adjustments are to be applied.  The most literal
         and straightforward procedure is to adopt the 4-rotation
         epsilon_0, psi_A, omega_A, xi_A option, and to add DPSIPR
         to psi_A and DEPSPR to both omega_A and eps_A.

      (iii) The MHB2000 model predates the determination by Chapront
         et al. (2002) of a 14.6 mas displacement between the
         J2000.0 mean equinox and the origin of the ICRS frame.  It
         should, however, be noted that neglecting this displacement
         when calculating star coordinates does not lead to a
         14.6 mas change in right ascension, only a small second-
         order distortion in the pattern of the precession-nutation
         effect.

   For these reasons, the SOFA functions do not generate the "total
   nutations" directly, though they can of course easily be
   generated by calling iauBi00, iauPr00 and the present function
   and adding the results.

7. The MHB2000 model contains 41 instances where the same frequency
   appears multiple times, of which 38 are duplicates and three are
   triplicates.  To keep the present code close to the original MHB
   algorithm, this small inefficiency has not been corrected.

Called:
   iauFal03     mean anomaly of the Moon
   iauFaf03     mean argument of the latitude of the Moon
   iauFaom03    mean longitude of the Moon's ascending node
   iauFame03    mean longitude of Mercury
   iauFave03    mean longitude of Venus
   iauFae03     mean longitude of Earth
   iauFama03    mean longitude of Mars
   iauFaju03    mean longitude of Jupiter
   iauFasa03    mean longitude of Saturn
   iauFaur03    mean longitude of Uranus
   iauFapa03    general accumulated precession in longitude

References:

   Chapront, J., Chapront-Touze, M. & Francou, G. 2002,
   Astron.Astrophys. 387, 700

   Lieske, J.H., Lederle, T., Fricke, W. & Morando, B. 1977,
   Astron.Astrophys. 58, 1-16

   Mathews, P.M., Herring, T.A., Buffet, B.A. 2002, J.Geophys.Res.
   107, B4.  The MHB_2000 code itself was obtained on 9th September
   2002 from ftp//maia.usno.navy.mil/conv2000/chapter5/IAU2000A.

   Simon, J.-L., Bretagnon, P., Chapront, J., Chapront-Touze, M.,
   Francou, G., Laskar, J. 1994, Astron.Astrophys. 282, 663-683

   Souchay, J., Loysel, B., Kinoshita, H., Folgueira, M. 1999,
   Astron.Astrophys.Supp.Ser. 135, 111

   Wallace, P.T., "Software for Implementing the IAU 2000
   Resolutions", in IERS Workshop 5.1 (2002)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauNut00a(double date1, double date2, double *dpsi, double *deps)

function iauNut00a(date1::Real, date2::Real)
   # Allocate return values
   ref_dpsi = Ref{Float64}(0.0)
   ref_deps = Ref{Float64}(0.0)

   ccall((:iauNut00a, libsofa_c), Cvoid, 
        (Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}), 
        convert(Float64, date1), convert(Float64, date2),
        ref_dpsi, ref_deps)

   return ref_dpsi[], ref_deps[]
end