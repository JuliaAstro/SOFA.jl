| Testing | Coverage | Documentation |
| :-----: | :------: | :-----------: |
| [![Build Status](https://travis-ci.org/sisl/SOFA.jl.svg?branch=master)](https://travis-ci.org/sisl/SOFA.jl) | [![Coverage Status](https://coveralls.io/repos/github/sisl/SOFA.jl/badge.svg?branch=master)](https://coveralls.io/github/sisl/SOFA.jl?branch=master) | [![](https://img.shields.io/badge/docs-latest-blue.svg)](https://sisl.github.io/SOFA.jl/latest) |


> [!INFO]
> As of 2026-03-27 this repo will be transferred to [JuliaAstro](github.com/orgs/juliaastro/) for renewed maintenance and support.

# SOFA.jl
Unofficial wrapper of the IAU SOFA C libraries for fundamental astronomy. 

## Description

The purpose of this package is to wrap the SOFA C library of fundamental astonomical function to make it easily accessible in Julia. This package serves as a _wrapper_ only. All functions ultimately call the original, unmodified, SOFA C library functions which are compiled as part of the package build process.

The full SOFA C test suite is reproduced as part of the package to
prove compliance and reproducibility of the core SOFA C functionality.

## Package Version <-> SOFA Release Correspondence

The package versions correspond to the following releases of the SOFA C Library:

| Package Version | SOFA Release |
| --------------- | ------------ | 
| v2.0            | 2019-07-22   |
| v1.0            | 2018-01-30   |

## Notes

1. All computed values are returned by the function call. No values are returned by reference.
2. Wrappers for _iauAtciqn_, _iauAticqn_, and _iauLdn_ do not currently work properly.

## Compliance with SOFA License

This distribution is permitted and compliant with the SOFA license. See the LICENSE for details.
