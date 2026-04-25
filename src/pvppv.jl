export iauPvppv
"""
This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   a        double[2][3]      first pv-vector
   b        double[2][3]      second pv-vector

Returned:
   apb      double[2][3]      a + b

Note:
   It is permissible to re-use the same array for any of the
   arguments.

Called:
   iauPpp       p-vector plus p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPvppv(double a[2][3], double b[2][3], double apb[2][3])
function iauPvppv(a::AbstractMatrix{<:Real}, b::AbstractMatrix{<:Real})
   # Preallocate return values
   amb = zeros(Float64, 3, 2)

   ccall((:iauPvppv, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}, Ref{Cdouble}),
          convert(Array{Float64, 2}, a'),
          convert(Array{Float64, 2}, b'),
          amb)

   return SMatrix{2,3}(amb')
end