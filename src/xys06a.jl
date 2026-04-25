export iauXys06a
"""
For a given TT date, compute the X,Y coordinates of the Celestial
Intermediate Pole and the CIO locator s, using the IAU 2006
precession and IAU 2000A nutation models.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   date1,date2  double  TT as a 2-part Julian Date (Note 1)

Returned:
   x,y          double  Celestial Intermediate Pole (Note 2)
   s            double  the CIO locator s (Note 2)

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

2. The Celestial Intermediate Pole coordinates are the x,y components
   of the unit vector in the Geocentric Celestial Reference System.

3. The CIO locator s (in radians) positions the Celestial
   Intermediate Origin on the equator of the CIP.

4. Series-based solutions for generating X and Y are also available:
   see Capitaine & Wallace (2006) and iauXy06.

Called:
   iauPnm06a    classical NPB matrix, IAU 2006/2000A
   iauBpn2xy    extract CIP X,Y coordinates from NPB matrix
   iauS06       the CIO locator s, given X,Y, IAU 2006

References:

   Capitaine, N. & Wallace, P.T., 2006, Astron.Astrophys. 450, 855

   Wallace, P.T. & Capitaine, N., 2006, Astron.Astrophys. 459, 981

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauXys06a(double date1, double date2,
#                double *x, double *y, double *s)

function iauXys06a(date1::Real, date2::Real)
   ref_x = Ref{Float64}(0.0)
   ref_y = Ref{Float64}(0.0)
   ref_s = Ref{Float64}(0.0)

   ccall((:iauXys06a, libsofa_c), Cvoid,
         (Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}),
         convert(Float64, date1), convert(Float64, date2),
         ref_x, ref_y, ref_s)

   return ref_x[], ref_y[], ref_s[]
end