export iauPv2s
"""
Convert position/velocity from Cartesian to spherical coordinates.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

Given:
    pv       double[2][3]  pv-vector

Returned:
    theta    double        longitude angle (radians)
    phi      double        latitude angle (radians)
    r        double        radial distance
    td       double        rate of change of theta
    pd       double        rate of change of phi
    rd       double        rate of change of r

Notes:

1. If the position part of pv is null, theta, phi, td and pd
    are indeterminate.  This is handled by extrapolating the
    position through unit time by using the velocity part of
    pv.  This moves the origin without changing the direction
    of the velocity component.  If the position and velocity
    components of pv are both null, zeroes are returned for all
    six results.

2. If the position is a pole, theta, td and pd are indeterminate.
    In such cases zeroes are returned for all three.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""

# void iauPv2s(double pv[2][3],
#              double *theta, double *phi, double *r,
#              double *td, double *pd, double *rd)

function iauPv2s(pv::AbstractMatrix{<:Real})
    # Preallocate return values
    ref_theta = Ref{Float64}(0.0)
    ref_phi = Ref{Float64}(0.0)
    ref_r = Ref{Float64}(0.0)
    ref_td = Ref{Float64}(0.0)
    ref_pd = Ref{Float64}(0.0)
    ref_rd = Ref{Float64}(0.0)
 
    ccall((:iauPv2s, libsofa_c), Cvoid, 
          (Ptr{Cdouble}, 
          Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble},
          Ref{Cdouble}, Ref{Cdouble}, Ref{Cdouble}), 
           convert(Array{Float64, 2}, pv'),
           ref_theta, ref_phi, ref_r, ref_td, ref_pd, ref_rd)
 
    return ref_theta[], ref_phi[], ref_r[], ref_td[], ref_pd[], ref_rd[]
 end