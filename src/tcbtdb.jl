export iauTcbtdb
"""
Time scale transformation:  Barycentric Coordinate Time, TCB, to
Barycentric Dynamical Time, TDB.

This function is part of the International Astronomical Union's
SOFA (Standards of Fundamental Astronomy) software collection.

Status:  canonical.

Given:
   tcb1,tcb2  double    TCB as a 2-part Julian Date

Returned:
   tdb1,tdb2  double    TDB as a 2-part Julian Date

Returned (function value):
               int       status:  0 = OK

Notes:

1. tcb1+tcb2 is Julian Date, apportioned in any convenient way
   between the two arguments, for example where tcb1 is the Julian
   Day Number and tcb2 is the fraction of a day.  The returned
   tdb1,tdb2 follow suit.

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

# int iauTcbtdb(double tcb1, double tcb2, double *tdb1, double *tdb2)

function iauTcbtdb(tcb1::Real, tcb2::Real)
   ref_tdb1 = Ref{Float64}(0.0)
   ref_tdb2 = Ref{Float64}(0.0)

   status = ccall((:iauTcbtdb, libsofa_c), Cint,
                   (Cdouble, Cdouble, Ref{Cdouble}, Ref{Cdouble}),
                   convert(Float64, tcb1), convert(Float64, tcb2), ref_tdb1, ref_tdb2)

   return status, ref_tdb1[], ref_tdb2[]
end