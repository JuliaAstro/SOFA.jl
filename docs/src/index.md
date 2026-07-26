# SOFA.jl

[SOFA.jl](https://github.com/JuliaAstro/SOFA.jl) is a pure Julia implementation of the International Astronomical Union's [Standards of Fundamental Astronomy (SOFA)](https://www.iausofa.org/) library: the authoritative algorithms for fundamental astronomy, covering calendars and timescales, Earth rotation, precession-nutation, astrometric transformations, ephemerides, star catalog conversions, and the supporting vector-matrix toolkit.

No compiled C library is required. Function names mirror their SOFA C counterparts with the `iau` prefix removed (e.g. [`cal2jd`](@ref) instead of `iauCal2jd`), all computed values are returned by the function call (nothing is returned by reference), and the official SOFA C test suite is reproduced in the package tests to prove compliance of the core functionality.

## Installation

SOFA.jl is registered in the Julia General registry:

```julia-repl
pkg> add SOFA
```

## Quickstart

```jldoctest
julia> using SOFA

julia> cal2jd(2026, 7, 22) # Gregorian calendar date to two-part Julian Date
(mjd0 = 2.4000005e6, mjd = 61243)

julia> dat(2026, 7, 22, 0.0) # Δ(AT) = TAI - UTC, in seconds
37.0

julia> utctai(2400000.5, 61243.0) # UTC to TAI, as a two-part Julian Date
(day = 2.4000005e6, fraction = 61243.00042824074)

julia> era00(2400000.5, 61243.0) # Earth rotation angle, in radians
5.225889183066003

julia> icrs2g(1.459672, 0.384225) # ICRS coordinates of the Crab Nebula to galactic, in radians
(lon = 3.2211352911293876, lat = -0.10095691332274818)
```

The full function reference is organized into topical pages mirroring the structure of the library. Start at the [API Reference](@ref) for an overview.

## Package version ⟷ SOFA release correspondence

Package versions correspond to the following releases of the SOFA C library. As of v2.0 the package is a pure Julia implementation; the v1.x series wrapped the compiled SOFA C library and is maintained on the [`release-1.x` branches](https://github.com/JuliaAstro/SOFA.jl/releases).

| Package version | SOFA release | Build      |
|:----------------|:-------------|:-----------|
| v2.0            | 2023-10-11   | pure Julia |
| v1.5            | 2023-10-11   | jll        |
| v1.4            | 2021-05-12   | jll        |
| v1.3            | 2021-01-25_a | jll        |
| v1.2            | 2020-07-21   | jll        |
| v1.1            | 2019-07-22   | jll        |
| v1.0            | 2019-07-22   | manual     |
| v0.1            | 2018-01-30   | manual     |

## Relationship to other packages

- [Astrometry.jl](https://github.com/JuliaAstro/Astrometry.jl): Where this implementation originated. It was developed by Dr. Paul Barrett as the `Astrometry.SOFA` submodule before being migrated to this package.
- [ERFA.jl](https://github.com/JuliaAstro/ERFA.jl): A wrapper of the ERFA C library, the liberally-licensed fork of SOFA C. SOFA.jl provides the same functionality in pure Julia and serves as a drop-in alternative.

## License and attribution

This package is derived from, but is not an official product of, the [International Astronomical Union SOFA](https://www.iausofa.org/) collection, and is not endorsed by the IAU SOFA Board. Its distribution is permitted and compliant with the SOFA license. See the [LICENSE](https://github.com/JuliaAstro/SOFA.jl/blob/main/LICENSE) for details. Please report any bugs to the [package issue tracker](https://github.com/JuliaAstro/SOFA.jl/issues), not to the SOFA Board.
