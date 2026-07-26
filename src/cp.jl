export iauCp
"""
Copy a p-vector.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   p        double[3]     p-vector to be copied

### Returned
   c        double[3]     copy

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauCp(p::AbstractVector{<:Real})

    # Allocate return value
    c = zeros(Float64, 3)

    ccall(
        (:iauCp, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}),
        convert(Vector{Float64}, p), c
    )

    return SVector{3}(c)
end
