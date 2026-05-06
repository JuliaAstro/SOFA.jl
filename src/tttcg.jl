export iauTttcg
"""
Time scale transformation:  Terrestrial Time, TT, to Geocentric
Coordinate Time, TCG.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

### Given
   tt1,tt2    double    TT as a 2-part Julian Date

### Returned
   tcg1,tcg2  double    TCG as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Note:

   tt1+tt2 is Julian Date, apportioned in any convenient way between
   the two arguments, for example where tt1 is the Julian Day Number
   and tt2 is the fraction of a day.  The returned tcg1,tcg2 follow
   suit.

### References

   McCarthy, D. D., Petit, G. (eds.), IERS Conventions (2003),
   IERS Technical Note No. 32, BKG (2004)

   IAU 2000 Resolution B1.9

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauTttcg(tt1::Real, tt2::Real)
    ref_tcg1 = Ref{Float64}(0.0)
    ref_tcg2 = Ref{Float64}(0.0)

    status = ccall(
        (:iauTttcg, libsofa_c), Cint,
        (Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
        convert(Float64, tt1), convert(Float64, tt2), ref_tcg1, ref_tcg2
    )

    return status, ref_tcg1[], ref_tcg2[]
end
