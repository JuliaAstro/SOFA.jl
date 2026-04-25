export iauC2ixy
"""
Form the celestial to intermediate-frame-of-date matrix for a given
date when the CIP X,Y coordinates are known.  IAU 2000.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
    date1,date2 double       TT as a 2-part Julian Date (Note 1)
    x,y         double       Celestial Intermediate Pole (Note 2)

Returned:
    rc2i        double[3][3] celestial-to-intermediate matrix (Note 3)

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

2. The Celestial Intermediate Pole coordinates are the x,y components
    of the unit vector in the Geocentric Celestial Reference System.

3. The matrix rc2i is the first stage in the transformation from
    celestial to terrestrial coordinates:

    [TRS] = RPOM * R_3(ERA) * rc2i * [CRS]

            = RC2T * [CRS]

    where [CRS] is a vector in the Geocentric Celestial Reference
    System and [TRS] is a vector in the International Terrestrial
    Reference System (see IERS Conventions 2003), ERA is the Earth
    Rotation Angle and RPOM is the polar motion matrix.

4. Although its name does not include "00", This function is in fact
    specific to the IAU 2000 models.

Called:
    iauC2ixys    celestial-to-intermediate matrix, given X,Y and s
    iauS00       the CIO locator s, given X,Y, IAU 2000A

Reference:

    McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
    IERS Technical Note No. 32, BKG (2004)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
# void iauC2ixy(double date1, double date2, double x, double y,
#               double rc2i[3][3])

function iauC2ixy(date1::Real, date2::Real, x::Real, y::Real)

    # Allocate return value
    rc2i = zeros(Float64, 3, 3)

    ccall((:iauC2ixy, libsofa_c), Cvoid,
          (Cdouble, Cdouble, Cdouble, Cdouble,
          Ptr{Cdouble}),
          convert(Float64, date1), convert(Float64, date2),
          convert(Float64, x), convert(Float64, y),
          rc2i)

    return SMatrix{3,3}(rc2i')
 end