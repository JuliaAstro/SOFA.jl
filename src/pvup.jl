export iauPvup
"""
Update a pv-vector, discarding the velocity component.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   dt       double            time interval
   pv       double[2][3]      pv-vector

Returned:
   p        double[3]         p-vector

Notes:

1. "Update" means "refer the position component of the vector to a
   new date dt time units from the existing date".

2. The time units of dt must match those of the velocity.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPvup(double dt, double pv[2][3], double p[3])
function iauPvup(dt::Real, pv::AbstractMatrix{<:Real})
   # Preallocate return values
   p = zeros(Float64, 3)

   ccall((:iauPvup, libsofa_c), Cvoid, 
         (Cdouble, Ptr{Cdouble}, Ref{Cdouble}), 
          convert(Float64, dt),
          convert(Array{Float64, 2}, pv'),
          p)

   return SVector{3}(p)
end