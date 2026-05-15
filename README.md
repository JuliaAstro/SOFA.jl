# SOFA.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliaastro.org/SOFA/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliaastro.org/SOFA.jl/dev)

[![CI](https://github.com/JuliaAstro/SOFA.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaAstro/SOFA.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/JuliaAstro/SOFA.jl/graph/badge.svg)](https://codecov.io/gh/JuliaAstro/SOFA.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Unofficial wrapper of the IAU SOFA C libraries for fundamental astronomy. See the [Astrometry.jl > SOFA](https://juliaastro.org/Astrometry/stable/SOFA/) sub-package for the pure Julia implementation.

## Description

The purpose of this package is to wrap the SOFA C library of fundamental astonomical function to make it easily accessible in Julia. This package serves as a _wrapper_ only. All functions ultimately call the original, unmodified, SOFA C library functions which are compiled as part of the package build process.

The full SOFA C test suite is reproduced as part of the package to
prove compliance and reproducibility of the core SOFA C functionality.

## Package Version <-> SOFA Release Correspondence

The package versions correspond to the following releases of the SOFA C Library:

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
2. Wrappers for _iauAtciqn_, _iauAticqn_, and _iauLdn_ do not currently work properly.

## Compliance with SOFA License

This distribution is permitted and compliant with the SOFA license. See the LICENSE for details.
