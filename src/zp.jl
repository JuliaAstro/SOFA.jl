export iauZp
"""
**  Zero a p-vector.
**
**  This function is part of the International Astronomical Union's
**  SOFA (Standards Of Fundamental Astronomy) software collection.
**
**  Status:  vector/matrix support function.
**
**  Returned:
**     p        double[3]      p-vector
**
**  This revision:  2013 June 18
**
**  SOFA release 2018-01-30
**
**  Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauZp(double p[3])

function iauZp()
   p = zeros(Float64, 3)

   ccall((:iauZp, libsofa_c), Cvoid,
           (Ptr{Cdouble},),
           p)

   # Transpose since C call return row-major operation
   return SVector{3}(p)
end