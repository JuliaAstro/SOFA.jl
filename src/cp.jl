export iauCp
"""
Copy a p-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   p        double[3]     p-vector to be copied

Returned:
   c        double[3]     copy

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauCp(double p[3], double c[3])

function iauCp(p::AbstractVector{<:Real})

   # Allocate return value
   c = zeros(Float64, 3)

   ccall((:iauCp, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}),
         convert(Array{Float64, 1}, p), c)

   return SVector{3}(c)
end
