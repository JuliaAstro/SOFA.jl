export iauTcgtt
"""
Time scale transformation:  Geocentric Coordinate Time, TCG, to
Terrestrial Time, TT.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

### Given
   tcg1,tcg2  double    TCG as a 2-part Julian Date

### Returned
   tt1,tt2    double    TT as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Note:

   tcg1+tcg2 is Julian Date, apportioned in any convenient way
   between the two arguments, for example where tcg1 is the Julian
   Day Number and tcg22 is the fraction of a day.  The returned
   tt1,tt2 follow suit.

### References

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),.
   IERS Technical Note No. 32, BKG (2004)

   IAU 2000 Resolution B1.9

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauTcgtt(tcg1::Real, tcg2::Real)
   ref_tt1 = Ref{Float64}(0.0)
   ref_tt2 = Ref{Float64}(0.0)

   status = ccall((:iauTcgtt, libsofa_c), Cint,
                   (Cdouble, Cdouble, Ptr{Cdouble}, Ptr{Cdouble}),
                   convert(Float64, tcg1), convert(Float64, tcg2), ref_tt1, ref_tt2)

   return status, ref_tt1[], ref_tt2[]
end
