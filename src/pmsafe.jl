export iauPmsafe
"""
Star proper motion:  update star catalog data for space motion, with
special handling to handle the zero parallax case.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
    ra1    double      right ascension (radians), before
    dec1   double      declination (radians), before
    pmr1   double      RA proper motion (radians/year), before
    pmd1   double      Dec proper motion (radians/year), before
    px1    double      parallax (arcseconds), before
    rv1    double      radial velocity (km/s, +ve = receding), before
    ep1a   double      "before" epoch, part A (Note 1)
    ep1b   double      "before" epoch, part B (Note 1)
    ep2a   double      "after" epoch, part A (Note 1)
    ep2b   double      "after" epoch, part B (Note 1)

Returned:
    ra2    double      right ascension (radians), after
    dec2   double      declination (radians), after
    pmr2   double      RA proper motion (radians/year), after
    pmd2   double      Dec proper motion (radians/year), after
    px2    double      parallax (arcseconds), after
    rv2    double      radial velocity (km/s, +ve = receding), after

Returned (function value):
        int         status:
                        -1 = system error (should not occur)
                        0 = no warnings or errors
                        1 = distance overridden (Note 6)
                        2 = excessive velocity (Note 7)
                        4 = solution didn't converge (Note 8)
                    else = binary logical OR of the above warnings

Notes:

1. The starting and ending TDB epochs ep1a+ep1b and ep2a+ep2b are
    Julian Dates, apportioned in any convenient way between the two
    parts (A and B).  For example, JD(TDB)=2450123.7 could be
    expressed in any of these ways, among others:

        epNa            epNb

        2450123.7           0.0       (JD method)
        2451545.0       -1421.3       (J2000 method)
        2400000.5       50123.2       (MJD method)
        2450123.5           0.2       (date & time method)

    The JD method is the most natural and convenient to use in cases
    where the loss of several decimal digits of resolution is
    acceptable.  The J2000 method is best matched to the way the
    argument is handled internally and will deliver the optimum
    resolution.  The MJD method and the date & time methods are both
    good compromises between resolution and convenience.

2. In accordance with normal star-catalog conventions, the object's
    right ascension and declination are freed from the effects of
    secular aberration.  The frame, which is aligned to the catalog
    equator and equinox, is Lorentzian and centered on the SSB.

    The proper motions are the rate of change of the right ascension
    and declination at the catalog epoch and are in radians per TDB
    Julian year.

    The parallax and radial velocity are in the same frame.

3. Care is needed with units.  The star coordinates are in radians
    and the proper motions in radians per Julian year, but the
    parallax is in arcseconds.

4. The RA proper motion is in terms of coordinate angle, not true
    angle.  If the catalog uses arcseconds for both RA and Dec proper
    motions, the RA proper motion will need to be divided by cos(Dec)
    before use.

5. Straight-line motion at constant speed, in the inertial frame, is
    assumed.

6. An extremely small (or zero or negative) parallax is overridden
    to ensure that the object is at a finite but very large distance,
    but not so large that the proper motion is equivalent to a large
    but safe speed (about 0.1c using the chosen constant).  A warning
    status of 1 is added to the status if this action has been taken.

7. If the space velocity is a significant fraction of c (see the
    constant VMAX in the function iauStarpv), it is arbitrarily set
    to zero.  When this action occurs, 2 is added to the status.

8. The relativistic adjustment carried out in the iauStarpv function
    involves an iterative calculation.  If the process fails to
    converge within a set number of iterations, 4 is added to the
    status.

Called:
    iauSeps      angle between two points
    iauStarpm    update star catalog data for space motion

This revision:   2014 July 1

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauPmsafe(double ra1, double dec1, double pmr1, double pmd1,
#               double px1, double rv1,
#               double ep1a, double ep1b, double ep2a, double ep2b,
#               double *ra2, double *dec2, double *pmr2, double *pmd2,
#               double *px2, double *rv2)

function iauPmsafe(ra1::Real, dec1::Real, pmr1::Real, pmd1::Real,
                 px1::Real, rv1::Real, ep1a::Real, ep1b::Real,
                 ep2a::Real, ep2b::Real)

    ref_ra2  = Ref{Float64}(0.0)
    ref_dec2 = Ref{Float64}(0.0)
    ref_pmr2 = Ref{Float64}(0.0)
    ref_pmd2 = Ref{Float64}(0.0)
    ref_px2  = Ref{Float64}(0.0)
    ref_rv2  = Ref{Float64}(0.0)


    status = ccall((:iauPmsafe, libsofa_c), Cint,
       (Cdouble, Cdouble, Cdouble, Cdouble,
        Cdouble, Cdouble, Cdouble,
        Cdouble, Cdouble, Cdouble,
        Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble},
        Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}),
       convert(Float64, ra1), convert(Float64, dec1),
       convert(Float64, pmr1), convert(Float64, pmd1),
       convert(Float64, px1), convert(Float64, rv1),
       convert(Float64, ep1a), convert(Float64, ep1b),
       convert(Float64, ep2a), convert(Float64, ep2b),
       ref_ra2, ref_dec2, ref_pmr2, ref_pmd2, ref_px2, ref_rv2)


   return status, ref_ra2[], ref_dec2[], ref_pmr2[], ref_pmd2[], ref_px2[], ref_rv2[]
end