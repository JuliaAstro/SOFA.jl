export iauRz
"""
Rotate an r-matrix about the z-axis.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   psi    double          angle (radians)

Given and returned:
   r      double[3][3]    r-matrix, rotated

### Notes

1. Calling this function with positive psi incorporates in the
   supplied r-matrix r an additional rotation, about the z-axis,
   anticlockwise as seen looking towards the origin from positive z.

2. The additional rotation can be represented by this matrix:

      (  + cos(psi)   + sin(psi)     0  )
      (                                 )
      (  - sin(psi)   + cos(psi)     0  )
      (                                 )
      (       0            0         1  )

This revision:  2021 May 11

SOFA release 2023-10-11

Copyright (C) 2023 IAU SOFA Board.  See notes at end.
"""
function iauRz(psi::Real, r::AbstractMatrix{<:Real})

    # Transpose matrix upfront
    r = Matrix{Float64}(r') # Transpose input up front

    ccall((:iauRz, libsofa_c), Cvoid, (Cdouble, Ptr{Cdouble}), psi, pointer(r))

    return convert(Matrix{Float64}, r')
end
