export iauRy
"""
Rotate an r-matrix about the y-axis.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   theta  double          angle (radians)

Given and returned:
   r      double[3][3]    r-matrix, rotated

### Notes

1. Calling this function with positive theta incorporates in the
   supplied r-matrix r an additional rotation, about the y-axis,
   anticlockwise as seen looking towards the origin from positive y.

2. The additional rotation can be represented by this matrix:

      (  + cos(theta)     0      - sin(theta)  )
      (                                        )
      (       0           1           0        )
      (                                        )
      (  + sin(theta)     0      + cos(theta)  )

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauRy(theta::Real, r::AbstractMatrix{<:Real})

    # Transpose matrix upfront
    r = Matrix{Float64}(r') # Transpose input up front

    ccall((:iauRy, libsofa_c), Cvoid, (Cdouble, Ptr{Cdouble}), theta, pointer(r))

    return convert(Matrix{Float64}, r')
end
