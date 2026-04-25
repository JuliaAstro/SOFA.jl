export iauPb06
"""
This function forms three Euler angles which implement general
precession from epoch J2000.0, using the IAU 2006 model.  Frame
bias (the offset between ICRS and mean J2000.0) is included.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   date1,date2  double   TT as a 2-part Julian Date (Note 1)

Returned:
   bzeta        double   1st rotation: radians cw around z
   bz           double   3rd rotation: radians cw around z
   btheta       double   2nd rotation: radians ccw around y

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

2. The traditional accumulated precession angles zeta_A, z_A,
   theta_A cannot be obtained in the usual way, namely through
   polynomial expressions, because of the frame bias.  The latter
   means that two of the angles undergo rapid changes near this
   date.  They are instead the results of decomposing the
   precession-bias matrix obtained by using the Fukushima-Williams
   method, which does not suffer from the problem.  The
   decomposition returns values which can be used in the
   conventional formulation and which include frame bias.

3. The three angles are returned in the conventional order, which
   is not the same as the order of the corresponding Euler
   rotations.  The precession-bias matrix is
   R_3(-z) x R_2(+theta) x R_3(-zeta).

4. Should zeta_A, z_A, theta_A angles be required that do not
   contain frame bias, they are available by calling the SOFA
   function iauP06e.

Called:
   iauPmat06    PB matrix, IAU 2006
   iauRz        rotate around Z-axis

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPb06(double date1, double date2,
#              double *bzeta, double *bz, double *btheta)

function iauPb06(date1::Real, date2::Real)
   ref_bzeta  = Ref{Float64}(0.0)
   ref_bz     = Ref{Float64}(0.0)
   ref_btheta = Ref{Float64}(0.0)

   ccall((:iauPb06, libsofa_c), Cvoid,
       (Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}),
       convert(Float64, date1),
       convert(Float64, date2),
       ref_bzeta, ref_bz, ref_btheta)

   return ref_bzeta[], ref_bz[], ref_btheta[]
end