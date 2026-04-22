export iauPn06
"""
Precession-nutation, IAU 2006 model:  a multi-purpose function,
supporting classical (equinox-based) use directly and CIO-based use
indirectly.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   date1,date2  double          TT as a 2-part Julian Date (Note 1)
   dpsi,deps    double          nutation (Note 2)

Returned:
   epsa         double          mean obliquity (Note 3)
   rb           double[3][3]    frame bias matrix (Note 4)
   rp           double[3][3]    precession matrix (Note 5)
   rbp          double[3][3]    bias-precession matrix (Note 6)
   rn           double[3][3]    nutation matrix (Note 7)
   rbpn         double[3][3]    GCRS-to-true matrix (Note 8)

Notes:

1.  The TT date date1+date2 is a Julian Date, apportioned in any
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

2.  The caller is responsible for providing the nutation components;
   they are in longitude and obliquity, in radians and are with
   respect to the equinox and ecliptic of date.  For high-accuracy
   applications, free core nutation should be included as well as
   any other relevant corrections to the position of the CIP.

3.  The returned mean obliquity is consistent with the IAU 2006
   precession.

4.  The matrix rb transforms vectors from GCRS to J2000.0 mean
   equator and equinox by applying frame bias.

5.  The matrix rp transforms vectors from J2000.0 mean equator and
   equinox to mean equator and equinox of date by applying
   precession.

6.  The matrix rbp transforms vectors from GCRS to mean equator and
   equinox of date by applying frame bias then precession.  It is
   the product rp x rb.

7.  The matrix rn transforms vectors from mean equator and equinox
   of date to true equator and equinox of date by applying the
   nutation (luni-solar + planetary).

8.  The matrix rbpn transforms vectors from GCRS to true equator and
   equinox of date.  It is the product rn x rbp, applying frame
   bias, precession and nutation in that order.

9.  The X,Y,Z coordinates of the Celestial Intermediate Pole are
   elements (3,1-3) of the GCRS-to-true matrix, i.e. rbpn[2][0-2].

   10. It is permissible to re-use the same array in the returned
   arguments.  The arrays are filled in the stated order.

Called:
   iauPfw06     bias-precession F-W angles, IAU 2006
   iauFw2m      F-W angles to r-matrix
   iauCr        copy r-matrix
   iauTr        transpose r-matrix
   iauRxr       product of two r-matrices

References:

   Capitaine, N. & Wallace, P.T., 2006, Astron.Astrophys. 450, 855

   Wallace, P.T. & Capitaine, N., 2006, Astron.Astrophys. 459, 981

This revision:  2013 November 14

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPn06(double date1, double date2, double dpsi, double deps,
#              double *epsa,
#              double rb[3][3], double rp[3][3], double rbp[3][3],
#              double rn[3][3], double rbpn[3][3])

function iauPn06(date1::Real, date2::Real, dpsi::Real, deps::Real)
   # Allocate return values
   ref_epsa = Ref{Float64}(0.0)
   rb       = zeros(Float64, 3, 3)
   rp       = zeros(Float64, 3, 3)
   rbp      = zeros(Float64, 3, 3)
   rn       = zeros(Float64, 3, 3)
   rbpn     = zeros(Float64, 3, 3)

   ccall((:iauPn06, libsofa_c), Cvoid, 
        (Cdouble, Cdouble, Cdouble, Cdouble,
         Ref{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble},
         Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
         convert(Float64, date1),
         convert(Float64, date2),
         convert(Float64, dpsi),
         convert(Float64, deps),
         ref_epsa, rb, rp, rbp, rn, rbpn)

   return ref_epsa[], SMatrix{3,3}(rb'), SMatrix{3,3}(rp'),
      SMatrix{3,3}(rbp'), SMatrix{3,3}(rn'), SMatrix{3,3}(rbpn')
end