export iauIr
"""
Initialize an r-matrix to the identity matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Returned
   r       double[3][3]    r-matrix

This revision:  2021 May 11

SOFA release 2021-05-12

Copyright (C) 2021 IAU SOFA Board.  See notes at end.
"""
function iauIr()
    # Allocate return values
    I = zeros(Float64, 3, 3)

    ccall((:iauIr, libsofa_c), Cvoid, (Ptr{Cdouble},), I)

    return SMatrix{3, 3}(I')
end
