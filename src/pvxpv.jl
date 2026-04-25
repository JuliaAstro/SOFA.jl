export iauPvxpv
"""
Outer (=vector=cross) product of two pv-vectors.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   a        double[2][3]      first pv-vector
   b        double[2][3]      second pv-vector

Returned:
   axb      double[2][3]      a x b

Notes:

1. If the position and velocity components of the two pv-vectors are
   ( ap, av ) and ( bp, bv ), the result, a x b, is the pair of
   vectors ( ap x bp, ap x bv + av x bp ).  The two vectors are the
   cross-product of the two p-vectors and its derivative.

2. It is permissible to re-use the same array for any of the
   arguments.

Called:
   iauCpv       copy pv-vector
   iauPxp       vector product of two p-vectors
   iauPpp       p-vector plus p-vector

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPvxpv(double a[2][3], double b[2][3], double axb[2][3])
function iauPvxpv(a::AbstractMatrix{<:Real}, b::AbstractMatrix{<:Real})
   # Preallocate return values
   axb = zeros(Float64, 3, 2)

   ccall((:iauPvxpv, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          convert(Array{Float64, 2}, a'),
          convert(Array{Float64, 2}, b'),
          axb)

   return SMatrix{2,3}(axb')
end