export iauPdp
"""
p-vector inner (=scalar=dot) product.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
   a      double[3]     first p-vector
   b      double[3]     second p-vector

Returned (function value):
         double        a . b

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauPdp(double a[3], double b[3])
function iauPdp(a::AbstractVector{<:Real}, b::AbstractVector{<:Real})
   return ccall((:iauPdp, libsofa_c), Cdouble,
       (Ptr{Cdouble}, Ptr{Cdouble}),
       convert(Array{Float64, 1}, a),
       convert(Array{Float64, 1}, b))
end