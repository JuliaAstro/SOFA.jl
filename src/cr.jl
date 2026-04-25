export iauCr
"""
Copy an r-matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   r        double[3][3]    r-matrix to be copied

Returned:
   c        double[3][3]    copy

Called:
   iauCp        copy p-vector

This revision:  2016 May 19

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
# void iauCr(double r[3][3], double c[3][3])

function iauCr(r::AbstractMatrix{<:Real})

   # Allocate return value
   c = zeros(Float64, 3, 3)

   ccall((:iauCr, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}),
         convert(Array{Float64, 2}, r'), c)

   return SMatrix{3,3}(c')
end
