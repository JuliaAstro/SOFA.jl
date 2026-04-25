export iauHfk5z
"""
Transform a Hipparcos star position into FK5 J2000.0, assuming
zero Hipparcos proper motion.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   rh            double    Hipparcos RA (radians)
   dh            double    Hipparcos Dec (radians)
   date1,date2   double    TDB date (Note 1)

Returned (all FK5, equinox J2000.0, date date1+date2):
   r5            double    RA (radians)
   d5            double    Dec (radians)
   dr5           double    FK5 RA proper motion (rad/year, Note 4)
   dd5           double    Dec proper motion (rad/year, Note 4)

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

2. The proper motion in RA is dRA/dt rather than cos(Dec)*dRA/dt.

3. The FK5 to Hipparcos transformation is modeled as a pure rotation
   and spin;  zonal errors in the FK5 catalogue are not taken into
   account.

4. It was the intention that Hipparcos should be a close
   approximation to an inertial frame, so that distant objects have
   zero proper motion;  such objects have (in general) non-zero
   proper motion in FK5, and this function returns those fictitious
   proper motions.

5. The position returned by this function is in the FK5 J2000.0
   reference system but at date date1+date2.

6. See also iauFk52h, iauH2fk5, iauFk5zhz.

Called:
   iauS2c       spherical coordinates to unit vector
   iauFk5hip    FK5 to Hipparcos rotation and spin
   iauRxp       product of r-matrix and p-vector
   iauSxp       multiply p-vector by scalar
   iauRxr       product of two r-matrices
   iauTrxp      product of transpose of r-matrix and p-vector
   iauPxp       vector product of two p-vectors
   iauPv2s      pv-vector to spherical
   iauAnp       normalize angle into range 0 to 2pi

Reference:

   F.Mignard & M.Froeschle, 2000, Astron.Astrophys. 354, 732-739.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauHfk5z(double rh, double dh, double date1, double date2,
#               double *r5, double *d5, double *dr5, double *dd5)

function iauHfk5z(rh::Real, dh::Real, date1::Real, date2::Real)
   ref_r5  = Ref{Float64}(0.0)
   ref_d5  = Ref{Float64}(0.0)
   ref_dr5 = Ref{Float64}(0.0)
   ref_dd5 = Ref{Float64}(0.0)

   ccall((:iauHfk5z, libsofa_c), Cvoid,
         (Cdouble, Cdouble, Cdouble, Cdouble,
         Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}),
          convert(Float64, rh), convert(Float64, dh),
          convert(Float64, date1), convert(Float64, date2),
          ref_r5, ref_d5, ref_dr5, ref_dd5)

   return ref_r5[], ref_d5[], ref_dr5[], ref_dd5[]
end