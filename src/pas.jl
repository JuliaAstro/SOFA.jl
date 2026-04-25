export iauPas
"""
Position-angle from spherical coordinates.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   al     double     longitude of point A (e.g. RA) in radians
   ap     double     latitude of point A (e.g. Dec) in radians
   bl     double     longitude of point B
   bp     double     latitude of point B

Returned (function value):
         double     position angle of B with respect to A

Notes:

1. The result is the bearing (position angle), in radians, of point
   B with respect to point A.  It is in the range -pi to +pi.  The
   sense is such that if B is a small distance "east" of point A,
   the bearing is approximately +pi/2.

2. Zero is returned if the two points are coincident.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauPas(double al, double ap, double bl, double bp)

function iauPas(al::Real, ap::Real, bl::Real, bp::Real)
   return ccall((:iauPas, libsofa_c), Cdouble,
       (Cdouble, Cdouble, Cdouble, Cdouble),
       convert(Float64, al),
       convert(Float64, ap),
       convert(Float64, bl),
       convert(Float64, bp))
end