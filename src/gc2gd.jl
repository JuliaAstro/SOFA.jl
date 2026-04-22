export iauGc2gd
"""
Transform geocentric coordinates to geodetic using the specified
reference ellipsoid.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical transformation.

Given:
   n       int        ellipsoid identifier (Note 1)
   xyz     double[3]  geocentric vector (Note 2)

Returned:
   elong   double     longitude (radians, east +ve, Note 3)
   phi     double     latitude (geodetic, radians, Note 3)
   height  double     height above ellipsoid (geodetic, Notes 2,3)

Returned (function value):
         int         status:  0 = OK
                              -1 = illegal identifier (Note 3)
                              -2 = internal error (Note 3)

Notes:

1. The identifier n is a number that specifies the choice of
   reference ellipsoid.  The following are supported:

      n    ellipsoid

      1     WGS84
      2     GRS80
      3     WGS72

   The n value has no significance outside the SOFA software.  For
   convenience, symbols WGS84 etc. are defined in sofam.h.

2. The geocentric vector (xyz, given) and height (height, returned)
   are in meters.

3. An error status -1 means that the identifier n is illegal.  An
   error status -2 is theoretically impossible.  In all error cases,
   all three results are set to -1e9.

4. The inverse transformation is performed in the function iauGd2gc.

Called:
   iauEform     Earth reference ellipsoids
   iauGc2gde    geocentric to geodetic transformation, general

This revision:  2013 September 1

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauGc2gd( int n, double xyz[3],
#                double *elong, double *phi, double *height )

function iauGc2gd(n::Int, xyz::AbstractVector{<:Real})
   ref_elong  = Ref{Float64}(0.0)
   ref_phi    = Ref{Float64}(0.0)
   ref_height = Ref{Float64}(0.0)
   
 
   status = ccall((:iauGc2gd, libsofa_c), Cint, 
         (Cint, Ptr{Cdouble},
         Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}), 
         convert(Int32, n), xyz,
         ref_elong, ref_phi, ref_height)
 
   return status, ref_elong[], ref_phi[], ref_height[]
 end