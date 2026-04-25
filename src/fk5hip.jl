export iauFk5hip
"""
FK5 to Hipparcos rotation and spin.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Returned:
   r5h   double[3][3]  r-matrix: FK5 rotation wrt Hipparcos (Note 2)
   s5h   double[3]     r-vector: FK5 spin wrt Hipparcos (Note 3)

Notes:

1. This function models the FK5 to Hipparcos transformation as a
   pure rotation and spin;  zonal errors in the FK5 catalogue are
   not taken into account.

2. The r-matrix r5h operates in the sense:

         P_Hipparcos = r5h x P_FK5

   where P_FK5 is a p-vector in the FK5 frame, and P_Hipparcos is
   the equivalent Hipparcos p-vector.

3. The r-vector s5h represents the time derivative of the FK5 to
   Hipparcos rotation.  The units are radians per year (Julian,
   TDB).

Called:
   iauRv2m      r-vector to r-matrix

Reference:

   F.Mignard & M.Froeschle, Astron.Astrophys., 354, 732-739 (2000).

This revision:  2017 October 12

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauFk5hip(double r5h[3][3], double s5h[3])

function iauFk5hip()
   r5h = zeros(Float64, 3, 3)
   s5h = zeros(Float64, 3)

   ccall((:iauFk5hip, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}),
          r5h, s5h)

   return SMatrix{3,3}(r5h'), SVector{3}(s5h)
end