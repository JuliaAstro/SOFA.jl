export iauRx
"""
Rotate an r-matrix about the x-axis.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   phi    double          angle (radians)

Given and returned:
   r      double[3][3]    r-matrix, rotated

Notes:

1. Calling this function with positive phi incorporates in the
   supplied r-matrix r an additional rotation, about the x-axis,
   anticlockwise as seen looking towards the origin from positive x.

2. The additional rotation can be represented by this matrix:

      (  1        0            0      )
      (                               )
      (  0   + cos(phi)   + sin(phi)  )
      (                               )
      (  0   - sin(phi)   + cos(phi)  )

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauRx(double phi, double r[3][3])
function iauRx(phi::Real, r::AbstractMatrix{<:Real})

   # Transpose matrix upfront
   r = Array{Float64, 2}(r') # Transpose input up front

   ccall((:iauRx, libsofa_c), Cvoid,
           (Cdouble, Ptr{Cdouble}),
           phi, pointer(r))

   return convert(Array{Float64, 2}, r')
end