"""
    Astrom{T}

Star independent astrometry parameters

| Field Name | Description                                      |
|:-----------|:-------------------------------------------------|
| `pmt`      | proper motion time interval (SSB, Julian years)  |
| `eb`       | solar system barycenter to observer (vector, AU) |
| `eh`       | Sun to observer (vector, unit)                   |
| `em`       | distance from Sun to observer (AU)               |
| `v`        | barycentric observer velocity (vector, c)        |
| `bm1`      | inverse Lorenz factor, i.e., sqrt(1-v^2)         |
| `bpn`      | bias-precession-nutation matrix                   |
| `along`    | longitude + s' + dERA(DUT) (radians)             |
| `phi`      | geodetic latitude (radians)                      |
| `xpl`      | polar motion xp wrt local meridian (radians)     |
| `ypl`      | polar motion yp wrt local meridian (radians)     |
| `sphi`     | sine of geodetic latitude                        |
| `cphi`     | cosine of geodetic latitude                      |
| `diurab`   | magnitude of diurnal aberration vector           |
| `eral`     | "local" Earth rotation angle (radians)           |
| `refa`     | refraction constant A (radians)                  |
| `refb`     | refraction constant B (radians)                  |

All fields share the element type `T`: scalars are stored as `T`, vectors as
`SVector{3, T}` and the matrix as `SMatrix{3, 3, T}`.  `Astrom(fields...)`
takes `T` to be the promoted floating-point type of its arguments, so
parameters computed at different precisions are widened rather than truncated;
vectors and the matrix may be given as any `AbstractVector`/`AbstractMatrix`.
`Astrom()` and `Astrom{T}()` give zeroed parameters.
"""
struct Astrom{T <: Real}
    pmt::T                              # proper motion time interval (SSB, Julian years)
    eb::SVector{3, T}                   # SSB to observer (vector, AU)
    eh::SVector{3, T}                   # Sun to observer (vector, unit)
    em::T                               # distance from Sun to observer (AU)
    v::SVector{3, T}                    # barycentric observer velocity (vector, c)
    bm1::T                              # inverse Lorenz factor, i.e., sqrt(1-v^2)
    bpn::SMatrix{3, 3, T, 9}            # bias-precession-nutation matrix
    along::T                            # longitude + s' + dERA(DUT) (radians)
    phi::T                              # geodetic latitude (radians)
    xpl::T                              # polar motion xp wrt local meridian (radians)
    ypl::T                              # polar motion yp wrt local meridian (radians)
    sphi::T                             # sine of geodetic latitude
    cphi::T                             # cosine of geodetic latitude
    diurab::T                           # magnitude of diurnal aberration vector
    eral::T                             # `local` Earth rotation angle (radians)
    refa::T                             # refraction constant A (radians)
    refb::T                             # refraction constant B (radians)

    #   An explicit inner constructor stops Julia generating the outer
    #   `Astrom(::T, ::SVector{3, T}, ...)`, which would build an `Astrom{Int}`;
    #   the outer constructors below promote to floating point.  The shape of
    #   `bpn` is checked, as converting it to an SMatrix checks only its length.
    function Astrom{T}(
            pmt, eb::AbstractVector, eh::AbstractVector, em, v::AbstractVector, bm1,
            bpn::AbstractMatrix, along, phi, xpl, ypl, sphi, cphi, diurab, eral, refa, refb
        ) where {T <: Real}
        size(bpn) == (3, 3) || throw(DimensionMismatch("bpn is $(size(bpn)), not (3, 3)"))
        return new{T}(
            pmt, eb, eh, em, v, bm1, bpn, along, phi, xpl, ypl, sphi, cphi, diurab,
            eral, refa, refb
        )
    end
end

#   Common floating-point type of a mix of scalars and arrays
floattype(xs...) = float(promote_type(map(eltype, xs)...))

#   Real arguments in one floating-point type, no narrower than the Float64 of
#   the constants, so that the parts of a two-part date share their type.
#   (Promoting first converts a Rational straight to a wider type.)
floatargs(xs::Real...) = Base.front(map(float, promote(xs..., 0.0)))

Astrom(f::Vararg{Any, 17}) = Astrom{floattype(f...)}(f...)
function Astrom(pm, eb, eh, em, v, bm1, bpn)
    z = zero(floattype(pm, eb, eh, em, v, bm1, bpn))
    return Astrom(pm, eb, eh, em, v, bm1, bpn, z, z, z, z, z, z, z, z, z, z)
end
function Astrom{T}() where {T <: Real}
    z, zv = zero(T), zeros(SVector{3, T})
    return Astrom{T}(z, zv, zv, z, zv, z, zeros(SMatrix{3, 3, T, 9}), z, z, z, z, z, z, z, z, z, z)
end
Astrom() = Astrom{Float64}()

"""
    Ldbody{T}

Body parameters for light deflection

| Field Name | Description                                      |
|:-----------|:-------------------------------------------------|
| `bm`       | mass of the body (solar masses)                  |
| `dl`       | deflection limiter (radians^2/2)                 |
| `pv`       | barycentric PV of the body (AU, AU/day)          |

`Ldbody(bm, dl, pv)` takes `T` to be the promoted floating-point type of its
arguments.  `pv` is given as a position and a velocity vector, e.g.
`[[x, y, z], [vx, vy, vz]]`, and stored as `SVector{2, SVector{3, T}}`.
"""
struct Ldbody{T <: Real}
    bm::T                               #  mass of the body (solar masses)
    dl::T                               #  deflection limiter (radians^2/2)
    pv::SVector{2, SVector{3, T}}       #  barycentric PV of the body (AU, AU/day)

    function Ldbody{T}(bm, dl, pv) where {T <: Real}
        return new{T}(bm, dl, SVector{2, SVector{3, T}}(pv))
    end
end

function Ldbody(bm, dl, pv)
    return Ldbody{floattype(bm, dl, pv[1], pv[2])}(bm, dl, pv)
end

#   Ephemeris series evaluation (originally Astrometry.jl src/model2000.jl)

#   Σ A cos θ and Σ A ν sin θ over the terms (A, ϕ, ν) of one coefficient
#   table, with θ = ϕ + νt.  A column of the table is one term.
@inline function ephem_sums(coef, Δt)
    P = Q = zero(promote_type(eltype(coef), typeof(Δt)))
    for k in axes(coef, 2)
        A, ϕ, ν = view(coef, :, k)
        s, c = sincos(ϕ + ν * Δt)
        P += A * c
        Q += A * ν * s
    end
    return P, Q
end

#   Position P0 + P1 t + P2 t² of a component and its time derivative, from
#   the sums over its three coefficient tables.
function ephem_pv(coef0, coef1, coef2, Δt)
    P0, Q0 = ephem_sums(coef0, Δt)
    P1, Q1 = ephem_sums(coef1, Δt)
    P2, Q2 = ephem_sums(coef2, Δt)
    p = P0 + P1 * Δt + P2 * Δt^2
    v = (-Q0 + (P1 - Q1 * Δt) + (2 * P2 - Q2 * Δt) * Δt) / DAYPERYEAR
    return p, v
end
