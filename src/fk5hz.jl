export iauFk5hz
"""
Transform an FK5 (J2000.0) star position into the system of the
Hipparcos catalogue, assuming zero Hipparcos proper motion.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   r5           double   FK5 RA (radians), equinox J2000.0, at date
   d5           double   FK5 Dec (radians), equinox J2000.0, at date
   date1,date2  double   TDB date (Notes 1,2)

Returned:
   rh           double   Hipparcos RA (radians)
   dh           double   Hipparcos Dec (radians)

Notes:

1. This function converts a star position from the FK5 system to
   the Hipparcos system, in such a way that the Hipparcos proper
   motion is zero.  Because such a star has, in general, a non-zero
   proper motion in the FK5 system, the function requires the date
   at which the position in the FK5 system was determined.

2. The TT date date1+date2 is a Julian Date, apportioned in any
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

3. The FK5 to Hipparcos transformation is modeled as a pure
   rotation and spin;  zonal errors in the FK5 catalogue are not
   taken into account.

4. The position returned by this function is in the Hipparcos
   reference system but at date date1+date2.

5. See also iauFk52h, iauH2fk5, iauHfk5z.

Called:
   iauS2c       spherical coordinates to unit vector
   iauFk5hip    FK5 to Hipparcos rotation and spin
   iauSxp       multiply p-vector by scalar
   iauRv2m      r-vector to r-matrix
   iauTrxp      product of transpose of r-matrix and p-vector
   iauPxp       vector product of two p-vectors
   iauC2s       p-vector to spherical
   iauAnp       normalize angle into range 0 to 2pi

Reference:

   F.Mignard & M.Froeschle, 2000, Astron.Astrophys. 354, 732-739.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauFk5hz(double r5, double d5, double date1, double date2,
#               double *rh, double *dh)

function iauFk5hz(r5::Real, d5::Real, date1::Real, date2::Real)
   ref_rh = Ref{Float64}(0.0)
   ref_dh = Ref{Float64}(0.0)

   ccall((:iauFk5hz, libsofa_c), Cvoid, 
         (Cdouble, Cdouble, Cdouble, Cdouble,
         Ref{Cdouble}, Ref{Cdouble}), 
          convert(Float64, r5), convert(Float64, d5),
          convert(Float64, date1), convert(Float64, date2),
          ref_rh, ref_dh)

   return ref_rh[], ref_dh[]
end