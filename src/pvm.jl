export iauPvm
"""
Modulus of pv-vector.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
    pv     double[2][3]   pv-vector

### Returned
    r      double         modulus of position component
    s      double         modulus of velocity component

Called:
    iauPm        modulus of p-vector

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauPvm(pv::AbstractMatrix{<:Real})
    # Preallocate return values
    ref_r = Ref{Float64}(0.0)
    ref_s = Ref{Float64}(0.0)

    ccall(
        (:iauPvm, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ref{Cdouble}, Ref{Cdouble}),
        convert(Matrix{Float64}, pv'),
        ref_r, ref_s
    )

    return ref_r[], ref_s[]
end
