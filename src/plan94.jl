export iauPlan94
"""
This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Approximate heliocentric position and velocity of a nominated major
planet:  Mercury, Venus, EMB, Mars, Jupiter, Saturn, Uranus or
Neptune (but not the Earth itself).

Given:
   date1  double       TDB date part A (Note 1)
   date2  double       TDB date part B (Note 1)
   np     int          planet (1=Mercury, 2=Venus, 3=EMB, 4=Mars,
                           5=Jupiter, 6=Saturn, 7=Uranus, 8=Neptune)

Returned (argument):
   pv     double[2][3] planet p,v (heliocentric, J2000.0, au,au/d)

Returned (function value):
         int          status: -1 = illegal NP (outside 1-8)
                                 0 = OK
                              +1 = warning: year outside 1000-3000
                              +2 = warning: failed to converge

Notes:

1. The date date1+date2 is in the TDB time scale (in practice TT can
   be used) and is a Julian Date, apportioned in any convenient way
   between the two arguments.  For example, JD(TDB)=2450123.7 could
   be expressed in any of these ways, among others:

         date1          date2

      2450123.7           0.0       (JD method)
      2451545.0       -1421.3       (J2000 method)
      2400000.5       50123.2       (MJD method)
      2450123.5           0.2       (date & time method)

   The JD method is the most natural and convenient to use in cases
   where the loss of several decimal digits of resolution is
   acceptable.  The J2000 method is best matched to the way the
   argument is handled internally and will deliver the optimum
   resolution.  The MJD method and the date & time methods are both
   good compromises between resolution and convenience.  The limited
   accuracy of the present algorithm is such that any of the methods
   is satisfactory.

2. If an np value outside the range 1-8 is supplied, an error status
   (function value -1) is returned and the pv vector set to zeroes.

3. For np=3 the result is for the Earth-Moon Barycenter.  To obtain
   the heliocentric position and velocity of the Earth, use instead
   the SOFA function iauEpv00.

4. On successful return, the array pv contains the following:

      pv[0][0]   x      }
      pv[0][1]   y      } heliocentric position, au
      pv[0][2]   z      }

      pv[1][0]   xdot   }
      pv[1][1]   ydot   } heliocentric velocity, au/d
      pv[1][2]   zdot   }

   The reference frame is equatorial and is with respect to the
   mean equator and equinox of epoch J2000.0.

5. The algorithm is due to J.L. Simon, P. Bretagnon, J. Chapront,
   M. Chapront-Touze, G. Francou and J. Laskar (Bureau des
   Longitudes, Paris, France).  From comparisons with JPL
   ephemeris DE102, they quote the following maximum errors
   over the interval 1800-2050:

                  L (arcsec)    B (arcsec)      R (km)

      Mercury          4             1             300
      Venus            5             1             800
      EMB              6             1            1000
      Mars            17             1            7700
      Jupiter         71             5           76000
      Saturn          81            13          267000
      Uranus          86             7          712000
      Neptune         11             1          253000

   Over the interval 1000-3000, they report that the accuracy is no
   worse than 1.5 times that over 1800-2050.  Outside 1000-3000 the
   accuracy declines.

   Comparisons of the present function with the JPL DE200 ephemeris
   give the following RMS errors over the interval 1960-2025:

                     position (km)     velocity (m/s)

      Mercury            334               0.437
      Venus             1060               0.855
      EMB               2010               0.815
      Mars              7690               1.98
      Jupiter          71700               7.70
      Saturn          199000              19.4
      Uranus          564000              16.4
      Neptune         158000              14.4

   Comparisons against DE200 over the interval 1800-2100 gave the
   following maximum absolute differences.  (The results using
   DE406 were essentially the same.)

                  L (arcsec)   B (arcsec)     R (km)   Rdot (m/s)

      Mercury        7            1            500       0.7
      Venus          7            1           1100       0.9
      EMB            9            1           1300       1.0
      Mars          26            1           9000       2.5
      Jupiter       78            6          82000       8.2
      Saturn        87           14         263000      24.6
      Uranus        86            7         661000      27.4
      Neptune       11            2         248000      21.4

6. The present SOFA re-implementation of the original Simon et al.
   Fortran code differs from the original in the following respects:

      *  C instead of Fortran.

      *  The date is supplied in two parts.

      *  The result is returned only in equatorial Cartesian form;
         the ecliptic longitude, latitude and radius vector are not
         returned.

      *  The result is in the J2000.0 equatorial frame, not ecliptic.

      *  More is done in-line: there are fewer calls to subroutines.

      *  Different error/warning status values are used.

      *  A different Kepler's-equation-solver is used (avoiding
         use of double precision complex).

      *  Polynomials in t are nested to minimize rounding errors.

      *  Explicit double constants are used to avoid mixed-mode
         expressions.

   None of the above changes affects the result significantly.

7. The returned status indicates the most serious condition
   encountered during execution of the function.  Illegal np is
   considered the most serious, overriding failure to converge,
   which in turn takes precedence over the remote date warning.

Called:
   iauAnp       normalize angle into range 0 to 2pi

Reference:  Simon, J.L, Bretagnon, P., Chapront, J.,
            Chapront-Touze, M., Francou, G., and Laskar, J.,
            Astron.Astrophys., 282, 663 (1994).

This revision:  2017 October 12

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauPlan94(double date1, double date2, int np, double pv[2][3])

function iauPlan94(date1::Real, date2::Real, np::Int)
    pv = zeros(Float64, 3, 2)

    status = ccall((:iauPlan94, libsofa_c), Cint,
            (Cdouble, Cdouble, Cint, Ptr{Cdouble}),
            convert(Float64, date1),
            convert(Float64, date2),
            convert(Int32, np),
            pv)

    return status, SMatrix{2,3}(pv')
end