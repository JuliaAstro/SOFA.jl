export iauEcm06
"""
ICRS equatorial to ecliptic rotation matrix, IAU 2006.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   date1,date2  double         TT as a 2-part Julian date (Note 1)

Returned:
   rm           double[3][3]   ICRS to ecliptic rotation matrix

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

1. The matrix is in the sense

      E_ep = rm x P_ICRS,

   where P_ICRS is a vector with respect to ICRS right ascension
   and declination axes and E_ep is the same vector with respect to
   the (inertial) ecliptic and equinox of date.

2. P_ICRS is a free vector, merely a direction, typically of unit
   magnitude, and not bound to any particular spatial origin, such
   as the Earth, Sun or SSB.  No assumptions are made about whether
   it represents starlight and embodies astrometric effects such as
   parallax or aberration.  The transformation is approximately that
   between mean J2000.0 right ascension and declination and ecliptic
   longitude and latitude, with only frame bias (always less than
   25 mas) to disturb this classical picture.

Called:
   iauObl06     mean obliquity, IAU 2006
   iauPmat06    PB matrix, IAU 2006
   iauIr        initialize r-matrix to identity
   iauRx        rotate around X-axis
   iauRxr       product of two r-matrices

This revision:  2015 December 11

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauEcm06(double date1, double date2, double rm[3][3])

function iauEcm06(date1::Real, date2::Real)
   # Allocate return value
   rm = zeros(Float64, 3, 3)

   ccall((:iauEcm06, libsofa_c), Cvoid,
         (Cdouble, Cdouble,
         Ptr{Cdouble}),
         convert(Float64, date1), convert(Float64, date2),
         rm)

   return SMatrix{3,3}(rm')
end