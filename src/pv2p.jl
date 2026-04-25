export iauPv2p
"""
Discard velocity component of a pv-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   pv      double[2][3]     pv-vector

Returned:
   p       double[3]        p-vector

Called:
   iauCp        copy p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPv2p(double pv[2][3], double p[3])

function iauPv2p(pv::AbstractMatrix{<:Real})
   # Preallocate return values
   p = zeros(Float64, 3)

   ccall((:iauPv2p, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}),
          convert(Array{Float64, 2}, pv'), p)

   return SVector{3}(p)
end