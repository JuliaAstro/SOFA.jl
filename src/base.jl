"""
    Astrom

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
"""
struct Astrom
    pmt::AbstractFloat                  # proper motion time interval (SSB, Julian years)
    eb::AbstractVector{<:Real}          # SSB to observer (vector, AU)
    eh::AbstractVector{<:Real}          # Sun to observer (vector, unit)
    em::AbstractFloat                   # distance from Sun to observer (AU)
    v::AbstractVector{<:Real}           # barycentric observer velocity (vector, c)
    bm1::AbstractFloat                  # inverse Lorenz factor, i.e., sqrt(1-v^2)
    bpn::AbstractMatrix{<:Real}         # bias-precession-nutation matrix
    along::AbstractFloat                # longitude + s' + dERA(DUT) (radians)
    phi::AbstractFloat                  # geodetic latitude (radians)
    xpl::AbstractFloat                  # polar motion xp wrt local meridian (radians)
    ypl::AbstractFloat                  # polar motion yp wrt local meridian (radians)
    sphi::AbstractFloat                 # sine of geodetic latitude
    cphi::AbstractFloat                 # cosine of geodetic latitude
    diurab::AbstractFloat               # magnitude of diurnal aberration vector
    eral::AbstractFloat                 # `local` Earth rotation angle (radians)
    refa::AbstractFloat                 # refraction constant A (radians)
    refb::AbstractFloat                 # refraction constant B (radians)
end

function Astrom()
    Astrom(0., [0., 0., 0.], [0., 0., 0.], 0., [0., 0., 0.], 0.,
           zeros(Float64,3,3), 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.)
end
function Astrom(pm, eb, eh, em, v, bm1, bpn)
    Astrom(pm, eb, eh, em, v, bm1, bpn,
           0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
end

"""
    Ldbody

Body parameters for light deflection

| Field Name | Description                                      |
|:-----------|:-------------------------------------------------|
| `bm`       | mass of the body (solar masses)                  |
| `dl`       | deflection limiter (radians^2/2)                 |
| `pv`       | barycentric PV of the body (AU, AU/day)          |
"""
struct Ldbody
    bm::AbstractFloat                   #  mass of the body (solar masses)
    dl::AbstractFloat                   #  deflection limiter (radians^2/2)
    pv::AbstractVector{<:AbstractVector{<:Real}}  #  barycentric PV of the body (AU, AU/day)
end

#   Ephemeris series evaluation (originally Astrometry.jl src/model2000.jl)

function ephem_position(coef0, coef1, coef2, Δt)

    A0, ϕ0, ν0 = [coef0[j,:] for j=1:3]
    A1, ϕ1, ν1 = [coef1[j,:] for j=1:3]
    A2, ϕ2, ν2 = [coef2[j,:] for j=1:3]

    (sum(A0 .* cos.(ϕ0 .+ ν0 .* Δt)) +
     sum(A1 .* cos.(ϕ1 .+ ν1 .* Δt))*Δt +
     sum(A2 .* cos.(ϕ2 .+ ν2 .* Δt))*Δt^2)
end

function ephem_velocity(coef0, coef1, coef2, Δt)

    A0, ϕ0, ν0 = coef0[1,:], coef0[2,:], coef0[3,:]
    A1, ϕ1, ν1 = coef1[1,:], coef1[2,:], coef1[3,:]
    A2, ϕ2, ν2 = coef2[1,:], coef2[2,:], coef2[3,:]

    (-sum(A0 .*  ν0 .* sin.(ϕ0 .+ ν0 .* Δt)) +
      sum(A1 .* (cos.(ϕ1 .+ ν1 .* Δt) .- ν1 .* Δt .* sin.(ϕ1 .+ ν1 .* Δt))) +
      sum(A2 .* (2 .* cos.(ϕ2 .+ ν2 .* Δt) .-
                 ν2 .* Δt .* sin.(ϕ2 .+ ν2 .* Δt)))*Δt)/DAYPERYEAR
end
