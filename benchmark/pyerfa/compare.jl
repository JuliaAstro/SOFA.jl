# Cross-language benchmark: SOFA.jl vs pyerfa (numpy ufunc wrapper over the
# ERFA C library, which is the relicensed IAU SOFA C code).
#
#     julia -t 1 --project=benchmark/pyerfa -e 'using Pkg; Pkg.instantiate()'
#     julia -t 1 --project=benchmark/pyerfa benchmark/pyerfa/compare.jl
#
# Writes scalar_comparison.csv, array_comparison.csv, and provenance.toml
# next to this script (committed); the raw Python-side CSVs are gitignored.
#
# pyerfa's pip wheel bundles liberfa 2.0.1, which is derived from SOFA
# release 20231011 — the same release SOFA.jl v2 implements. The provenance
# block below hard-fails if that ever drifts.

# Single-threaded numerics on both sides; numpy reads these at import time,
# so they must be set before PythonCall initializes Python.
ENV["OPENBLAS_NUM_THREADS"] = "1"
ENV["OMP_NUM_THREADS"] = "1"
ENV["MKL_NUM_THREADS"] = "1"
ENV["NUMEXPR_NUM_THREADS"] = "1"
# Keep ~/.local site-packages out of sys.path: a user-site numpy would
# silently shadow the pinned CondaPkg environment.
ENV["PYTHONNOUSERSITE"] = "1"

using SOFA
using PythonCall
using Chairmarks
using CSV
using DataFrames
using Dates
using Statistics
using TOML

const erfa = pyimport("erfa")

# ── Provenance ──────────────────────────────────────────────────────────────

prov = Dict(
    "date" => string(Dates.now()),
    "julia_version" => string(VERSION),
    "sofa_jl" => string(pkgversion(SOFA)),
    "pyerfa" => pyconvert(String, erfa.version.version),
    "erfa_version" => pyconvert(String, erfa.version.erfa_version),
    "sofa_version" => pyconvert(String, erfa.version.sofa_version),
    "numpy" => pyconvert(String, pyimport("numpy").__version__),
    "python" => pyconvert(String, pyimport("sys").version),
    "cpu" => Sys.cpu_info()[1].model,
    "julia_threads" => Threads.nthreads(),
)
@assert prov["sofa_version"] == "20231011" begin
    "pyerfa wraps SOFA $(prov["sofa_version"]); SOFA.jl v2 targets 20231011"
end
@assert startswith(prov["numpy"], "2.2") begin
    "numpy $(prov["numpy"]) loaded; CondaPkg pins 2.2 — is a user-site numpy leaking into sys.path?"
end
# provenance.toml is written at the very end, after both CSVs, so a partial
# run can never pair fresh metadata with stale committed numbers.

# ── Cross-validation: both sides must agree before timing means anything ────

let atol = 1e-9
    j = utctai(2453750.5, 0.892100694)
    p = erfa.utctai(2453750.5, 0.892100694)
    @assert abs(j.day - pyconvert(Float64, p[0])) < atol
    @assert abs(j.fraction - pyconvert(Float64, p[1])) < atol

    j = nut06a(2400000.5, 53736.0)
    p = erfa.nut06a(2400000.5, 53736.0)
    @assert abs(j.ψ - pyconvert(Float64, p[0])) < atol
    @assert abs(j.ϵ - pyconvert(Float64, p[1])) < atol

    j = era00(2400000.5, 54388.0)
    @assert abs(j - pyconvert(Float64, erfa.era00(2400000.5, 54388.0))) < atol
end
@info "Cross-validation passed (utctai, nut06a, era00)"

# ── Scalar comparison ───────────────────────────────────────────────────────
# Name-for-name cases. Arguments are written so that Julia's repr() of each
# tuple is also a valid Python literal — one source of truth for both sides.
# The dtf2d case uses a mid-day time (not a leap second) because pyerfa's
# checked wrapper turns nonzero status into a warning on every call.

const SCALAR_CASES = [
    ("cal2jd", (2003, 6, 1)),
    ("jd2cal", (2400000.5, 50123.9999)),
    ("dat", (2003, 6, 1, 0.0)),
    ("utctai", (2453750.5, 0.892100694)),
    ("taitt", (2453750.5, 0.892482639)),
    ("dtf2d", ("UTC", 1994, 6, 30, 12, 5, 2.0)),
    ("d2dtf", ("UTC", 5, 2400000.5, 49533.99999)),
    ("nut06a", (2400000.5, 53736.0)),
    ("pnm06a", (2400000.5, 50123.9999)),
    ("xy06", (2400000.5, 53736.0)),
    ("era00", (2400000.5, 54388.0)),
    ("gmst06", (2400000.5, 53736.0, 2400000.5, 53736.0)),
    ("gst06a", (2400000.5, 53736.0, 2400000.5, 53736.0)),
    ("epv00", (2400000.5, 53411.52501161)),
    ("moon98", (2400000.5, 43999.9)),
    ("plan94", (2400000.5, 43999.9, 3)),
    ("atci13", (2.71, 0.174, 1e-5, 5e-6, 0.1, 55.0, 2456165.5, 0.401182685)),
    ("anp", (-0.1,)),
    ("c2s", ([100.0, -50.0, 25.0],)),
]

@info "Benchmarking SOFA.jl scalar calls…"
julia_scalar = DataFrame(map(enumerate(SCALAR_CASES)) do (i, (name, args))
    f = getfield(SOFA, Symbol(name))
    call = let f = f, a = args
        () -> f(a...)
    end
    b = @be call() seconds = 0.25
    (; order = i, function_name = name, julia_ns = 1e9 * median(b).time)
end)

const PY_SCALAR_CSV = joinpath(@__DIR__, "python_scalar.csv")

py_cases = join(("(\"$name\", $(repr(args)))" for (name, args) in SCALAR_CASES),
                ",\n    ")
py_scalar_script = """
import csv
import time

import numpy as np
import erfa

CASES = [
    $py_cases
]
WARMUP, TRIALS = 3, 9

def bench(fn, args):
    fn(*args)                                   # first-call caches
    t0 = time.perf_counter(); fn(*args); est = time.perf_counter() - t0
    k = max(1, int(1e-3 / max(est, 1e-9)))      # >= ~1 ms per trial
    times = []
    for i in range(WARMUP + TRIALS):
        t0 = time.perf_counter()
        for _ in range(k):
            fn(*args)
        dt = (time.perf_counter() - t0) / k
        if i >= WARMUP:
            times.append(dt)
    return 1e9 * float(np.median(times))

rows = []
for name, args in CASES:
    # One-time conversions outside the timed loops: the Julia side gets
    # pre-built Vector{Float64}s, so timing per-call list->ndarray (or
    # str->bytes) conversion here would overstate SOFA.jl's advantage.
    args = tuple(np.asarray(a) if isinstance(a, list) else a for a in args)
    wrapped_ns = bench(getattr(erfa, name), args)
    try:
        uargs = tuple(a.encode() if isinstance(a, str) else a for a in args)
        ufunc_ns = bench(getattr(erfa.ufunc, name), uargs)
    except Exception:
        ufunc_ns = float("nan")
    rows.append({"function_name": name,
                 "pyerfa_ns": wrapped_ns,
                 "pyerfa_ufunc_ns": ufunc_ns})
    print(f"{name:10s} wrapped={wrapped_ns:12.1f} ns  ufunc={ufunc_ns:12.1f} ns")

with open(r"$PY_SCALAR_CSV", "w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=rows[0].keys())
    w.writeheader()
    w.writerows(rows)
"""

@info "Benchmarking pyerfa scalar calls…"
pyexec(py_scalar_script, Main)

scalar = leftjoin(julia_scalar, CSV.read(PY_SCALAR_CSV, DataFrame);
                  on = :function_name)
sort!(scalar, :order)
select!(scalar, Not(:order))
scalar.ratio_pyerfa = scalar.pyerfa_ns ./ scalar.julia_ns
scalar.ratio_ufunc = scalar.pyerfa_ufunc_ns ./ scalar.julia_ns
CSV.write(joinpath(@__DIR__, "scalar_comparison.csv"), scalar)

# ── Array sweep: Julia broadcast vs erfa ufunc on growing arrays ────────────
# Scalar first argument broadcast against a length-N second argument on both
# sides. Epoch windows keep every element warning-free (epv00: 1900-2100).

# Each case's f takes d1 as an argument so the epoch lives in exactly one
# place (the d1 field, which the generated Python script also reads).
const ARRAY_SWEEP = [
    (name = "taitt", d1 = 2453750.5, lo = 0.0, hi = 0.4, nmax = 10^6,
     f = (d1, d2) -> taitt.(d1, d2)),
    (name = "utctai", d1 = 2453750.5, lo = 0.0, hi = 0.4, nmax = 10^6,
     f = (d1, d2) -> utctai.(d1, d2)),
    (name = "era00", d1 = 2453750.5, lo = 0.0, hi = 0.4, nmax = 10^6,
     f = (d1, d2) -> era00.(d1, d2)),
    (name = "nut06a", d1 = 2400000.5, lo = 53411.0, hi = 53776.0, nmax = 10^4,
     f = (d1, d2) -> nut06a.(d1, d2)),
    (name = "epv00", d1 = 2400000.5, lo = 53411.0, hi = 53776.0, nmax = 10^4,
     f = (d1, d2) -> epv00.(d1, d2)),
    (name = "atci13", d1 = 2456165.5, lo = 0.0, hi = 0.4, nmax = 10^3,
     f = (d1, d2) -> atci13.(2.71, 0.174, 1e-5, 5e-6, 0.1, 55.0, d1, d2)),
]

@info "Benchmarking SOFA.jl array broadcasts…"
julia_array = DataFrame(mapreduce(vcat, ARRAY_SWEEP) do case
    map(2:round(Int, log10(case.nmax))) do e
        n = 10^e
        d2 = collect(range(case.lo, case.hi; length = n))
        b = @be case.f($(case.d1), $d2) seconds = 0.5
        t = 1e9 * median(b).time
        (; function_name = case.name, n, julia_ns_per_call = t,
         julia_ns_per_elem = t / n)
    end
end)

const PY_ARRAY_CSV = joinpath(@__DIR__, "python_array.csv")

py_sweep = join(("(\"$(c.name)\", $(c.d1), $(c.lo), $(c.hi), $(c.nmax))"
                 for c in ARRAY_SWEEP), ",\n    ")
py_array_script = """
import csv
import time

import numpy as np
import erfa

SWEEP = [
    $py_sweep
]
ATCI13_PREFIX = (2.71, 0.174, 1e-5, 5e-6, 0.1, 55.0)
WARMUP, TRIALS = 2, 7

def bench(call):
    call()
    t0 = time.perf_counter(); call(); est = time.perf_counter() - t0
    k = max(1, int(1e-3 / max(est, 1e-9)))
    times = []
    for i in range(WARMUP + TRIALS):
        t0 = time.perf_counter()
        for _ in range(k):
            call()
        dt = (time.perf_counter() - t0) / k
        if i >= WARMUP:
            times.append(dt)
    return 1e9 * float(np.median(times))

rows = []
for name, d1, lo, hi, nmax in SWEEP:
    fn = getattr(erfa.ufunc, name)
    n = 100
    while n <= nmax:
        d2 = np.linspace(lo, hi, n)
        if name == "atci13":
            call = lambda: fn(*ATCI13_PREFIX, d1, d2)
        else:
            call = lambda: fn(d1, d2)
        t = bench(call)
        rows.append({"function_name": name, "n": n,
                     "pyerfa_ufunc_ns_per_call": t,
                     "pyerfa_ufunc_ns_per_elem": t / n})
        print(f"{name:10s} n={n:8d}  {t / n:10.1f} ns/elem")
        n *= 10

with open(r"$PY_ARRAY_CSV", "w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=rows[0].keys())
    w.writeheader()
    w.writerows(rows)
"""

@info "Benchmarking pyerfa ufunc arrays…"
pyexec(py_array_script, Main)

array = leftjoin(julia_array, CSV.read(PY_ARRAY_CSV, DataFrame);
                 on = [:function_name, :n])
array.ratio_per_elem = array.pyerfa_ufunc_ns_per_elem ./ array.julia_ns_per_elem
CSV.write(joinpath(@__DIR__, "array_comparison.csv"), array)

# All benchmarks and CSVs done — now the metadata cannot outrun the numbers.
open(joinpath(@__DIR__, "provenance.toml"), "w") do io
    TOML.print(io, prov)
end

# ── Console summary ─────────────────────────────────────────────────────────

println("\nScalar (ns, median; ratio > 1 means SOFA.jl is faster):")
show(scalar; allrows = true, allcols = true, summary = false)
println("\n\nArray sweep (ns/element, median):")
show(array; allrows = true, allcols = true, summary = false)
println()
