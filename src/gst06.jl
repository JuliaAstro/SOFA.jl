export iauGst06
"""
Greenwich apparent sidereal time, IAU 2006, given the NPB matrix.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   uta,utb  double        UT1 as a 2-part Julian Date (Notes 1,2)
   tta,ttb  double        TT as a 2-part Julian Date (Notes 1,2)
   rnpb     double[3][3]  nutation x precession x bias matrix

Returned (function value):
            double        Greenwich apparent sidereal time (radians)

Notes:

1. The UT1 and TT dates uta+utb and tta+ttb respectively, are both
   Julian Dates, apportioned in any convenient way between the
   argument pairs.  For example, JD=2450123.7 could be expressed in
   any of these ways, among others:

         Part A        Part B

      2450123.7           0.0       (JD method)
      2451545.0       -1421.3       (J2000 method)
      2400000.5       50123.2       (MJD method)
      2450123.5           0.2       (date & time method)

   The JD method is the most natural and convenient to use in
   cases where the loss of several decimal digits of resolution
   is acceptable (in the case of UT;  the TT is not at all critical
   in this respect).  The J2000 and MJD methods are good compromises
   between resolution and convenience.  For UT, the date & time
   method is best matched to the algorithm that is used by the Earth
   rotation angle function, called internally:  maximum precision is
   delivered when the uta argument is for 0hrs UT1 on the day in
   question and the utb argument lies in the range 0 to 1, or vice
   versa.

2. Both UT1 and TT are required, UT1 to predict the Earth rotation
   and TT to predict the effects of precession-nutation.  If UT1 is
   used for both purposes, errors of order 100 microarcseconds
   result.

3. Although the function uses the IAU 2006 series for s+XY/2, it is
   otherwise independent of the precession-nutation model and can in
   practice be used with any equinox-based NPB matrix.

4. The result is returned in the range 0 to 2pi.

Called:
   iauBpn2xy    extract CIP X,Y coordinates from NPB matrix
   iauS06       the CIO locator s, given X,Y, IAU 2006
   iauAnp       normalize angle into range 0 to 2pi
   iauEra00     Earth rotation angle, IAU 2000
   iauEors      equation of the origins, given NPB matrix and s

Reference:

   Wallace, P.T. & Capitaine, N., 2006, Astron.Astrophys. 459, 981

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# double iauGst06(double uta, double utb, double tta, double ttb,
#                 double rnpb[3][3])

function iauGst06(uta::Real, utb::Real, tta::Real, ttb::Real,
                   rnpb::AbstractMatrix{<:Real})

   return ccall((:iauGst06, libsofa_c), Cdouble,
               (Cdouble, Cdouble, Cdouble, Cdouble, Ptr{Cdouble}),
               convert(Float64, uta), convert(Float64, utb),
               convert(Float64, tta), convert(Float64, ttb),
               convert(Array{Float64, 2}, rnpb'))
end