export iauTdbtcb
"""
Time scale transformation:  Barycentric Dynamical Time, TDB, to
Barycentric Coordinate Time, TCB.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

Given:
   tdb1,tdb2  double    TDB as a 2-part Julian Date

Returned:
   tcb1,tcb2  double    TCB as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Notes:

1. tdb1+tdb2 is Julian Date, apportioned in any convenient way
   between the two arguments, for example where tdb1 is the Julian
   Day Number and tdb2 is the fraction of a day.  The returned
   tcb1,tcb2 follow suit.

2. The 2006 IAU General Assembly introduced a conventional linear
   transformation between TDB and TCB.  This transformation
   compensates for the drift between TCB and terrestrial time TT,
   and keeps TDB approximately centered on TT.  Because the
   relationship between TT and TCB depends on the adopted solar
   system ephemeris, the degree of alignment between TDB and TT over
   long intervals will vary according to which ephemeris is used.
   Former definitions of TDB attempted to avoid this problem by
   stipulating that TDB and TT should differ only by periodic
   effects.  This is a good description of the nature of the
   relationship but eluded precise mathematical formulation.  The
   conventional linear relationship adopted in 2006 sidestepped
   these difficulties whilst delivering a TDB that in practice was
   consistent with values before that date.

3. TDB is essentially the same as Teph, the time argument for the
   JPL solar system ephemerides.

Reference:

   IAU 2006 Resolution B3

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# int iauTdbtcb(double tdb1, double tdb2, double *tcb1, double *tcb2)
function iauTdbtcb(tdb1::Real, tdb2::Real)
   ref_tcb1 = Ref{Float64}(0.0)
   ref_tcb2 = Ref{Float64}(0.0)

   status = ccall((:iauTdbtcb, libsofa_c), Cint,
                   (Cdouble, Cdouble, Ptr{Cdouble}, Ptr{Cdouble}),
                   convert(Float64, tdb1), convert(Float64, tdb2), ref_tcb1, ref_tcb2)

   return status, ref_tcb1[], ref_tcb2[]
end