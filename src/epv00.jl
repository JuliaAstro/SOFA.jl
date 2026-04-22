export iauEpv00
"""
Earth position and velocity, heliocentric and barycentric, with
respect to the Barycentric Celestial Reference System.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
      date1,date2  double        TDB date (Note 1)

Returned:
      pvh          double[2][3]  heliocentric Earth position/velocity
      pvb          double[2][3]  barycentric Earth position/velocity

      Returned (function value):
                  int           status: 0 = OK
                                       +1 = warning: date outside
                                                the range 1900-2100 AD

Notes:

1. The TDB date date1+date2 is a Julian Date, apportioned in any
      convenient way between the two arguments.  For example,
      JD(TDB)=2450123.7 could be expressed in any of these ways, among
      others:

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
      good compromises between resolution and convenience.  However,
      the accuracy of the result is more likely to be limited by the
      algorithm itself than the way the date has been expressed.

      n.b. TT can be used instead of TDB in most applications.

2. On return, the arrays pvh and pvb contain the following:

            pvh[0][0]  x       }
            pvh[0][1]  y       } heliocentric position, au
            pvh[0][2]  z       }

            pvh[1][0]  xdot    }
            pvh[1][1]  ydot    } heliocentric velocity, au/d
            pvh[1][2]  zdot    }

            pvb[0][0]  x       }
            pvb[0][1]  y       } barycentric position, au
            pvb[0][2]  z       }

            pvb[1][0]  xdot    }
            pvb[1][1]  ydot    } barycentric velocity, au/d
            pvb[1][2]  zdot    }

      The vectors are with respect to the Barycentric Celestial
      Reference System.  The time unit is one day in TDB.

3. The function is a SIMPLIFIED SOLUTION from the planetary theory
      VSOP2000 (X. Moisson, P. Bretagnon, 2001, Celes. Mechanics &
      Dyn. Astron., 80, 3/4, 205-213) and is an adaptation of original
      Fortran code supplied by P. Bretagnon (private comm., 2000).

4. Comparisons over the time span 1900-2100 with this simplified
      solution and the JPL DE405 ephemeris give the following results:

                                    RMS    max
            Heliocentric:
                  position error    3.7   11.2   km
                  velocity error    1.4    5.0   mm/s

            Barycentric:
                  position error    4.6   13.4   km
                  velocity error    1.4    4.9   mm/s

      Comparisons with the JPL DE406 ephemeris show that by 1800 and
      2200 the position errors are approximately double their 1900-2100
      size.  By 1500 and 2500 the deterioration is a factor of 10 and
      by 1000 and 3000 a factor of 60.  The velocity accuracy falls off
      at about half that rate.

5. It is permissible to use the same array for pvh and pvb, which
      will receive the barycentric values.

This revision:  2017 March 16

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauEpv00(double date1, double date2,
#              double pvh[2][3], double pvb[2][3])

function iauEpv00(date1::Real, date2::Real)
      # Initialize function return variables
      pvh = zeros(Float64, 3, 2)
      pvb = zeros(Float64, 3, 2)
   
      status = ccall((:iauEpv00, libsofa_c), Cint,
            (Cdouble, Cdouble,
            Ref{Cdouble}, Ref{Cdouble}),
            convert(Float64, date1), convert(Float64, date2),
            pvh, pvb)
   
      return status, SMatrix{2,3}(pvh'), SMatrix{2,3}(pvb')
   end