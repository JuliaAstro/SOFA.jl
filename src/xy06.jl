export iauXy06
"""
X,Y coordinates of celestial intermediate pole from series based
on IAU 2006 precession and IAU 2000A nutation.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  canonical model.

Given:
   date1,date2  double     TT as a 2-part Julian Date (Note 1)

Returned:
   x,y          double     CIP X,Y coordinates (Note 2)

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

2. The X,Y coordinates are those of the unit vector towards the
   celestial intermediate pole.  They represent the combined effects
   of frame bias, precession and nutation.

3. The fundamental arguments used are as adopted in IERS Conventions
   (2003) and are from Simon et al. (1994) and Souchay et al.
   (1999).

4. This is an alternative to the angles-based method, via the SOFA
   function iauFw2xy and as used in iauXys06a for example.  The two
   methods agree at the 1 microarcsecond level (at present), a
   negligible amount compared with the intrinsic accuracy of the
   models.  However, it would be unwise to mix the two methods
   (angles-based and series-based) in a single application.

Called:
   iauFal03     mean anomaly of the Moon
   iauFalp03    mean anomaly of the Sun
   iauFaf03     mean argument of the latitude of the Moon
   iauFad03     mean elongation of the Moon from the Sun
   iauFaom03    mean longitude of the Moon's ascending node
   iauFame03    mean longitude of Mercury
   iauFave03    mean longitude of Venus
   iauFae03     mean longitude of Earth
   iauFama03    mean longitude of Mars
   iauFaju03    mean longitude of Jupiter
   iauFasa03    mean longitude of Saturn
   iauFaur03    mean longitude of Uranus
   iauFane03    mean longitude of Neptune
   iauFapa03    general accumulated precession in longitude

References:

   Capitaine, N., Wallace, P.T. & Chapront, J., 2003,
   Astron.Astrophys., 412, 567

   Capitaine, N. & Wallace, P.T., 2006, Astron.Astrophys. 450, 855

   McCarthy, D. D., Petit, G. (eds.), 2004, IERS Conventions (2003),
   IERS Technical Note No. 32, BKG

   Simon, J.L., Bretagnon, P., Chapront, J., Chapront-Touze, M.,
   Francou, G. & Laskar, J., Astron.Astrophys., 1994, 282, 663

   Souchay, J., Loysel, B., Kinoshita, H., Folgueira, M., 1999,
   Astron.Astrophys.Supp.Ser. 135, 111

   Wallace, P.T. & Capitaine, N., 2006, Astron.Astrophys. 459, 981

This revision:  2013 August 21

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauXy06(double date1, double date2, double *x, double *y)

function iauXy06(date1::Real, date2::Real)
   ref_x = Ref{Float64}(0.0)
   ref_y = Ref{Float64}(0.0)

   ccall((:iauXy06, libsofa_c), Cvoid,
         (Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
         convert(Float64, date1), convert(Float64, date2),
         ref_x, ref_y)

   return ref_x[], ref_y[]
end