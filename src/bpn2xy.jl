export iauBpn2xy
"""
Extract from the bias-precession-nutation matrix the X,Y coordinates
of the Celestial Intermediate Pole.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  support function.

Given:
    rbpn      double[3][3]  celestial-to-true matrix (Note 1)

Returned:
    x,y       double        Celestial Intermediate Pole (Note 2)

Notes:

1. The matrix rbpn transforms vectors from GCRS to true equator (and
    CIO or equinox) of date, and therefore the Celestial Intermediate
    Pole unit vector is the bottom row of the matrix.

2. The arguments x,y are components of the Celestial Intermediate
    Pole unit vector in the Geocentric Celestial Reference System.

Reference:

    "Expressions for the Celestial Intermediate Pole and Celestial
    Ephemeris Origin consistent with the IAU 2000A precession-
    nutation model", Astron.Astrophys. 400, 1145-1154
    (2003)

    n.b. The celestial ephemeris origin (CEO) was renamed "celestial
        intermediate origin" (CIO) by IAU 2006 Resolution 2.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
# void iauBpn2xy(double rbpn[3][3], double *x, double *y)

function iauBpn2xy(rbpn::AbstractMatrix{<:Real})
    # Preallocate return values
    ref_x = Ref{Float64}(0.0)
    ref_y = Ref{Float64}(0.0)

    ccall((:iauBpn2xy, libsofa_c), Cvoid, 
        (Ptr{Cdouble}, Ref{Cdouble}, Ref{Cdouble}), 
        convert(Array{Float64, 2}, rbpn'), ref_x, ref_y)

    return ref_x[], ref_y[]
end