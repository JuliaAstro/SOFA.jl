export iauNut06a
"""
IAU 2000A nutation with adjustments to match the IAU 2006
precession.

Given:
   date1,date2   double   TT as a 2-part Julian Date (Note 1)

Returned:
   dpsi,deps     double   nutation, luni-solar + planetary (Note 2)

Status:  canonical model.

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

2. The nutation components in longitude and obliquity are in radians
   and with respect to the mean equinox and ecliptic of date,
   IAU 2006 precession model (Hilton et al. 2006, Capitaine et al.
   2005).

3. The function first computes the IAU 2000A nutation, then applies
   adjustments for (i) the consequences of the change in obliquity
   from the IAU 1980 ecliptic to the IAU 2006 ecliptic and (ii) the
   secular variation in the Earth's dynamical form factor J2.

4. The present function provides classical nutation, complementing
   the IAU 2000 frame bias and IAU 2006 precession.  It delivers a
   pole which is at current epochs accurate to a few tens of
   microarcseconds, apart from the free core nutation.

Called:
   iauNut00a    nutation, IAU 2000A

References:

   Chapront, J., Chapront-Touze, M. & Francou, G. 2002,
   Astron.Astrophys. 387, 700

   Lieske, J.H., Lederle, T., Fricke, W. & Morando, B. 1977,
   Astron.Astrophys. 58, 1-16

   Mathews, P.M., Herring, T.A., Buffet, B.A. 2002, J.Geophys.Res.
   107, B4.  The MHB_2000 code itself was obtained on 9th September
   2002 from ftp//maia.usno.navy.mil/conv2000/chapter5/IAU2000A.

   Simon, J.-L., Bretagnon, P., Chapront, J., Chapront-Touze, M.,
   Francou, G., Laskar, J. 1994, Astron.Astrophys. 282, 663-683

   Souchay, J., Loysel, B., Kinoshita, H., Folgueira, M. 1999,
   Astron.Astrophys.Supp.Ser. 135, 111

   Wallace, P.T., "Software for Implementing the IAU 2000
   Resolutions", in IERS Workshop 5.1 (2002)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauNut06a(double date1, double date2, double *dpsi, double *deps)

function iauNut06a(date1::Real, date2::Real)
   # Allocate return values
   ref_dpsi = Ref{Float64}(0.0)
   ref_deps = Ref{Float64}(0.0)

   ccall((:iauNut06a, libsofa_c), Cvoid,
        (Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
        convert(Float64, date1), convert(Float64, date2),
        ref_dpsi, ref_deps)

   return ref_dpsi[], ref_deps[]
end