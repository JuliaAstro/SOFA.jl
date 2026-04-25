export iauPvdpv
"""
Inner (=scalar=dot) product of two pv-vectors.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   a        double[2][3]      first pv-vector
   b        double[2][3]      second pv-vector

Returned:
   adb      double[2]         a . b (see note)

Note:

   If the position and velocity components of the two pv-vectors are
   ( ap, av ) and ( bp, bv ), the result, a . b, is the pair of
   numbers ( ap . bp , ap . bv + av . bp ).  The two numbers are the
   dot-product of the two p-vectors and its derivative.

Called:
   iauPdp       scalar product of two p-vectors

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPvdpv(double a[2][3], double b[2][3], double adb[2])
function iauPvdpv(a::AbstractMatrix{<:Real}, b::AbstractMatrix{<:Real})
   # Preallocate return values
   adb = zeros(Float64, 2)

   ccall((:iauPvdpv, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          convert(Array{Float64, 2}, a'),
          convert(Array{Float64, 2}, b'),
          adb)

   return SVector{2}(adb)
end