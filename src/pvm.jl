export iauPvm
"""
Modulus of pv-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
    pv     double[2][3]   pv-vector

Returned:
    r      double         modulus of position component
    s      double         modulus of velocity component

Called:
    iauPm        modulus of p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPvm(double pv[2][3], double *r, double *s)
function iauPvm(pv::AbstractMatrix{<:Real})
    # Preallocate return values
    ref_r = Ref{Float64}(0.0)
    ref_s = Ref{Float64}(0.0)

    ccall((:iauPvm, libsofa_c), Cvoid,
          (Ptr{Cdouble}, Ref{Cdouble}, Ref{Cdouble}),
           convert(Array{Float64, 2}, pv'),
           ref_r, ref_s)

    return ref_r[], ref_s[]
 end