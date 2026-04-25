export iauApcg13
"""
For a geocentric observer, prepare star-independent astrometry
parameters for transformations between ICRS and GCRS coordinates.
The caller supplies the date, and SOFA models are used to predict
the Earth ephemeris.

The parameters produced by this function are required in the
parallax, light deflection and aberration parts of the astrometric
transformation chain.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  support function.

Given:
-  date1  double     TDB as a 2-part...
-  date2  double     ...Julian Date (Note 1)

Returned:
   astrom iauASTROM* star-independent astrometry parameters:
      pmt    double       PM time interval (SSB, Julian years)
      eb     double[3]    SSB to observer (vector, au)
      eh     double[3]    Sun to observer (unit vector)
      em     double       distance from Sun to observer (au)
      v      double[3]    barycentric observer velocity (vector, c)
      bm1    double       sqrt(1-|v|^2): reciprocal of Lorenz factor
      bpn    double[3][3] bias-precession-nutation matrix
      along  double       unchanged
      xpl    double       unchanged
      ypl    double       unchanged
      sphi   double       unchanged
      cphi   double       unchanged
      diurab double       unchanged
      eral   double       unchanged
      refa   double       unchanged
      refb   double       unchanged

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
   good compromises between resolution and convenience.  For most
   applications of this function the choice will not be at all
   critical.

   TT can be used instead of TDB without any significant impact on
   accuracy.

2. All the vectors are with respect to BCRS axes.

3. In cases where the caller wishes to supply his own Earth
   ephemeris, the function iauApcg can be used instead of the present
   function.

4. This is one of several functions that inserts into the astrom
   structure star-independent parameters needed for the chain of
   astrometric transformations ICRS <-> GCRS <-> CIRS <-> observed.

   The various functions support different classes of observer and
   portions of the transformation chain:

          functions         observer        transformation

       iauApcg iauApcg13  | geocentric   |  ICRS <-> GCRS
       iauApci iauApci13  | terrestrial  |  ICRS <-> CIRS
       iauApco iauApco13  | terrestrial  |  ICRS <-> observed
       iauApcs iauApcs13  | space        |  ICRS <-> GCRS
       iauAper iauAper13  | terrestrial  |  update Earth rotation
       iauApio iauApio13  | terrestrial  |  CIRS <-> observed

   Those with names ending in "13" use contemporary SOFA models to
   compute the various ephemerides.  The others accept ephemerides
   supplied by the caller.

   The transformation from ICRS to GCRS covers space motion,
   parallax, light deflection, and aberration.  From GCRS to CIRS
   comprises frame bias and precession-nutation.  From CIRS to
   observed takes account of Earth rotation, polar motion, diurnal
   aberration and parallax (unless subsumed into the ICRS <-> GCRS
   transformation), and atmospheric refraction.

5. The context structure astrom produced by this function is used by
   iauAtciq* and iauAticq*.

   Called:
     iauEpv00     Earth position and velocity
     iauApcg      astrometry parameters, ICRS-GCRS, geocenter

This revision:   2013 October 9

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauApcg13(date1::Real, date2::Real)
   # Allocate return value
   ref_astrom = Ref{iauASTROM}(iauASTROM())

   ccall((:iauApcg13, libsofa_c), Cvoid,
           (Cdouble, Cdouble, Ref{iauASTROM}),
           convert(Float64, date1),
           convert(Float64, date2),
           ref_astrom)

   return ref_astrom[]
end
