export iauLtecm
"""
ICRS equatorial to ecliptic rotation matrix, long-term.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   epj     double         Julian epoch (TT)

Returned:
   rm      double[3][3]   ICRS to ecliptic rotation matrix

Notes:

1. The matrix is in the sense

      E_ep = rm x P_ICRS,

   where P_ICRS is a vector with respect to ICRS right ascension
   and declination axes and E_ep is the same vector with respect to
   the (inertial) ecliptic and equinox of epoch epj.

2. P_ICRS is a free vector, merely a direction, typically of unit
   magnitude, and not bound to any particular spatial origin, such
   as the Earth, Sun or SSB.  No assumptions are made about whether
   it represents starlight and embodies astrometric effects such as
   parallax or aberration.  The transformation is approximately that
   between mean J2000.0 right ascension and declination and ecliptic
   longitude and latitude, with only frame bias (always less than
   25 mas) to disturb this classical picture.

3. The Vondrak et al. (2011, 2012) 400 millennia precession model
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

# void iauLtecm(double epj, double rm[3][3])
function iauLtecm(epj::Real)
   rm = zeros(Float64, 3, 3)
   ccall((:iauLtecm, libsofa_c), Cvoid,
         (Cdouble, Ref{Cdouble}),
          convert(Float64, epj),
          rm)

   return SMatrix{3,3}(rm')
end