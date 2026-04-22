export iauEors
"""
Equation of the origins, given the classical NPB matrix and the
quantity s.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   rnpb  double[3][3]  classical nutation x precession x bias matrix
   s     double        the quantity s (the CIO locator)

Returned (function value):
         double        the equation of the origins in radians.

Notes:

1.  The equation of the origins is the distance between the true
   equinox and the celestial intermediate origin and, equivalently,
   the difference between Earth rotation angle and Greenwich
   apparent sidereal time (ERA-GST).  It comprises the precession
   (since J2000.0) in right ascension plus the equation of the
   equinoxes (including the small correction terms).

2.  The algorithm is from Wallace & Capitaine (2006).

References:

   Capitaine, N. & Wallace, P.T., 2006, Astron.Astrophys. 450, 855

   Wallace, P. & Capitaine, N., 2006, Astron.Astrophys. 459, 981

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauEors(double rnpb[3][3], double s)

function iauEors(rnbp::AbstractMatrix{<:Real}, s::Real)
   # Allocate return value
   rm = zeros(Float64, 3, 3)

   return ccall((:iauEors, libsofa_c), Cdouble, 
               (Ptr{Cdouble}, Cdouble), 
               convert(Array{Float64, 2}, rnbp'), convert(Float64, s))
end