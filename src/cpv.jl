export iauCpv
"""
Copy a position/velocity vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   pv     double[2][3]    position/velocity vector to be copied

Returned:
   c      double[2][3]    copy

Called:
   iauCp        copy p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauCpv(double pv[2][3], double c[2][3])

function iauCpv(pv::AbstractMatrix{<:Real})

   # Allocate return value
   c = zeros(Float64, 3, 2)

   ccall((:iauCpv, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}),
         convert(Array{Float64, 2}, pv'), c)

   return SMatrix{2,3}(c')
end
