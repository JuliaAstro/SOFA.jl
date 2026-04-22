export iauAtoiq
"""
Quick observed place to CIRS, given the star-independent astrometry
parameters.

Use of this function is appropriate when efficiency is important and
where many star positions are all to be transformed for one date.
The star-independent astrometry parameters can be obtained by
calling iauApio[13] or iauApco[13].

Status:  support function.

Given:
   type   char[]     type of coordinates: "R", "H" or "A" (Note 1)
   ob1    double     observed Az, HA or RA (radians; Az is N=0,E=90)
   ob2    double     observed ZD or Dec (radians)
   astrom iauASTROM* star-independent astrometry parameters:
      pmt    double       PM time interval (SSB, Julian years)
      eb     double[3]    SSB to observer (vector, au)
      eh     double[3]    Sun to observer (unit vector)
      em     double       distance from Sun to observer (au)
      v      double[3]    barycentric observer velocity (vector, c)
      bm1    double       sqrt(1-|v|^2): reciprocal of Lorenz factor
      bpn    double[3][3] bias-precession-nutation matrix
      along  double       longitude + s' (radians)
      xpl    double       polar motion xp wrt local meridian (radians)
      ypl    double       polar motion yp wrt local meridian (radians)
      sphi   double       sine of geodetic latitude
      cphi   double       cosine of geodetic latitude
      diurab double       magnitude of diurnal aberration vector
      eral   double       "local" Earth rotation angle (radians)
      refa   double       refraction constant A (radians)
      refb   double       refraction constant B (radians)

Returned:
   ri     double*    CIRS right ascension (CIO-based, radians)
   di     double*    CIRS declination (radians)

Notes:

1. "Observed" Az,El means the position that would be seen by a
   perfect geodetically aligned theodolite.  This is related to
   the observed HA,Dec via the standard rotation, using the geodetic
   latitude (corrected for polar motion), while the observed HA and
   RA are related simply through the Earth rotation angle and the
   site longitude.  "Observed" RA,Dec or HA,Dec thus means the
   position that would be seen by a perfect equatorial with its
   polar axis aligned to the Earth's axis of rotation.  By removing
   from the observed place the effects of atmospheric refraction and
   diurnal aberration, the CIRS RA,Dec is obtained.

2. Only the first character of the type argument is significant.
   "R" or "r" indicates that ob1 and ob2 are the observed right
   ascension and declination;  "H" or "h" indicates that they are
   hour angle (west +ve) and declination;  anything else ("A" or
   "a" is recommended) indicates that ob1 and ob2 are azimuth (north
   zero, east 90 deg) and zenith distance.  (Zenith distance is used
   rather than altitude in order to reflect the fact that no
   allowance is made for depression of the horizon.)

3. The accuracy of the result is limited by the corrections for
   refraction, which use a simple A*tan(z) + B*tan^3(z) model.
   Providing the meteorological parameters are known accurately and
   there are no gross local effects, the predicted observed
   coordinates should be within 0.05 arcsec (optical) or 1 arcsec
   (radio) for a zenith distance of less than 70 degrees, better
   than 30 arcsec (optical or radio) at 85 degrees and better than
   20 arcmin (optical) or 30 arcmin (radio) at the horizon.

   Without refraction, the complementary functions iauAtioq and
   iauAtoiq are self-consistent to better than 1 microarcsecond all
   over the celestial sphere.  With refraction included, consistency
   falls off at high zenith distances, but is still better than
   0.05 arcsec at 85 degrees.

4. It is advisable to take great care with units, as even unlikely
   values of the input parameters are accepted and processed in
   accordance with the models used.

Called:
   iauS2c       spherical coordinates to unit vector
   iauC2s       p-vector to spherical
   iauAnp       normalize angle into range 0 to 2pi

This revision:   2013 October 9

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
# void iauAtoiq(const char *type,
#               double ob1, double ob2, iauASTROM *astrom,
#               double *ri, double *di)

function iauAtoiq(type_::Char, ob1::Real, ob2::Real, astrom::iauASTROM)

   # Allocate return values
   ref_type_  = Ref{UInt8}(convert(UInt8, type_))
   ref_astrom = Ref{iauASTROM}(astrom)
   ref_ri     = Ref{Float64}(0.0)
   ref_di     = Ref{Float64}(0.0)

   ccall((:iauAtoiq, libsofa_c), Cvoid, 
       (Ref{UInt8}, Cdouble, Cdouble, Ref{iauASTROM},
       Ref{Cdouble}, Ref{Cdouble}), 
       ref_type_, convert(Float64, ob1), convert(Float64, ob2),
       ref_astrom, ref_ri, ref_di)

   return ref_ri[], ref_di[]
end