export iauSxpv
"""
Multiply a pv-vector by a scalar.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   s       double          scalar
   pv      double[2][3]    pv-vector

### Returned
   spv     double[2][3]    s * pv

Note:
   It is permissible for pv and spv to be the same array.

Called:
   iauS2xpv     multiply pv-vector by two scalars

This revision:  2020 August 25

SOFA release 2021-01-25

Copyright (C) 2021 IAU SOFA Board.  See notes at end.
"""
function iauSxpv(s::Real, pv::AbstractMatrix{<:Real})
    spv = zeros(Float64, 3, 2)

    ccall(
        (:iauSxpv, libsofa_c), Cvoid,
        (Cdouble, Ptr{Cdouble}, Ptr{Cdouble}),
        convert(Float64, s),
        convert(Matrix{Float64}, pv'),
        spv
    )

    return SMatrix{2, 3}(spv')
end
