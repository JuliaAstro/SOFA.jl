"""
Standards of Fundamental Astronomy (SOFA)

Version: 2023-10-11 (Release 19)

Pure Julia implementation of the IAU SOFA library, migrated from the
`Astrometry.SOFA` submodule of
[Astrometry.jl](https://github.com/JuliaAstro/Astrometry.jl).
"""
module SOFA

#   Astronomy: Calenders
export cal2jd, epb, epb2jd, epj, epj2jd, jd2cal, jdcalf
#   Astronomy: Astrometry
export ab, apcg, apcg13, apci, apci13, apco, apco13, apcs, apcs13, aper, aper13,
    apio, apio13, atcc13, atccq, atci13, atciq, atciqn, atciqz, atco13, atic13,
    aticq, aticqn, atio13, atioq, atoc13, atoi13, atoiq, ld, ldn, ldsun, pmpx,
    pmsafe, pvtob, refco
#   Astronomy: Ephemerides
export epv00, moon98, plan94
#   Astronomy: Fundamental Constants
export fad03, fae03, faf03, faju03, fal03, falp03, fama03, fame03, fane03,
    faom03, fapa03, fasa03, faur03, fave03
#   Astronomy: Precession-Nutation-Polar Motion
export bi00, bp00, bp06, bpn2xy, c2i00a, c2i00b, c2i06a, c2ibpn, c2ixy, c2ixys,
    c2t00a, c2t00b, c2t06a, c2tcio, c2teqx, c2tpe, c2txy, eo06a, eors, fw2m, fw2xy,
    ltp, ltpb, ltpecl, ltpequ, num00a, num00b, num06a, nut00a, nut00b, nut06a, nut80,
    nutm80, obl06, obl80, p06e, pb06, pfw06, pmat00, pmat06, pmat76, pn00, pn00a,
    pn00b, pn06, pn06a, pnm00a, pnm00b, pnm06a, pnm80, pom00, pr00, prec76, s00,
    s00a, s00b, s06, s06a, sp00, xy06, xys00a, xys00b, xys06a
#   Astronomy: Rotation and Time
export ee00, ee00a, ee00b, ee06a, eect00, eqeq94, era00, gmst00, gmst06, gmst82,
    gst00a, gst00b, gst06, gst06a, gst94
#   Astronomy: Space Motion
export pvstar, starpv
#   Astronomy: Star Catalogs
export fk425, fk45z, fk524, fk52h, fk54z, fk5hip, fk5hz, h2fk5, hfk5z, starpm
#   Astronomy: Ecliptic Coordinates
export eceq06, ecm06, eqec06, lteceq, ltecm, lteqec
#   Astronomy: Galactic Coordinates
export g2icrs, icrs2g
#   Astronomy: Geodetic-Geocentric Coordinates
export eform, gc2gd, gc2gde, gd2gc, gd2gce
#   Astronomy: Timescales
export d2dtf, dat, dtdb, dtf2d, taitt, taiut1, taiutc, tcbtdb, tcgtt, tdbtcb,
    tdbtt, tttai, tttcg, tttdb, ttut1, ut1tai, ut1tt, ut1utc, utctai, utcut1
#   Astronomy: Horizontal-Equatorial
export ae2hd, hd2ae, hd2pa
#   Astronomy: Gnomonic
export tpors, tporv, tpsts, tpstv, tpxes, tpxev
#   Vector-Matrix: Angle Operations
export a2af, a2tf, af2a, anp, anpm, d2tf, tf2a, tf2d
#   Vector-Matrix: Build Rotations
export rx, ry, rz
#   Vector-Matrix: Copy-Extend-Extract
export cp, cpv, cr, p2pv, pv2p
#   Vector-Matrix: Initialization
export ir, zp, zpv, zr
#   Vector-Matrix: Matrix Operations
export rxr, tr
#   Vector-Matrix: Matrix-Vector Products
export rxp, rxpv, trxp, trxpv
#   Vector-Matrix: Roation Vectors
export rm2v, rv2m
#   Vector-Matrix: Separation Vectors and Angles
export pap, pas, sepp, seps
#   Vector-Matrix: Spherical-Cartesian
export c2s, p2s, pv2s, s2c, s2p, s2pv
#   Vector-Matrix: Vector Operations
export pdp, pm, pmp, pn, ppp, ppsp, pvdpv, pvm, pvmpv, pvppv, pvu, pvup, pvxpv,
    pxp, s2xpv, sxp, sxpv

using LinearAlgebra, StaticArrays, StaticUnivariatePolynomials

include("sofa_base.jl")

end
