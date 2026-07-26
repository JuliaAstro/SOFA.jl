export iauTrxpv
"""
Multiply a pv-vector by the transpose of an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   r        double[3][3]    r-matrix
   pv       double[2][3]    pv-vector

### Returned

   trpv     double[2][3]    r^T * pv
Notes:
1) The algorithm is for the simple case where the r-matrix r is not
   a function of time.  The case where r is a function of time leads
   to an additional velocity component equal to the product of the
   derivative of the transpose of r and the position vector.
2) It is permissible for pv and rpv to be the same array.

Called:
   iauTr        transpose r-matrix
   iauRxpv      product of r-matrix and pv-vector

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauTrxpv(r::AbstractMatrix{<:Real}, pv::AbstractMatrix{<:Real})
    trpv = zeros(Float64, 3, 2)

    ccall(
        (:iauTrxpv, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
        convert(Matrix{Float64}, r'),
        convert(Matrix{Float64}, pv'),
        trpv
    )

    return SMatrix{2, 3}(trpv')
end
