export iauZr
"""
Initialize an r-matrix to the null matrix.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Returned
   r        double[3][3]    r-matrix

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauZr()
    r = zeros(Float64, 3, 3)

    ccall((:iauZr, libsofa_c), Cvoid, (Ptr{Cdouble},), r)

    # Transpose since C call return row-major operation
    return SMatrix{3, 3}(r')
end
