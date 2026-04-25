export iauTr
"""
Transpose an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   r        double[3][3]    r-matrix

Returned:
   rt       double[3][3]    transpose

Note:
   It is permissible for r and rt to be the same array.

Called:
   iauCr        copy r-matrix

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauTr(double r[3][3], double rt[3][3])

function iauTr(r::AbstractMatrix{<:Real})
   rt = zeros(Float64, 3, 3)

   ccall((:iauTr, libsofa_c), Cvoid,
       (Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Array{Float64, 2}, r'),
       rt)

   return SMatrix{3,3}(rt')
end