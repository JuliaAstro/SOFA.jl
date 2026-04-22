export iauAb
"""
Apply aberration to transform natural direction into proper
direction.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   pnat    double[3]   natural direction to the source (unit vector)
   v       double[3]   observer barycentric velocity in units of c
   s       double      distance between the Sun and the observer (au)
   bm1     double      sqrt(1-|v|^2): reciprocal of Lorenz factor

Returned:
   ppr     double[3]   proper direction to source (unit vector)

Notes:

1. The algorithm is based on Expr. (7.40) in the Explanatory
   Supplement (Urban & Seidelmann 2013), but with the following
   changes:
    - Rigorous rather than approximate normalization is applied.
    - The gravitational potential term from Expr. (7) in
      Klioner (2003) is added, taking into account only the Sun's
      contribution.  This has a maximum effect of about
      0.4 microarcsecond.

2. In almost all cases, the maximum accuracy will be limited by the
   supplied velocity.  For example, if the SOFA iauEpv00 function is
   used, errors of up to 5 microarcseconds could occur.

  References:
   - Urban, S. & Seidelmann, P. K. (eds), Explanatory Supplement to
   the Astronomical Almanac, 3rd ed., University Science Books
   (2013).

   - Klioner, Sergei A., "A practical relativistic model for micro-
   arcsecond astrometry in space", Astr. J. 125, 1580-1597 (2003).

Called:
   iauPdp       scalar product of two p-vectors

This revision:   2013 October 9

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauAb(pnat::AbstractVector{<:Real}, v::AbstractVector{<:Real}, s::Real, bm1::Float64)
   ppr = zeros(Float64, 3)

   ccall((:iauAb, libsofa_c), Cvoid, 
         (Ptr{Cdouble}, Ptr{Cdouble}, Cdouble, Cdouble, Ptr{Cdouble}), 
         convert(Array{Float64, 1}, pnat),
         convert(Array{Float64, 1}, v), 
         convert(Float64, s), 
         convert(Float64, bm1), ppr)

   return SVector{3}(ppr)
end
