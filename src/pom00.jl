export iauPom00
"""
Form the matrix of polar motion for a given date, IAU 2000.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
    xp,yp    double    coordinates of the pole (radians, Note 1)
    sp       double    the TIO locator s' (radians, Note 2)

Returned:
    rpom     double[3][3]   polar-motion matrix (Note 3)

Notes:

1. The arguments xp and yp are the coordinates (in radians) of the
    Celestial Intermediate Pole with respect to the International
    Terrestrial Reference System (see IERS Conventions 2003),
    measured along the meridians to 0 and 90 deg west respectively.

2. The argument sp is the TIO locator s', in radians, which
    positions the Terrestrial Intermediate Origin on the equator.  It
    is obtained from polar motion observations by numerical
    integration, and so is in essence unpredictable.  However, it is
    dominated by a secular drift of about 47 microarcseconds per
    century, and so can be taken into account by using s' = -47*t,
    where t is centuries since J2000.0.  The function iauSp00
    implements this approximation.

3. The matrix operates in the sense V(TRS) = rpom * V(CIP), meaning
    that it is the final rotation when computing the pointing
    direction to a celestial source.

Called:
    iauIr        initialize r-matrix to identity
    iauRz        rotate around Z-axis
    iauRy        rotate around Y-axis
    iauRx        rotate around X-axis

Reference:

    McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
    IERS Technical Note No. 32, BKG (2004)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPom00(double xp, double yp, double sp, double rpom[3][3])

function iauPom00(xp, yp, sp)
    rpom = zeros(Float64, 3, 3)

    ccall((:iauPom00, libsofa_c), Cvoid, 
            (Cdouble, Cdouble, Cdouble, Ptr{Cdouble}),
            xp, yp, sp, rpom)

     # Transpose since C call return row-major operation
    return SMatrix{3,3}(rpom')
end