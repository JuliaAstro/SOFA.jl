export iauTaitt
"""
Time scale transformation:  International Atomic Time, TAI, to
Terrestrial Time, TT.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

### Given
   tai1,tai2  double    TAI as a 2-part Julian Date

### Returned
   tt1,tt2    double    TT as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Note:

   tai1+tai2 is Julian Date, apportioned in any convenient way
   between the two arguments, for example where tai1 is the Julian
   Day Number and tai2 is the fraction of a day.  The returned
   tt1,tt2 follow suit.

### References

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
   IERS Technical Note No. 32, BKG (2004)

   Explanatory Supplement to the Astronomical Almanac,
   P. Kenneth Seidelmann (ed), University Science Books (1992)

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauTaitt(tai1::Real, tai2::Real)
   ref_tt1 = Ref{Float64}(0.0)
   ref_tt2 = Ref{Float64}(0.0)

   status = ccall((:iauTaitt, libsofa_c), Cint,
                   (Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
                   convert(Float64, tai1), convert(Float64, tai2), ref_tt1, ref_tt2)

   return status, ref_tt1[], ref_tt2[]
end
