export iauLtp
"""
Long-term precession matrix.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   epj     double         Julian epoch (TT)

Returned:
   rp      double[3][3]   precession matrix, J2000.0 to date

Notes:

1. The matrix is in the sense

      P_date = rp x P_J2000,

   where P_J2000 is a vector with respect to the J2000.0 mean
   equator and equinox and P_date is the same vector with respect to
   the equator and equinox of epoch epj.

2. The Vondrak et al. (2011, 2012) 400 millennia precession model
   agrees with the IAU 2006 precession at J2000.0 and stays within
   100 microarcseconds during the 20th and 21st centuries.  It is
   accurate to a few arcseconds throughout the historical period,
   worsening to a few tenths of a degree at the end of the
   +/- 200,000 year time span.

Called:
   iauLtpequ    equator pole, long term
   iauLtpecl    ecliptic pole, long term
   iauPxp       vector product
   iauPn        normalize vector

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

# void iauLtp(double epj, double rp[3][3])
function iauLtp(epj::Real)
   rp = zeros(Float64, 3, 3)
   ccall((:iauLtp, libsofa_c), Cvoid,
         (Cdouble, Ref{Cdouble}),
          convert(Float64, epj),
          rp)

   return SMatrix{3,3}(rp')
end