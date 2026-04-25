export iauZpv
"""
**  Zero a pv-vector.
**
**  This function is part of the International Astronomical Union's
**  SOFA (Standards Of Fundamental Astronomy) software collection.
**
**  Status:  vector/matrix support function.
**
**  Returned:
**     pv       double[2][3]      pv-vector
**
**  Called:
**     iauZp        zero p-vector
**
**  This revision:  2013 June 18
**
**  SOFA release 2018-01-30
**
**  Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauZpv(double pv[2][3])

function iauZpv()
   pv = zeros(Float64, 3, 2)

   ccall((:iauZpv, libsofa_c), Cvoid,
           (Ptr{Cdouble},),
           pv)

   # Transpose since C call return row-major operation
   return SMatrix{2,3}(pv')
end