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

    #   An explicit inner constructor keeps Julia from generating the outer
    #   `Astrom(::T, ::SVector{3, T}, ...)`, which would reject mixed types; the
    #   outer constructors below promote instead.
    function Astrom{T}(
            pmt, eb, eh, em, v, bm1, bpn, along, phi, xpl, ypl, sphi, cphi, diurab,
            eral, refa, refb
        ) where {T <: Real}
        return new{T}(
            pmt, eb, eh, em, v, bm1, bpn, along, phi, xpl, ypl, sphi, cphi, diurab,
            eral, refa, refb
        )
    end
end

#   Common floating-point type of a mix of scalars and arrays
floattype(xs...) = float(promote_type(map(numtype, xs)...))
numtype(x::Number) = typeof(x)
numtype(x::AbstractArray) = eltype(x)

#   An array argument in floating point, so that arithmetic on it neither
#   overflows nor keeps an Integer element type.  A floating-point array, at
#   any nesting, is returned as it is, so the Float64 path costs nothing.
floatarray(x::AbstractArray{<:AbstractFloat}) = x
floatarray(x::AbstractArray{<:Real}) = float.(x)
floatarray(x::AbstractArray{<:AbstractArray{<:AbstractFloat}}) = x
floatarray(x::AbstractArray{<:AbstractArray{<:Real}}) = map(floatarray, x)

function Astrom(
        pmt, eb, eh, em, v, bm1, bpn, along, phi, xpl, ypl, sphi, cphi, diurab,
        eral, refa, refb
    )
    T = floattype(
        pmt, eb, eh, em, v, bm1, bpn, along, phi, xpl, ypl, sphi, cphi, diurab,
        eral, refa, refb
    )
    return Astrom{T}(
        pmt, eb, eh, em, v, bm1, bpn, along, phi, xpl, ypl, sphi, cphi, diurab,
        eral, refa, refb
    )
end
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
        return new{T}(bm, dl, SVector{2}(SVector{3, T}(pv[1]), SVector{3, T}(pv[2])))
    end
end

function Ldbody(bm, dl, pv)
    return Ldbody{floattype(bm, dl, pv[1], pv[2])}(bm, dl, pv)
end

#   Ephemeris series evaluation (originally Astrometry.jl src/model2000.jl)

function ephem_position(coef0, coef1, coef2, Δt)

    A0, ϕ0, ν0 = [coef0[j, :] for j in 1:3]
    A1, ϕ1, ν1 = [coef1[j, :] for j in 1:3]
    A2, ϕ2, ν2 = [coef2[j, :] for j in 1:3]

    return (
        sum(A0 .* cos.(ϕ0 .+ ν0 .* Δt)) +
            sum(A1 .* cos.(ϕ1 .+ ν1 .* Δt)) * Δt +
            sum(A2 .* cos.(ϕ2 .+ ν2 .* Δt)) * Δt^2
    )
end

function ephem_velocity(coef0, coef1, coef2, Δt)

    A0, ϕ0, ν0 = coef0[1, :], coef0[2, :], coef0[3, :]
    A1, ϕ1, ν1 = coef1[1, :], coef1[2, :], coef1[3, :]
    A2, ϕ2, ν2 = coef2[1, :], coef2[2, :], coef2[3, :]

    return (
        -sum(A0 .* ν0 .* sin.(ϕ0 .+ ν0 .* Δt)) +
            sum(A1 .* (cos.(ϕ1 .+ ν1 .* Δt) .- ν1 .* Δt .* sin.(ϕ1 .+ ν1 .* Δt))) +
            sum(
            A2 .* (
                2 .* cos.(ϕ2 .+ ν2 .* Δt) .-
                    ν2 .* Δt .* sin.(ϕ2 .+ ν2 .* Δt)
            )
        ) * Δt
    ) / DAYPERYEAR
end
