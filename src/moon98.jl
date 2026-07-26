export iauMoon98
"""
Approximate geocentric position and velocity of the Moon.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

n.b. Not IAU-endorsed and without canonical status.

### Given
    date1  double         TT date part A (Notes 1,4)
    date2  double         TT date part B (Notes 1,4)

### Returned
   pv     double[2][3]   Moon p,v, GCRS (au, au/d, Note 5)

### Notes

 1. The TT date date1+date2 is a Julian Date, apportioned in any
    convenient way between the two arguments.  For example,
    JD(TT)=2450123.7 could be expressed in any of these ways, among
    others:

        date1          date2

        2450123.7           0.0       (JD method)
        2451545.0       -1421.3       (J2000 method)
        2400000.5       50123.2       (MJD method)
        2450123.5           0.2       (date & time method)

    The JD method is the most natural and convenient to use in cases
    where the loss of several decimal digits of resolution is
    acceptable.  The J2000 method is best matched to the way the
    argument is handled internally and will deliver the optimum
    resolution.  The MJD method and the date & time methods are both
    good compromises between resolution and convenience.  The limited
    accuracy of the present algorithm is such that any of the methods
    is satisfactory.

 2. This function is a full implementation of the algorithm published
    by Meeus (see reference) except that the light-time correction to
    the Moon's mean longitude has been omitted.

 3. Comparisons with ELP/MPP02 over the interval 1950-2100 gave RMS
    errors of 2.9 arcsec in geocentric direction, 6.1 km in position
    and 36 mm/s in velocity.  The worst case errors were 18.3 arcsec
    in geocentric direction, 31.7 km in position and 172 mm/s in
    velocity.

 4. The original algorithm is expressed in terms of "dynamical time",
    which can either be TDB or TT without any significant change in
    the result.

 5. The result is with respect to the GCRS (the same as J2000.0 mean
    equator and equinox to within 23 mas).

Reference:
    Meeus, J., Astronomical Algorithms, 2nd edition, Willmann-Bell,
    1998, p337.

Called:
    iauS2pv      spherical coordinates to pv-vector
    iauPfw06     bias-precession F-W angles, IAU 2006
    iauIr        initialize r-matrix to identity
    iauRz        rotate around Z-axis
    iauRxp       product of r-matrix and p-vector
    iauRxpv      product of r-matrix and pv-vector

This revision:  2023 March 20

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauMoon98(date1::Real, date2::Real)

    # Allocate return value (C stores row-major pv[2][3])
    pv = zeros(Float64, 3, 2)

    ccall(
        (:iauMoon98, libsofa_c), Cvoid,
        (Cdouble, Cdouble, Ptr{Cdouble}),
        convert(Float64, date1),
        convert(Float64, date2),
        pv
    )

    return SMatrix{2, 3}(pv')
end
