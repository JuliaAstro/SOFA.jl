export iauPvu
"""
Update a pv-vector.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   dt       double           time interval
   pv       double[2][3]     pv-vector

Returned:
   upv      double[2][3]     p updated, v unchanged

Notes:

1. "Update" means "refer the position component of the vector
   to a new date dt time units from the existing date".

2. The time units of dt must match those of the velocity.

3. It is permissible for pv and upv to be the same array.

Called:
   iauPpsp      p-vector plus scaled p-vector
   iauCp        copy p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPvu(double dt, double pv[2][3], double upv[2][3])
function iauPvu(dt::Real, pv::AbstractMatrix{<:Real})
   # Preallocate return values
   upv = zeros(Float64, 3, 2)

   ccall((:iauPvu, libsofa_c), Cvoid,
         (Cdouble, Ptr{Cdouble}, Ref{Cdouble}),
          convert(Float64, dt),
          convert(Array{Float64, 2}, pv'),
          upv)

   return SMatrix{2,3}(upv')
end