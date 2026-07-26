export iauZpv
"""
Zero a pv-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Returned
   pv       double[2][3]      zero pv-vector

Called:
   iauZp        zero p-vector

This revision:  2020 August 25

SOFA release 2021-01-25

Copyright (C) 2021 IAU SOFA Board.  See notes at end.
"""
function iauZpv()
    pv = zeros(Float64, 3, 2)

    ccall((:iauZpv, libsofa_c), Cvoid, (Ptr{Cdouble},), pv)

    # Transpose since C call return row-major operation
    return SMatrix{2, 3}(pv')
end
