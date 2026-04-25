export iauLdsun
"""
Deflection of starlight by the Sun.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   p      double[3]  direction from observer to star (unit vector)
   e      double[3]  direction from Sun to observer (unit vector)
   em     double     distance from Sun to observer (au)

Returned:
   p1     double[3]  observer to deflected star (unit vector)

Notes:

1. The source is presumed to be sufficiently distant that its
   directions seen from the Sun and the observer are essentially
   the same.

2. The deflection is restrained when the angle between the star and
   the center of the Sun is less than a threshold value, falling to
   zero deflection for zero separation.  The chosen threshold value
   is within the solar limb for all solar-system applications, and
   is about 5 arcminutes for the case of a terrestrial observer.

3. The arguments p and p1 can be the same array.

Called:
   iauLd        light deflection by a solar-system body

This revision:   2016 June 16

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauLdsun(double p[3], double e[3], double em, double p1[3])
function iauLdsun(p::AbstractVector{<:Real}, e::AbstractVector{<:Real}, em::Real)
   # Allocate return values
   p1 = zeros(Float64, 3)

   ccall((:iauLdsun, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}, Cdouble, Ptr{Cdouble}),
        convert(Array{Float64, 1}, p), convert(Array{Float64, 1}, e), convert(Float64, em), p1)

   return SVector{3}(p1)
end