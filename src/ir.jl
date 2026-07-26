export iauIr
"""
Initialize an r-matrix to the identity matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Returned
   r       double[3][3]    r-matrix

This revision:  2013 June 18

SOFA release 2020-07-21

Copyright (C) 2020 IAU SOFA Board.  See notes at end.
"""
function iauIr()
    # Allocate return values
    I = zeros(Float64, 3, 3)

    ccall((:iauIr, libsofa_c), Cvoid, (Ptr{Cdouble},), I)

    return SMatrix{3, 3}(I')
end
