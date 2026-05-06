export iauPvmpv
"""
Subtract one pv-vector from another.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   a       double[2][3]      first pv-vector
   b       double[2][3]      second pv-vector

### Returned
   amb     double[2][3]      a - b

Note:
   It is permissible to re-use the same array for any of the
   arguments.

Called:
   iauPmp       p-vector minus p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauPvmpv(a::AbstractMatrix{<:Real}, b::AbstractMatrix{<:Real})
    # Preallocate return values
    amb = zeros(Float64, 3, 2)

    ccall(
        (:iauPvmpv, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}, Ref{Cdouble}),
        convert(Matrix{Float64}, a'),
        convert(Matrix{Float64}, b'),
        amb
    )

    return SMatrix{2, 3}(amb')
end
