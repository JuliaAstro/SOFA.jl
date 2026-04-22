export iauEform
"""
Earth reference ellipsoids.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

Given:
   n    int         ellipsoid identifier (Note 1)

Returned:
   a    double      equatorial radius (meters, Note 2)
   f    double      flattening (Note 2)

Returned (function value):
         int         status:  0 = OK
                           -1 = illegal identifier (Note 3)

Notes:

1. The identifier n is a number that specifies the choice of
   reference ellipsoid.  The following are supported:

      n    ellipsoid

      1     WGS84
      2     GRS80
      3     WGS72

   The n value has no significance outside the SOFA software.  For
   convenience, symbols WGS84 etc. are defined in sofam.h.

2. The ellipsoid parameters are returned in the form of equatorial
   radius in meters (a) and flattening (f).  The latter is a number
   around 0.00335, i.e. around 1/298.

3. For the case where an unsupported n value is supplied, zero a and
   f are returned, as well as error status.

References:

   Department of Defense World Geodetic System 1984, National
   Imagery and Mapping Agency Technical Report 8350.2, Third
   Edition, p3-2.

   Moritz, H., Bull. Geodesique 66-2, 187 (1992).

   The Department of Defense World Geodetic System 1972, World
   Geodetic System Committee, May 1974.

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992),
   p220.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauEform ( int n, double *a, double *f )

function iauEform(n::Int)
   # Initialize return variables
   ref_a = Ref{Float64}(0.0)
   ref_f = Ref{Float64}(0.0)

   status = ccall((:iauEform, libsofa_c), Cint,
               (Cint, Ref{Float64}, Ref{Float64}),
               convert(Int32, n),
               ref_a, ref_f)

   # if status != 0
   #    @warn "iauEform return non-zero exit status: $status"
   # end

   return status, ref_a[], ref_f[]
end