export iauEqec06
"""
Transformation from ICRS equatorial coordinates to ecliptic
coordinates (mean equinox and ecliptic of date) using IAU 2006
precession model.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   date1,date2 double TT as a 2-part Julian date (Note 1)
   dr,dd       double ICRS right ascension and declination (radians)

Returned:
   dl,db       double ecliptic longitude and latitude (radians)

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

2. No assumptions are made about whether the coordinates represent
   starlight and embody astrometric effects such as parallax or
   aberration.

3. The transformation is approximately that from mean J2000.0 right
   ascension and declination to ecliptic longitude and latitude
   (mean equinox and ecliptic of date), with only frame bias (always
   less than 25 mas) to disturb this classical picture.

Called:
   iauS2c       spherical coordinates to unit vector
   iauEcm06     J2000.0 to ecliptic rotation matrix, IAU 2006
   iauRxp       product of r-matrix and p-vector
   iauC2s       unit vector to spherical coordinates
   iauAnp       normalize angle into range 0 to 2pi
   iauAnpm      normalize angle into range +/- pi

This revision:  2016 February 9

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauEqec06(double date1, double date2, double dr, double dd,
#                double *dl, double *db)\

function iauEqec06(date1::Real, date2::Real, dr::Real, dd::Real)
   # Initialize function return variables
   ref_dl = Ref{Float64}(0.0)
   ref_db = Ref{Float64}(0.0)

   ccall((:iauEqec06, libsofa_c), Cvoid,
         (Cdouble, Cdouble, Cdouble, Cdouble,
         Ref{Cdouble}, Ref{Cdouble}),
         convert(Float64, date1), convert(Float64, date2),
         convert(Float64, dr), convert(Float64, dd),
         ref_dl, ref_db)

   return ref_dl[], ref_db[]
end