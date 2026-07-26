export iauCpv
"""
Copy a position/velocity vector.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   pv     double[2][3]    position/velocity vector to be copied

### Returned
   c      double[2][3]    copy

Called:
   iauCp        copy p-vector

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauCpv(pv::AbstractMatrix{<:Real})

    # Allocate return value
    c = zeros(Float64, 3, 2)

    ccall(
        (:iauCpv, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}),
        convert(Matrix{Float64}, pv'), c
    )

    return SMatrix{2, 3}(c')
end
