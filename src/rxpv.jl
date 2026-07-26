export iauRxpv
"""
Multiply a pv-vector by an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   r        double[3][3]    r-matrix
   pv       double[2][3]    pv-vector

### Returned
   rpv      double[2][3]    r * pv

Notes:
1) The algorithm is for the simple case where the r-matrix r is not
   a function of time.  The case where r is a function of time leads
   to an additional velocity component equal to the product of the
   derivative of r and the position vector.
2) It is permissible for pv and rpv to be the same array.

Called:
   iauRxp       product of r-matrix and p-vector

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauRxpv(r::AbstractMatrix{<:Real}, pv::AbstractMatrix{<:Real})
    rpv = zeros(Float64, 3, 2)
    ccall(
        (:iauRxpv, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
        convert(Matrix{Float64}, r'),
        convert(Matrix{Float64}, pv'),
        rpv
    )

    return SMatrix{2, 3}(rpv')
end
