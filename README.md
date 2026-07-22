# SOFA.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliaastro.org/SOFA/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliaastro.org/SOFA.jl/dev)

[![CI](https://github.com/JuliaAstro/SOFA.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaAstro/SOFA.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/JuliaAstro/SOFA.jl/graph/badge.svg)](https://codecov.io/gh/JuliaAstro/SOFA.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A pure Julia implementation of the IAU SOFA library for fundamental astronomy. For the wrapper of the SOFA C library, see the v1.x releases maintained on the `release-1.x` branches.

## Description

This package provides a pure Julia implementation of the SOFA library of fundamental astronomical functions, originally developed by Paul Barrett as the `SOFA` submodule of [Astrometry.jl](https://github.com/JuliaAstro/Astrometry.jl). No compiled C library is required.

The SOFA C test suite is reproduced as part of the package to
prove compliance and reproducibility of the core SOFA functionality.

## Package Version <-> SOFA Release Correspondence

The planned package versions below correspond to the following releases of the SOFA C Library:

| Package Version | SOFA Release | build      |
| :-------------- | :----------- | :--------  |
| v2.0            | 2023-10-11   | pure Julia |
| v1.5            | 2023-10-11   | jll        |
| v1.4            | 2021-05-12   | jll        |
| v1.3            | 2021-01-25_a | jll        |
| v1.2            | 2020-07-21   | jll        |
| v1.1            | 2019-07-22   | jll        |
| v1.0            | 2019-07-22   | manual     |
| v0.1            | 2018-01-30   | manual     |

## Notes

1. All computed values are returned by the function call. No values are returned by reference.
2. As of v2.0, function names follow the SOFA names without the `iau` prefix (e.g. `cal2jd` instead of `iauCal2jd`).

## Compliance with SOFA License

This distribution is permitted and compliant with the SOFA license. See the LICENSE for details.

This package is derived from, but is not an official product of, the International
Astronomical Union SOFA collection (http://www.iausofa.org), and is not endorsed
by the IAU SOFA Board.
