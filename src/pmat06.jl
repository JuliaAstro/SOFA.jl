export iauPmat06
"""
Precession matrix (including frame bias) from GCRS to a specified
date, IAU 2006 model.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   date1,date2  double          TT as a 2-part Julian Date (Note 1)

Returned:
   rbp          double[3][3]    bias-precession matrix (Note 2)

Notes:

1. The TT date date1+date2 is a Julian Date, apportioned in any
   convenient way between the two arguments.  For example,
   JD(TT)=2450123.7 could be expressed in any of these ways,
   among others:

         date1          date2

      2450123.7           0.0       (JD method)
      2451545.0       -1421.3       (J2000 method)
      2400000.5       50123.2       (MJD method)
      2450123.5           0.2       (date & time method)

   The JD method is the most natural and convenient to use in
   cases where the loss of several decimal digits of resolution
   is acceptable.  The J2000 method is best matched to the way
   the argument is handled internally and will deliver the
   optimum resolution.  The MJD method and the date & time methods
   are both good compromises between resolution and convenience.

2. The matrix operates in the sense V(date) = rbp * V(GCRS), where
   the p-vector V(GCRS) is with respect to the Geocentric Celestial
   Reference System (IAU, 2000) and the p-vector V(date) is with
   respect to the mean equatorial triad of the given date.

Called:
   iauPfw06     bias-precession F-W angles, IAU 2006
   iauFw2m      F-W angles to r-matrix

References:

   Capitaine, N. & Wallace, P.T., 2006, Astron.Astrophys. 450, 855

   Wallace, P.T. & Capitaine, N., 2006, Astron.Astrophys. 459, 981

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPmat06(double date1, double date2, double rbp[3][3])
function iauPmat06(date1::Real, date2::Real)
   rbp = zeros(Float64, 3, 3)

   ccall((:iauPmat06, libsofa_c), Cvoid,
       (Cdouble, Cdouble, Ptr{Cdouble}),
       convert(Float64, date1),
       convert(Float64, date2),
       rbp)

   return SMatrix{3,3}(rbp')
end