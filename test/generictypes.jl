####    Generic argument types (issue #46)    ####
#
#   Real-valued arguments are annotated `Real` (counts and indices `Integer`)
#   and typed independently of each other, so that any mix of number types is
#   accepted and the results carry the promoted floating-point type.

####    Signatures of every exported function    ####

#   Does the type `t` mention `target` anywhere, including in type-variable bounds?
function mentions(t, target)
    t === target && return true
    t isa TypeVar && return mentions(t.ub, target)
    t isa UnionAll && return mentions(t.var, target) || mentions(t.body, target)
    t isa Union && return mentions(t.a, target) || mentions(t.b, target)
    t isa DataType && return any(p -> mentions(p, target), t.parameters)
    return false
end

let narrow = String[], shared = String[]
    for name in names(SOFA)
        f = getfield(SOFA, name)
        f isa Function || continue
        for m in methods(f)
            m.module === SOFA || continue
            sig, vars = m.sig, TypeVar[]
            while sig isa UnionAll
                push!(vars, sig.var)
                sig = sig.body
            end
            args = sig.parameters[2:end]
            #   `AbstractFloat` would reject Integer (and Rational, ...) arguments
            any(a -> mentions(a, AbstractFloat), args) && push!(narrow, string(m))
            #   one type variable constraining two arguments rejects mixed types
            any(v -> count(a -> mentions(a, v), args) > 1, vars) && push!(shared, string(m))
        end
    end
    @test isempty(narrow)
    @test isempty(shared)
end

####    Behaviour for a representative set of functions    ####

#   Replace the Float64s among the arguments, at any depth, by `T`
retype(T, x::Float64) = T(x)
retype(T, x::AbstractArray{Float64}) = T.(x)
retype(T, x::AbstractArray{<:AbstractArray}) = [retype(T, y) for y in x]
retype(T, x::Tuple) = map(y -> retype(T, y), x)
retype(T, x) = x

#   The numbers in a result, at any depth
leaves(x::Number) = [x]
leaves(x::NamedTuple) = leaves(values(x))
leaves(x::AbstractArray{<:Number}) = collect(vec(x))
leaves(x::Union{Tuple, AbstractArray}) = reduce(vcat, [leaves(y) for y in vec(collect(x))]; init = [])
leaves(x::SOFA.Astrom) = leaves(ntuple(i -> getfield(x, i), fieldcount(typeof(x))))
leaves(x) = []

floats(x) = [y for y in leaves(x) if y isa AbstractFloat]
agree(x, y; rtol) = all(abs.(floats(x) .- floats(y)) .<= rtol .* max.(1.0, abs.(floats(y))))

let site = (
        2456384.5, 0.969254051, 0.1550675, -0.527800806, -1.2345856,
        2738.0, 2.47230737e-7, 1.82640464e-6, 731.0, 12.8, 0.59, 0.55,
    ),
        star = (2.71, 0.174, 1.0e-5, 5.0e-6, 0.1, 55.0),
        r33 = [2.0 3.0 2.0; 3.0 2.0 3.0; 3.0 4.0 5.0],
        pv = [[-1836024.09, 1056607.72, -5998795.26], [-77.0361767, -133.310856, 0.0971855934]],
        astrom = SOFA.apci13(2456165.5, 0.401182685).astrom

    cases = [
        #   astrometry
        (SOFA.apci13, (2456165.5, 0.401182685)),
        (SOFA.apco13, site),
        (SOFA.apcs13, (2456384.5, 0.970031644, pv)),
        (SOFA.aper, (5.678, astrom)),
        (SOFA.atci13, (star..., 2456165.5, 0.401182685)),
        (SOFA.atco13, (star..., site...)),
        (SOFA.atciq, (star..., astrom)),
        (SOFA.aticq, (2.710121572969038991, 0.1729371367218230438, astrom)),
        (SOFA.atic13, (2.710121572969038991, 0.1729371367218230438, 2456165.5, 0.401182685)),
        (SOFA.atoc13, ('R', 2.710085107986886201, 0.1717653435758265198, site...)),
        (SOFA.pmsafe, (1.234, 0.789, 1.0e-5, -2.0e-5, 1.0e-2, 10.0, 2400000.5, 48348.5625, 2400000.5, 51544.5)),
        (SOFA.refco, (800.0, 10.0, 0.9, 0.4)),
        #   calendars
        (SOFA.epb, (2415019.8135, 30103.18648)),
        (SOFA.epj2jd, (1996.8,)),
        (SOFA.epb2jd, (1957.3,)),
        (SOFA.jd2cal, (2400000.5, 50123.9999)),
        (SOFA.jdcalf, (4, 2400000.5, 50123.9999)),
        #   coefficients
        (SOFA.fal03, (0.8,)),
        (SOFA.fave03, (0.8,)),
        #   ecliptic, equatorial, galactic
        (SOFA.eceq06, (2456165.5, 0.401182685, 5.1, -0.9)),
        (SOFA.lteceq, (2500.0, 1.5, 0.6)),
        (SOFA.ae2hd, (5.5, 1.1, 0.7)),
        (SOFA.hd2pa, (1.1, 1.2, 0.3)),
        (SOFA.g2icrs, (5.5850536063818546, -0.7853981633974483)),
        #   ephemerides
        (SOFA.epv00, (2400000.5, 53411.52501161)),
        (SOFA.plan94, (2400000.5, 43999.9, 1)),
        #   geocentric, gnomonic
        (SOFA.gd2gc, (:WGS84, 3.1, -0.5, 2500.0)),
        (SOFA.gc2gd, (:WGS84, [2.0e6, 3.0e6, 5.244e6])),
        (SOFA.tpors, (-0.03, 0.07, 1.3, 1.5)),
        (SOFA.tpxes, (1.3, 1.55, 2.3, 1.5)),
        #   precession
        (SOFA.nut00a, (2400000.5, 53736.0)),
        (SOFA.nut80, (2400000.5, 53736.0)),
        (SOFA.pnm06a, (2400000.5, 50123.9999)),
        (SOFA.pmat76, (2400000.5, 50123.9999)),
        (SOFA.xy06, (2400000.5, 53736.0)),
        (SOFA.xys06a, (2400000.5, 53736.0)),
        (SOFA.s06, (2400000.5, 53736.0, 0.5791308486706011e-3, 0.4020579816732961219e-4)),
        (SOFA.c2t06a, (2400000.5, 53736.0, 2400000.5, 53736.0, 2.55060238e-7, 1.860359247e-6)),
        (SOFA.c2txy, (2400000.5, 53736.0, 2400000.5, 53736.0, 0.5791308486706011e-3, 0.4020579816732961219e-4, 2.55060238e-7, 1.860359247e-6)),
        (SOFA.numat, (0.40907897633565099, -0.9630909107115582393e-5, 0.4063239174001678826e-4)),
        (SOFA.ltpequ, (-2500.0,)),
        #   rotations
        (SOFA.era00, (2400000.5, 54388.0)),
        (SOFA.gmst06, (2400000.5, 53736.0, 2400000.5, 53736.0)),
        (SOFA.gst06a, (2400000.5, 53736.0, 2400000.5, 53736.0)),
        (SOFA.ee06a, (2400000.5, 53736.0)),
        #   spacemotion, starcatalogs
        (SOFA.starpv, (0.01686756, -1.093989828, -1.78323516e-5, 2.336024047e-6, 0.74723, -21.6)),
        (SOFA.fk425, (0.07626899753879587532, -1.13740537839960578, 0.197374921784908746e-4, 0.5659714913272723189e-5, 0.134, 8.7)),
        (SOFA.fk52h, (1.76779433, -0.2917517103, -1.91851572e-7, -5.8468475e-6, 0.37921, -7.6)),
        (SOFA.starpm, (0.01686756, -1.093989828, -1.78323516e-5, 2.336024047e-6, 0.74723, -21.6, 2400000.5, 50083.0, 2400000.5, 53736.0)),
        #   timescales
        (SOFA.taitt, (2453750.5, 0.892482639)),
        (SOFA.utctai, (2453750.5, 0.892100694)),
        (SOFA.taiutc, (2453750.5, 0.892482639)),
        (SOFA.ut1utc, (2453750.5, 0.892104561, 0.3341)),
        (SOFA.utcut1, (2453750.5, 0.892100694, 0.3341)),
        (SOFA.tttdb, (2453750.5, 0.892855139, -0.000201)),
        (SOFA.d2dtf, ("UTC", 5, 2400000.5, 49533.99999)),
        (SOFA.dtf2d, ("UTC", 1994, 6, 30, 23, 59, 60.13599)),
        #   vectorops
        (SOFA.a2af, (4, 2.345)),
        (SOFA.anpm, (-4.0,)),
        (SOFA.rx, (0.3456789, r33)),
        (SOFA.rxp, (r33, [0.2, 1.5, 0.1])),
        (SOFA.pn, ([0.3, 1.2, -2.5],)),
        (SOFA.s2pv, (-3.21, 0.123, 0.456, -7.8e-6, 9.01e-6, -1.23e-5)),
        (SOFA.pvstar, (pv,)),
    ]

    for (f, args) in cases
        ref = f(args...)

        #   BigFloat throughout: every floating-point result is a BigFloat that
        #   agrees with the Float64 one
        res = f(retype(BigFloat, args)...)
        @test all(x -> x isa BigFloat, floats(res))
        @test agree(res, ref; rtol = 1.0e-11)

        #   one BigFloat argument among Float64s
        i = findfirst(x -> x isa Float64, args)
        if i !== nothing
            mixed = (args[1:(i - 1)]..., big(args[i]), args[(i + 1):end]...)
            @test agree(f(mixed...), ref; rtol = 1.0e-11)
        end

        #   a Real that is neither Float64 nor wider than the constants
        @test all(isfinite, floats(f(retype(Float32, args)...)))
    end
end

#   Integer dates give exactly what the equivalent Float64 dates give
for f in (
        SOFA.apci13, SOFA.epv00, SOFA.era00, SOFA.nut00a, SOFA.pnm06a, SOFA.xy06,
        SOFA.jd2cal, SOFA.taitt, SOFA.utctai, SOFA.epj,
    )
    @test f(2451545, 0) === f(2451545.0, 0.0)
end
@test SOFA.gmst06(2451545, 0, 2451545, 0) === SOFA.gmst06(2451545.0, 0.0, 2451545.0, 0.0)
@test SOFA.tttdb(2451545, 0, 0) === SOFA.tttdb(2451545.0, 0.0, 0.0)
@test SOFA.atci13(3, 0, 0, 0, 0, 55, 2451545, 0) === SOFA.atci13(3.0, 0.0, 0.0, 0.0, 0.0, 55.0, 2451545.0, 0.0)

#   ... including through the generated one-argument and NamedTuple forms
@test SOFA.taitt(2451545) === SOFA.taitt(2451545.0)
@test (SOFA.utctai(2451545, 0) |> SOFA.taitt |> SOFA.tttdb(0)) ===
    (SOFA.utctai(2451545.0, 0.0) |> SOFA.taitt |> SOFA.tttdb(0.0))
