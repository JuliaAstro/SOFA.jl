export iauCr
"""
Copy an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   r        double[3][3]    r-matrix to be copied

### Returned
   c        double[3][3]    copy

Called:
   iauCp        copy p-vector

This revision:  2021 May 11

SOFA release 2021-05-12

Copyright (C) 2021 IAU SOFA Board.  See notes at end.
"""
function iauCr(r::AbstractMatrix{<:Real})

    # Allocate return value
    c = zeros(Float64, 3, 3)

    ccall(
        (:iauCr, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}),
        convert(Matrix{Float64}, r'), c
    )

    return SMatrix{3, 3}(c')
end
