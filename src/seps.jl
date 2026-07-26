export iauSeps
"""
Angular separation between two sets of spherical coordinates.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   al     double       first longitude (radians)
   ap     double       first latitude (radians)
   bl     double       second longitude (radians)
   bp     double       second latitude (radians)

Returned (function value):
         double       angular separation (radians)

Called:
   iauS2c       spherical coordinates to unit vector
   iauSepp      angular separation between two p-vectors

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauSeps(al::Real, ap::Real, bl::Real, bp::Real)
    return ccall(
        (:iauSeps, libsofa_c), Cdouble,
        (Cdouble, Cdouble, Cdouble, Cdouble),
        convert(Float64, al),
        convert(Float64, ap),
        convert(Float64, bl),
        convert(Float64, bp)
    )
end
