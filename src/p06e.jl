export iauP06e
"""
Precession angles, IAU 2006, equinox based.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  canonical models.

Given:
   date1,date2   double   TT as a 2-part Julian Date (Note 1)

Returned (see Note 2):
   eps0          double   epsilon_0
   psia          double   psi_A
   oma           double   omega_A
   bpa           double   P_A
   bqa           double   Q_A
   pia           double   pi_A
   bpia          double   Pi_A
   epsa          double   obliquity epsilon_A
   chia          double   chi_A
   za            double   z_A
   zetaa         double   zeta_A
   thetaa        double   theta_A
   pa            double   p_A
   gam           double   F-W angle gamma_J2000
   phi           double   F-W angle phi_J2000
   psi           double   F-W angle psi_J2000

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

2. This function returns the set of equinox based angles for the
   Capitaine et al. "P03" precession theory, adopted by the IAU in
   2006.  The angles are set out in Table 1 of Hilton et al. (2006):

   eps0   epsilon_0   obliquity at J2000.0
   psia   psi_A       luni-solar precession
   oma    omega_A     inclination of equator wrt J2000.0 ecliptic
   bpa    P_A         ecliptic pole x, J2000.0 ecliptic triad
   bqa    Q_A         ecliptic pole -y, J2000.0 ecliptic triad
   pia    pi_A        angle between moving and J2000.0 ecliptics
   bpia   Pi_A        longitude of ascending node of the ecliptic
   epsa   epsilon_A   obliquity of the ecliptic
   chia   chi_A       planetary precession
   za     z_A         equatorial precession: -3rd 323 Euler angle
   zetaa  zeta_A      equatorial precession: -1st 323 Euler angle
   thetaa theta_A     equatorial precession: 2nd 323 Euler angle
   pa     p_A         general precession
   gam    gamma_J2000 J2000.0 RA difference of ecliptic poles
   phi    phi_J2000   J2000.0 codeclination of ecliptic pole
   psi    psi_J2000   longitude difference of equator poles, J2000.0

   The returned values are all radians.

3. Hilton et al. (2006) Table 1 also contains angles that depend on
   models distinct from the P03 precession theory itself, namely the
   IAU 2000A frame bias and nutation.  The quoted polynomials are
   used in other SOFA functions:

   . iauXy06  contains the polynomial parts of the X and Y series.

   . iauS06  contains the polynomial part of the s+XY/2 series.

   . iauPfw06  implements the series for the Fukushima-Williams
      angles that are with respect to the GCRS pole (i.e. the variants
      that include frame bias).

4. The IAU resolution stipulated that the choice of parameterization
   was left to the user, and so an IAU compliant precession
   implementation can be constructed using various combinations of
   the angles returned by the present function.

5. The parameterization used by SOFA is the version of the Fukushima-
   Williams angles that refers directly to the GCRS pole.  These
   angles may be calculated by calling the function iauPfw06.  SOFA
   also supports the direct computation of the CIP GCRS X,Y by
   series, available by calling iauXy06.

6. The agreement between the different parameterizations is at the
   1 microarcsecond level in the present era.

   7> When constructing a precession formulation that refers to the GCRS
   pole rather than the dynamical pole, it may (depending on the
   choice of angles) be necessary to introduce the frame bias
   explicitly.

8. It is permissible to re-use the same variable in the returned
   arguments.  The quantities are stored in the stated order.

Reference:

   Hilton, J. et al., 2006, Celest.Mech.Dyn.Astron. 94, 351

Called:
   iauObl06     mean obliquity, IAU 2006

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauP06e(double date1, double date2,
#              double *eps0, double *psia, double *oma, double *bpa,
#              double *bqa, double *pia, double *bpia,
#              double *epsa, double *chia, double *za, double *zetaa,
#              double *thetaa, double *pa,
#              double *gam, double *phi, double *psi)

function iauP06e(date1::Real, date2::Real)
   ref_eps0   = Ref{Float64}(0.0)
   ref_psia   = Ref{Float64}(0.0)
   ref_oma    = Ref{Float64}(0.0)
   ref_bpa    = Ref{Float64}(0.0)
   ref_bqa    = Ref{Float64}(0.0)
   ref_pia    = Ref{Float64}(0.0)
   ref_bpia   = Ref{Float64}(0.0)
   ref_epsa   = Ref{Float64}(0.0)
   ref_chia   = Ref{Float64}(0.0)
   ref_za     = Ref{Float64}(0.0)
   ref_zetaa  = Ref{Float64}(0.0)
   ref_thetaa = Ref{Float64}(0.0)
   ref_pa     = Ref{Float64}(0.0)
   ref_gam    = Ref{Float64}(0.0)
   ref_phi    = Ref{Float64}(0.0)
   ref_psi    = Ref{Float64}(0.0)

   ccall((:iauP06e, libsofa_c), Cvoid, 
       (Cdouble, Cdouble,
       Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble},
       Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble},
       Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble},
       Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}),
       convert(Float64, date1), convert(Float64, date2),
       ref_eps0, ref_psia, ref_oma, ref_bpa, ref_bqa, ref_pia, 
       ref_bpia, ref_epsa, ref_chia, ref_za, ref_zetaa, ref_thetaa, 
       ref_pa, ref_gam, ref_phi, ref_psi)

   return ref_eps0[], ref_psia[], ref_oma[], ref_bpa[], ref_bqa[],
          ref_pia[], ref_bpia[], ref_epsa[], ref_chia[], ref_za[], 
          ref_zetaa[], ref_thetaa[], ref_pa[], ref_gam[], ref_phi[], 
          ref_psi[]
end