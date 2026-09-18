# Number types and precision

The SOFA C library works in `double` throughout. SOFA.jl computes in `Float64` by default as well, and reproduces the SOFA C test suite with it, but its functions are generic: they accept any real number type and carry it through the calculation.

## Argument types

Real-valued arguments are annotated `Real`, and vectors and matrices of them `AbstractVector{<:Real}` and `AbstractMatrix{<:Real}`. Counts and indices (a year, a number of decimal places, a planet number) are `Integer`. Each argument is typed independently of the others, so number types can be mixed freely in one call:

```jldoctest types
julia> using SOFA

julia> jd2cal(2451545, 0) # Integer Julian Date
(year = 2000, month = 1, day = 1, fraction = 0.5)

julia> era00(2451545, 1 // 4) == era00(2451545.0, 0.25) # Integer and Rational
true
```

## Result types

Floating-point results have the promoted floating-point type of the real-valued arguments. The parts of a two-part date, and the fields of a returned `NamedTuple` in general, share that type:

```jldoctest types
julia> typeof(era00(2451545, 0))
Float64

julia> typeof(era00(big"2451545", 0.25))
BigFloat

julia> typeof(taitt(big"2453750.5", 0.892482639))
@NamedTuple{day::BigFloat, fraction::BigFloat}
```

The constants of the library are `Float64`, so number types narrower than `Float64` are widened wherever a constant enters the calculation, which is nearly everywhere: `Float32` arguments generally give `Float64` results. Integer results, such as the fields of a calendar date, stay integers.

## Extended precision

Arguments of an extended precision type such as `BigFloat` are never converted to `Float64` along the way. This removes the rounding error of the arithmetic, and it preserves the full resolution of the arguments. Dates are where that matters most. A `Float64` Julian Date of the present era resolves only about 40 microseconds, which is why the SOFA functions take dates in two parts; a `BigFloat` date can simply be given in one:

```jldoctest types
julia> θ = era00(big"2400000.5", big"54388.123456789"); # two-part date

julia> abs(era00(big"2454388.623456789", 0) - θ) < 1e-60 # one-part date, BigFloat
true

julia> abs(era00(2454388.623456789, 0.0) - θ) > 1e-10 # one-part date, Float64
true
```

Here the one-part `Float64` date costs ``1.1 \times 10^{-9}`` radians, where the two-part `Float64` date is good to ``8 \times 10^{-12}``.

Extended precision does not, however, make the results more *accurate* than `Float64` ones. The constants and series coefficients are `Float64` literals, as are factors like `2π` and the arcsecond in radians, so each is only within ``1.1 \times 10^{-16}`` of its defined value, relatively, and that error propagates like any rounding error. The `BigFloat` Earth rotation angle above, for instance, agrees with an exact evaluation of the defining expression to ``4 \times 10^{-15}`` radians: the accuracy of `Float64` arithmetic, not of `BigFloat`. This is a limitation of the package: the SOFA algorithms are formulated for double precision, and the models they implement are not meaningful at that level in any case (one microarcsecond is ``4.8 \times 10^{-12}`` radians).

Calculations in `BigFloat` are also much slower than in `Float64`, which remains the fast path. `BigFloat` is the extended precision type covered by the package tests.

## Astrometry parameters

The star-independent astrometry parameters [`Astrom`](@ref) and the light-deflecting bodies [`Ldbody`](@ref) are parametric, `Astrom{T}` and `Ldbody{T}`, and store every field with the one element type `T`. They are created with the type of the arguments they are computed from:

```jldoctest types
julia> typeof(apci13(2456165.5, 0.401182685).astrom)
Astrom{Float64}

julia> typeof(apci13(big"2456165.5", big"0.401182685").astrom)
Astrom{BigFloat}
```

Their constructors promote, and so do the functions that update existing parameters, [`aper`](@ref), [`aper13`](@ref), [`apio`](@ref) and [`apio13`](@ref): a value of a wider type widens the parameters rather than being truncated to their element type.

```jldoctest types
julia> astrom = apci13(2456165.5, 0.401182685).astrom;

julia> typeof(aper(big"1.5", astrom))
Astrom{BigFloat}

julia> typeof(Ldbody(1, 6.0e-6, [[1, 2, 3], [4.0, 5.0, 6.0]]))
Ldbody{Float64}
```
