export iauP2pv
"""
Extend a p-vector to a pv-vector by appending a zero velocity.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   p        double[3]       p-vector

Returned:
   pv       double[2][3]    pv-vector

Called:
   iauCp        copy p-vector
   iauZp        zero p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauP2pv(double p[3], double pv[2][3])
function iauP2pv(p::AbstractVector{<:Real})
   pv = zeros(Float64, 3, 2)

   ccall((:iauP2pv, libsofa_c), Cvoid,
       (Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Array{Float64, 1}, p),
       pv)

   return SMatrix{2,3}(pv')
end