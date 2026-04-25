export iauS2c
"""
**  Convert spherical coordinates to Cartesian.
**
**  This function is part of the International Astronomical Union's
**  SOFA (Standards Of Fundamental Astronomy) software collection.
**
**  Status:  vector/matrix support function.
**
**  Given:
**     theta    double       longitude angle (radians)
**     phi      double       latitude angle (radians)
**
**  Returned:
**     c        double[3]    direction cosines
**
**  This revision:  2013 June 18
**
**  SOFA release 2018-01-30
**
**  Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauS2c(double theta, double phi, double c[3])
function iauS2c(theta::Real, phi::Real)
    c = zeros(Float64, 3)

    ccall((:iauS2c, libsofa_c), Cvoid,
       (Cdouble, Cdouble, Ptr{Cdouble}),
       convert(Float64, theta),
       convert(Float64, phi),
       c)

   return SVector{3}(c)
end