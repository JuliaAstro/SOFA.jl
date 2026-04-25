export iauZr
"""
**  Initialize an r-matrix to the null matrix.
**
**  This function is part of the International Astronomical Union's
**  SOFA (Standards Of Fundamental Astronomy) software collection.
**
**  Status:  vector/matrix support function.
**
**  Returned:
**     r        double[3][3]    r-matrix
**
**  This revision:  2013 June 18
**
**  SOFA release 2018-01-30
**
**  Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauZr(double r[3][3])

function iauZr()
   r = zeros(Float64, 3, 3)

   ccall((:iauZr, libsofa_c), Cvoid,
           (Ptr{Cdouble},),
           r)

    # Transpose since C call return row-major operation
   return SMatrix{3,3}(r')
end