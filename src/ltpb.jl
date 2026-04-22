export iauLtpb
"""
Long-term precession matrix, including ICRS frame bias.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   epj     double         Julian epoch (TT)

Returned:
   rpb     double[3][3]   precession-bias matrix, J2000.0 to date

Notes:

1. The matrix is in the sense

      P_date = rpb x P_ICRS,

   where P_ICRS is a vector in the Geocentric Celestial Reference
   System, and P_date is the vector with respect to the Celestial
   Intermediate Reference System at that date but with nutation
   neglected.

2. A first order frame bias formulation is used, of sub-
   microarcsecond accuracy compared with a full 3D rotation.

3. The Vondrak et al. (2011, 2012) 400 millennia precession model
   agrees with the IAU 2006 precession at J2000.0 and stays within
   100 microarcseconds during the 20th and 21st centuries.  It is
   accurate to a few arcseconds throughout the historical period,
   worsening to a few tenths of a degree at the end of the
   +/- 200,000 year time span.

References:

   Vondrak, J., Capitaine, N. and Wallace, P., 2011, New precession
   expressions, valid for long time intervals, Astron.Astrophys. 534,
   A22

   Vondrak, J., Capitaine, N. and Wallace, P., 2012, New precession
   expressions, valid for long time intervals (Corrigendum),
   Astron.Astrophys. 541, C1

This revision:  2015 December 6

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauLtpb(double epj, double rpb[3][3])
function iauLtpb(epj::Real)
   rpb = zeros(Float64, 3, 3)
   
   ccall((:iauLtpb, libsofa_c), Cvoid, 
         (Cdouble, Ref{Cdouble}), 
          convert(Float64, epj),
          rpb)

   return SMatrix{3,3}(rpb')
end