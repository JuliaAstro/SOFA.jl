__precompile__(true)
module SOFA

if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
    include("../deps/deps.jl")
else
    error("libsofa_c not properly installed. Please run Pkg.build(\"SOFA\")")
end

# Use static arrays
using StaticArrays

####################
# Header Constants #
####################

const WGS84 = 1
const GRS80 = 2
const WGS72 = 3

#########################
# Additional Structures #
#########################

export iauASTROM
"""
Star-independent astrometry parameters

Note:
    - Vectors eb, eh, em and v are all with respect to BCRS axes.
"""
mutable struct iauASTROM
    pmt::Float64                        # PM time interval (SSB, Julian years)
    eb::NTuple{3, Float64}            # SSB to observer (vector, au)
    eh::NTuple{3, Float64}            # Sun to observer (unit vector)
    em::Float64                         # distance from Sun to observer (au)
    v::NTuple{3, Float64}             # barycentric observer velocity (vector, c)
    bm1::Float64                        # sqrt(1-|v|^2): reciprocal of Lorenz factor
    bpn::NTuple{3, NTuple{3, Float64}}  # bias-precession-nutation matrix
    along::Float64                      # longitude + s' + dERA(DUT) (radians)
    phi::Float64                        # geodetic latitude (radians)
    xpl::Float64                        # polar motion xp wrt local meridian (radians)
    ypl::Float64                        # polar motion yp wrt local meridian (radians)
    sphi::Float64                       # sine of geodetic latitude
    cphi::Float64                       # cosine of geodetic latitude
    diurab::Float64                     # magnitude of diurnal aberration vector
    eral::Float64                       # "local" Earth rotation angle (radians)
    refa::Float64                       # refraction constant A (radians)
    refb::Float64                       # refraction constant B (radians)

    function iauASTROM(;pmt::Real=0.0,
               em::Real=0.0,
               bm1::Real=0.0,
               along::Real=0.0,
               phi::Real=0.0,
               xpl::Real=0.0,
               ypl::Real=0.0,
               sphi::Real=0.0,
               cphi::Real=0.0,
               diurab::Real=0.0,
               eral::Real=0.0,
               refa::Real=0.0,
               refb::Real=0.0)

        new(convert(Float64, pmt),
            (0.0, 0.0, 0.0),
            (0.0, 0.0, 0.0),
            convert(Float64, em),
            (0.0, 0.0, 0.0),
            convert(Float64, bm1),
            ((0.0, 0.0, 0.0),(0.0, 0.0, 0.0),(0.0, 0.0, 0.0)),
            convert(Float64, along),
            convert(Float64, phi),
            convert(Float64, xpl),
            convert(Float64, ypl),
            convert(Float64, sphi),
            convert(Float64, cphi),
            convert(Float64, diurab),
            convert(Float64, eral),
            convert(Float64, refa),
            convert(Float64, refb),
            )
    end
end

export iauLDBODY
"""
Body parameters for light deflection
"""
mutable struct iauLDBODY
    bm::Float64            # mass of the body (solar masses)
    dl::Float64            # deflection limiter (radians^2/2)
    pv::Array{Float64, 2}  # barycentric PV of the body (au, au/day)

    function iauLDBODY(;bm::Real=0.0, dl::Real=0.0,
                        pv=[0.0 0.0 0.0; 0.0 0.0 0.0])

        if size(pv) != (2, 3)
            error("Invalid size for rnpb. Must be a (2, 3).")
        end

        new(convert(Float64, bm), convert(Float64, dl), convert(Array{Float64, 2}, pv))
    end
end

####################
# Include Wrappers #
####################

include("a2af.jl")
include("a2tf.jl")
include("ab.jl")
include("ae2hd.jl")
include("af2a.jl")
include("anp.jl")
include("anpm.jl")
include("apcg.jl")
include("apcg13.jl")
include("apci.jl")
include("apci13.jl")
include("apco.jl")
include("apco13.jl")
include("apcs.jl")
include("apcs13.jl")
include("aper.jl")
include("aper13.jl")
include("apio.jl")
include("apio13.jl")
include("atci13.jl")
include("atciq.jl")
include("atciqn.jl")
include("atciqz.jl")
include("atco13.jl")
include("atic13.jl")
include("aticq.jl")
include("aticqn.jl")
include("atio13.jl")
include("atioq.jl")
include("atoc13.jl")
include("atoi13.jl")
include("atoiq.jl")
include("bi00.jl")
include("bp00.jl")
include("bp06.jl")
include("bpn2xy.jl")
include("c2i00a.jl")
include("c2i00b.jl")
include("c2i06a.jl")
include("c2ibpn.jl")
include("c2ixy.jl")
include("c2ixys.jl")
include("c2s.jl")
include("c2t00a.jl")
include("c2t00b.jl")
include("c2t06a.jl")
include("c2tcio.jl")
include("c2teqx.jl")
include("c2tpe.jl")
include("c2txy.jl")
include("cal2jd.jl")
include("cp.jl")
include("cpv.jl")
include("cr.jl")
include("d2dtf.jl")
include("d2tf.jl")
include("dat.jl")
include("dtdb.jl")
include("dtf2d.jl")
include("eceq06.jl")
include("ecm06.jl")
include("ee00.jl")
include("ee00a.jl")
include("ee00b.jl")
include("ee06a.jl")
include("eect00.jl")
include("eform.jl")
include("eo06a.jl")
include("eors.jl")
include("epb.jl")
include("epb2jd.jl")
include("epj.jl")
include("epj2jd.jl")
include("epv00.jl")
include("eqec06.jl")
include("eqeq94.jl")
include("era00.jl")
include("fad03.jl")
include("fae03.jl")
include("faf03.jl")
include("faju03.jl")
include("fal03.jl")
include("falp03.jl")
include("fama03.jl")
include("fame03.jl")
include("fane03.jl")
include("faom03.jl")
include("fapa03.jl")
include("fasa03.jl")
include("faur03.jl")
include("fave03.jl")
include("fk45z.jl")
include("fk52h.jl")
include("fk5hip.jl")
include("fk5hz.jl")
include("fk54z.jl")
include("fk425.jl")
include("fk524.jl")
include("fw2m.jl")
include("fw2xy.jl")
include("g2icrs.jl")
include("gc2gd.jl")
include("gc2gde.jl")
include("gd2gc.jl")
include("gd2gce.jl")
include("gmst00.jl")
include("gmst06.jl")
include("gmst82.jl")
include("gst00a.jl")
include("gst00b.jl")
include("gst06.jl")
include("gst06a.jl")
include("gst94.jl")
include("h2fk5.jl")
include("hd2ae.jl")
include("hd2pa.jl")
include("hfk5z.jl")
include("icrs2g.jl")
include("ir.jl")
include("jd2cal.jl")
include("jdcalf.jl")
include("ld.jl")
include("ldn.jl")
include("ldsun.jl")
include("lteceq.jl")
include("ltecm.jl")
include("lteqec.jl")
include("ltp.jl")
include("ltpb.jl")
include("ltpecl.jl")
include("ltpequ.jl")
include("num00a.jl")
include("num00b.jl")
include("num06a.jl")
include("numat.jl")
include("nut00a.jl")
include("nut00b.jl")
include("nut06a.jl")
include("nut80.jl")
include("nutm80.jl")
include("obl06.jl")
include("obl80.jl")
include("p06e.jl")
include("p2pv.jl")
include("p2s.jl")
include("pap.jl")
include("pas.jl")
include("pb06.jl")
include("pdp.jl")
include("pfw06.jl")
include("plan94.jl")
include("pmat00.jl")
include("pmat06.jl")
include("pmat76.jl")
include("pm.jl")
include("pmp.jl")
include("pmpx.jl")
include("pmsafe.jl")
include("pn.jl")
include("pn00.jl")
include("pn00a.jl")
include("pn00b.jl")
include("pn06a.jl")
include("pn06.jl")
include("pnm00a.jl")
include("pnm00b.jl")
include("pnm06a.jl")
include("pnm80.jl")
include("pom00.jl")
include("ppp.jl")
include("ppsp.jl")
include("pr00.jl")
include("prec76.jl")
include("pv2p.jl")
include("pv2s.jl")
include("pvdpv.jl")
include("pvm.jl")
include("pvmpv.jl")
include("pvppv.jl")
include("pvstar.jl")
include("pvtob.jl")
include("pvu.jl")
include("pvup.jl")
include("pvxpv.jl")
include("pxp.jl")
include("refco.jl")
include("rm2v.jl")
include("rv2m.jl")
include("rx.jl")
include("rxp.jl")
include("rxpv.jl")
include("rxr.jl")
include("ry.jl")
include("rz.jl")
include("s00a.jl")
include("s00b.jl")
include("s00.jl")
include("s06a.jl")
include("s06.jl")
include("s2c.jl")
include("s2p.jl")
include("s2pv.jl")
include("s2xpv.jl")
include("sepp.jl")
include("seps.jl")
include("sp00.jl")
include("starpm.jl")
include("starpv.jl")
include("sxp.jl")
include("sxpv.jl")
include("taitt.jl")
include("taiut1.jl")
include("taiutc.jl")
include("tcbtdb.jl")
include("tcgtt.jl")
include("tdbtcb.jl")
include("tdbtt.jl")
include("tf2a.jl")
include("tf2d.jl")
include("tpors.jl")
include("tporv.jl")
include("tpsts.jl")
include("tpstv.jl")
include("tpxes.jl")
include("tpxev.jl")
include("tr.jl")
include("trxp.jl")
include("trxpv.jl")
include("tttai.jl")
include("tttcg.jl")
include("tttdb.jl")
include("ttut1.jl")
include("ut1tai.jl")
include("ut1tt.jl")
include("ut1utc.jl")
include("utctai.jl")
include("utcut1.jl")
include("xy06.jl")
include("xys00a.jl")
include("xys00b.jl")
include("xys06a.jl")
include("zp.jl")
include("zpv.jl")
include("zr.jl")

end # module SOFA
