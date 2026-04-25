export iauC2tcio
"""
Assemble the celestial to terrestrial matrix from CIO-based
components (the celestial-to-intermediate matrix, the Earth Rotation
Angle and the polar motion matrix).

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   rc2i     double[3][3]    celestial-to-intermediate matrix
   era      double          Earth rotation angle (radians)
   rpom     double[3][3]    polar-motion matrix

Returned:
   rc2t     double[3][3]    celestial-to-terrestrial matrix

Notes:

1. This function constructs the rotation matrix that transforms
   vectors in the celestial system into vectors in the terrestrial
   system.  It does so starting from precomputed components, namely
   the matrix which rotates from celestial coordinates to the
   intermediate frame, the Earth rotation angle and the polar motion
   matrix.  One use of the present function is when generating a
   series of celestial-to-terrestrial matrices where only the Earth
   Rotation Angle changes, avoiding the considerable overhead of
   recomputing the precession-nutation more often than necessary to
   achieve given accuracy objectives.

2. The relationship between the arguments is as follows:

      [TRS] = RPOM * R_3(ERA) * rc2i * [CRS]

            = rc2t * [CRS]

   where [CRS] is a vector in the Geocentric Celestial Reference
   System and [TRS] is a vector in the International Terrestrial
   Reference System (see IERS Conventions 2003).

Called:
   iauCr        copy r-matrix
   iauRz        rotate around Z-axis
   iauRxr       product of two r-matrices

Reference:

   McCarthy, D. D., Petit, G. (eds.), 2004, IERS Conventions (2003),
   IERS Technical Note No. 32, BKG

This revision:  2013 August 24

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
# void iauC2tcio(double rc2i[3][3], double era, double rpom[3][3],
#                double rc2t[3][3])
function iauC2tcio(rc2i::AbstractMatrix{<:Real}, era::Real, rpom::AbstractMatrix{<:Real})

   # Allocate return value
   rc2t = zeros(Float64, 3, 3)

   ccall((:iauC2tcio, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Cdouble, Ptr{Cdouble},
         Ptr{Cdouble}),
         convert(Array{Float64, 2}, rc2i'), convert(Float64, era),
         convert(Array{Float64, 2}, rpom'),
         rc2t)

   return SMatrix{3,3}(rc2t')
end