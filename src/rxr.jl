export iauRxr
"""
Multiply two r-matrices.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   a        double[3][3]    first r-matrix
   b        double[3][3]    second r-matrix

Returned:
   atb      double[3][3]    a * b

Note:
   It is permissible to re-use the same array for any of the
   arguments.

Called:
   iauCr        copy r-matrix

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauRxr(double a[3][3], double b[3][3], double atb[3][3])
function iauRxr(a::AbstractMatrix{<:Real}, b::AbstractMatrix{<:Real})
   atb = zeros(Float64, 3, 3)
   ccall((:iauRxr, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
         convert(Array{Float64, 2}, a'),
         convert(Array{Float64, 2}, b'),
         atb)

   return SMatrix{3,3}(atb')
end