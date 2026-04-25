export iauPpp
"""
**  P-vector addition.
**
**  This function is part of the International Astronomical Union's
**  SOFA (Standards Of Fundamental Astronomy) software collection.
**
**  Status:  vector/matrix support function.
**
**  Given:
**     a        double[3]      first p-vector
**     b        double[3]      second p-vector
**
**  Returned:
**     apb      double[3]      a + b
**
**  Note:
**     It is permissible to re-use the same array for any of the
**     arguments.
**
**  This revision:  2013 June 18
**
**  SOFA release 2018-01-30
**
**  Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPpp(double a[3], double b[3], double apb[3])
function iauPpp(a::AbstractVector{<:Real}, b::AbstractVector{<:Real})
   apb = zeros(Float64, 3)
   ccall((:iauPpp, libsofa_c), Cvoid,
         (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
         convert(Array{Float64, 1}, a),
         convert(Array{Float64, 1}, b),
         apb)

   return SVector{3}(apb)
end