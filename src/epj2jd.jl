export iauEpj2jd
"""
Julian Epoch to Julian Date.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
   epj      double    Julian Epoch (e.g. 1996.8)

Returned:
   djm0     double    MJD zero-point: always 2400000.5
   djm      double    Modified Julian Date

Note:

   The Julian Date is returned in two pieces, in the usual SOFA
   manner, which is designed to preserve time resolution.  The
   Julian Date is available as a single number by adding djm0 and
   djm.

Reference:

   Lieske, J.H., 1979, Astron.Astrophys. 73, 282.

This revision:  2013 August 7

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauEpj2jd(double epj, double *djm0, double *djm)

function iauEpj2jd(epj::Real)
   ref_djm0 = Ref{Float64}(0.0)
   ref_djm  = Ref{Float64}(0.0)

   ccall((:iauEpj2jd, libsofa_c), Cvoid,
         (Cdouble, Ref{Cdouble}, Ref{Cdouble}),
         convert(Float64, epj), ref_djm0, ref_djm)

   return ref_djm0[], ref_djm[]
end