export iauLd
"""
Apply light deflection by a solar-system body, as part of
transforming coordinate direction into natural direction.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   bm     double     mass of the gravitating body (solar masses)
   p      double[3]  direction from observer to source (unit vector)
   q      double[3]  direction from body to source (unit vector)
   e      double[3]  direction from body to observer (unit vector)
   em     double     distance from body to observer (au)
   dlim   double     deflection limiter (Note 4)

Returned:
   p1     double[3]  observer to deflected source (unit vector)

Notes:

1. The algorithm is based on Expr. (70) in Klioner (2003) and
   Expr. (7.63) in the Explanatory Supplement (Urban & Seidelmann
   2013), with some rearrangement to minimize the effects of machine
   precision.

2. The mass parameter bm can, as required, be adjusted in order to
   allow for such effects as quadrupole field.

3. The barycentric position of the deflecting body should ideally
   correspond to the time of closest approach of the light ray to
   the body.

4. The deflection limiter parameter dlim is phi^2/2, where phi is
   the angular separation (in radians) between source and body at
   which limiting is applied.  As phi shrinks below the chosen
   threshold, the deflection is artificially reduced, reaching zero
   for phi = 0.

5. The returned vector p1 is not normalized, but the consequential
   departure from unit magnitude is always negligible.

6. The arguments p and p1 can be the same array.

7. To accumulate total light deflection taking into account the
   contributions from several bodies, call the present function for
   each body in succession, in decreasing order of distance from the
   observer.

8. For efficiency, validation is omitted.  The supplied vectors must
   be of unit magnitude, and the deflection limiter non-zero and
   positive.

References:

   Urban, S. & Seidelmann, P. K. (eds), Explanatory Supplement to
   the Astronomical Almanac, 3rd ed., University Science Books
   (2013).

   Klioner, Sergei A., "A practical relativistic model for micro-
   arcsecond astrometry in space", Astr. J. 125, 1580-1597 (2003).

Called:
   iauPdp       scalar product of two p-vectors
   iauPxp       vector product of two p-vectors

This revision:   2013 October 9

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauLd(double bm, double p[3], double q[3], double e[3],
#            double em, double dlim, double p1[3])

function iauLd(rh::Real, p::AbstractVector{<:Real}, q::AbstractVector{<:Real},
               e::AbstractVector{<:Real}, em::Real, dlim::Real)
   p1 = zeros(Float64, 3)

   ccall((:iauLd, libsofa_c), Cvoid, 
         (Cdouble, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble},
         Cdouble, Cdouble, Ptr{Cdouble}), 
          convert(Float64, rh), convert(Array{Float64, 1}, p),
          convert(Array{Float64, 1}, q), convert(Array{Float64, 1}, e),
          convert(Float64, em), convert(Float64, dlim), p1)

   return SVector{3}(p1)
end