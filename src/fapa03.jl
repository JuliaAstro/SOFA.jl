export iauFapa03
"""
Fundamental argument, IERS Conventions (2003):
general accumulated precession in longitude.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  canonical model.

Given:
   t     double    TDB, Julian centuries since J2000.0 (Note 1)

Returned (function value):
         double    general precession in longitude, radians (Note 2)

Notes:

1. Though t is strictly TDB, it is usually more convenient to use
   TT, which makes no significant difference.

2. The expression used is as adopted in IERS Conventions (2003).  It
   is taken from Kinoshita & Souchay (1990) and comes originally
   from Lieske et al. (1977).

References:

   Kinoshita, H. and Souchay J. 1990, Celest.Mech. and Dyn.Astron.
   48, 187

   Lieske, J.H., Lederle, T., Fricke, W. & Morando, B. 1977,
   Astron.Astrophys. 58, 1-16

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
   IERS Technical Note No. 32, BKG (2004)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauFapa03(double t)
function iauFapa03(t::Real)
   return ccall((:iauFapa03, libsofa_c), Cdouble, (Cdouble,), convert(Float64, t))
end