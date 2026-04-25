export iauEpb
"""
**  Julian Date to Besselian Epoch.
**
**  This function is part of the International Astronomical Union's
**  SOFA (Standards Of Fundamental Astronomy) software collection.
**
**  Status:  support function.
**
**  Given:
**     dj1,dj2    double     Julian Date (see note)
**
**  Returned (function value):
**                double     Besselian Epoch.
**
**  Note:
**
**     The Julian Date is supplied in two pieces, in the usual SOFA
**     manner, which is designed to preserve time resolution.  The
**     Julian Date is available as a single number by adding dj1 and
**     dj2.  The maximum resolution is achieved if dj1 is 2451545.0
**     (J2000.0).
**
**  Reference:
**
**     Lieske, J.H., 1979. Astron.Astrophys., 73, 282.
**
**  This revision:  2013 August 21
**
**  SOFA release 2018-01-30
**
**  Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

function iauEpb(dj1::Real, dj2::Real)
    return ccall((:iauEpb, libsofa_c), Cdouble,
                 (Cdouble, Cdouble),
                 convert(Float64, dj1), convert(Float64, dj2))
end