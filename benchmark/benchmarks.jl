# BenchmarkTools suite consumed by AirspeedVelocity.jl (benchpkg / CI action).
#
# On CI this file only defines `SUITE`; AirspeedVelocity drives the run.
# Run locally to also execute the suite and print a summary table:
#
#     julia --project=benchmark benchmark/benchmarks.jl
#
# All inputs are canonical SOFA validation vectors taken from test/*.jl, as
# Float64 literals: most kernels constrain every argument to a single
# AbstractFloat type, and mixed Int/Float arguments would measure a conversion
# wrapper instead of the kernel. Epochs are chosen inside each function's
# warning-free range (epv00: 1900-2100, plan94: 1000-3000). A per-eval @warn
# would dominate the timing.
#
# Kernels below ~200 ns read their arguments through Refs (blocks constant
# propagation) and set an explicit evals so results do not depend on whether
# the runner tunes the suite: untuned runs use evals=1, where a ~10 ns timer
# granularity would swamp the measurement.

using SOFA
using BenchmarkTools

# Keep the full-suite runtime PR-friendly (~1 min of measurement per revision).
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 1.0

const SUITE = BenchmarkGroup()
for g in (
        "timescales", "calendars", "precession", "rotations",
        "ephemerides", "astrometry", "vectorops", "coordinates",
    )
    SUITE[g] = BenchmarkGroup()
end

const d1 = Ref(2453750.5)
const tt2 = Ref(0.892482639)
const utc2 = Ref(0.892100694)
const mjd_a = Ref(2400000.5)
const mjd_prec = Ref(53736.0)
const era_d2 = Ref(54388.0)
const cal_y = Ref(2003)
const cal_m = Ref(6)
const cal_d = Ref(1)
const epb_d1 = Ref(2415019.8135)
const epb_d2 = Ref(30103.18648)
const dat_y = Ref(2017)

# timescales: taitt is pure arithmetic; utctai adds jd2cal x2 + dat x3; the
# dtf2d vector exercises the 1994-06-30 leap-second branch without warning.
SUITE["timescales"]["taitt"] = @benchmarkable taitt($d1[], $tt2[]) evals = 1000
SUITE["timescales"]["utctai"] = @benchmarkable utctai($d1[], $utc2[]) evals = 100
SUITE["timescales"]["dtf2d"] = @benchmarkable dtf2d("UTC", 1994, 6, 30, 23, 59, 60.13599) evals = 100
SUITE["timescales"]["d2dtf"] = @benchmarkable d2dtf("UTC", 5, $mjd_a[], 49533.99999) evals = 100
SUITE["timescales"]["dat"] = @benchmarkable dat($dat_y[], 9, 1, 0.0) evals = 1000
# Composite chain through the NamedTuple pass-through and curried Fix2 forms,
# mirroring an astropy Time scale chain (utc -> tai -> tt -> tdb).
SUITE["timescales"]["utc_to_tdb_chain"] = @benchmarkable(utctai($d1[], $utc2[]) |> taitt |> tttdb(-0.000201), evals = 100)

SUITE["calendars"]["cal2jd"] = @benchmarkable cal2jd($cal_y[], $cal_m[], $cal_d[]) evals = 1000
SUITE["calendars"]["jd2cal"] = @benchmarkable jd2cal($mjd_a[], 50123.9999) evals = 1000
SUITE["calendars"]["epb"] = @benchmarkable epb($epb_d1[], $epb_d2[]) evals = 1000

# nut00a is the 1365-term luni-solar + planetary series; pnm06a and xy06 are
# the composite matrix/CIO paths built on top of it.
SUITE["precession"]["nut00a"] = @benchmarkable nut00a($mjd_a[], $mjd_prec[])
SUITE["precession"]["nut06a"] = @benchmarkable nut06a($mjd_a[], $mjd_prec[])
SUITE["precession"]["pnm06a"] = @benchmarkable pnm06a($mjd_a[], 50123.9999)
SUITE["precession"]["xy06"] = @benchmarkable xy06($mjd_a[], $mjd_prec[])

SUITE["rotations"]["era00"] = @benchmarkable era00($mjd_a[], $era_d2[]) evals = 1000
SUITE["rotations"]["gmst06"] = @benchmarkable gmst06($mjd_a[], $mjd_prec[], $mjd_a[], $mjd_prec[]) evals = 1000
SUITE["rotations"]["gst06a"] = @benchmarkable gst06a($mjd_a[], $mjd_prec[], $mjd_a[], $mjd_prec[])

SUITE["ephemerides"]["epv00"] = @benchmarkable epv00($mjd_a[], 53411.52501161)
SUITE["ephemerides"]["moon98"] = @benchmarkable moon98($mjd_a[], 43999.9)
SUITE["ephemerides"]["plan94"] = @benchmarkable plan94($mjd_a[], 43999.9, 3)

# The apci13/atci13/atco13 rows double as a canary for the abstract-typed
# Astrom struct fields (src/base.jl): concretizing them should show up here
# as a large allocation/time win.
SUITE["astrometry"]["apci13"] = @benchmarkable apci13(2456165.5, 0.401182685)
SUITE["astrometry"]["atci13"] = @benchmarkable atci13(2.71, 0.174, 1.0e-5, 5.0e-6, 0.1, 55.0, 2456165.5, 0.401182685)
const ATCO13_ARGS = (
    2.71, 0.174, 1.0e-5, 5.0e-6, 0.1, 55.0, 2456384.5, 0.969254051,
    0.1550675, -0.527800806, -1.2345856, 2738.0, 2.47230737e-7,
    1.82640464e-6, 731.0, 12.8, 0.59, 0.55,
)
SUITE["astrometry"]["atco13"] = @benchmarkable atco13($ATCO13_ARGS...)

const ANP_X = Ref(-0.1)
const V3 = [100.0, -50.0, 25.0]
const V3A = [2.0, 2.0, 3.0]
const V3B = [1.0, 3.0, 4.0]
const R33 = [2.0 3.0 2.0; 3.0 2.0 3.0; 3.0 4.0 5.0]
const RV3 = [0.2, 1.5, 0.1]
SUITE["vectorops"]["anp"] = @benchmarkable anp($ANP_X[]) evals = 1000
SUITE["vectorops"]["c2s"] = @benchmarkable c2s($V3) evals = 1000
SUITE["vectorops"]["pxp"] = @benchmarkable pxp($V3A, $V3B) evals = 1000
SUITE["vectorops"]["rxp"] = @benchmarkable rxp($R33, $RV3) evals = 1000

const XYZ = [2.0e6, 3.0e6, 5.244e6]
const GD_E = Ref(3.1)
const GAL_L = Ref(5.5850536063818546)
const GAL_B = Ref(-0.7853981633974483)
SUITE["coordinates"]["gc2gd"] = @benchmarkable gc2gd(:WGS84, $XYZ) evals = 1000
SUITE["coordinates"]["gd2gc"] = @benchmarkable gd2gc(:WGS84, $GD_E[], -0.5, 2500.0) evals = 1000
SUITE["coordinates"]["g2icrs"] = @benchmarkable g2icrs($GAL_L[], $GAL_B[]) evals = 1000

# If not on CI, we'll show a nice table
if get(ENV, "CI", "false") == "false"
    using PrettyTables: pretty_table

    results = run(SUITE, verbose = true)
    rows = sort(BenchmarkTools.leaves(results), by = first)
    data = permutedims(
        hcat(
            [
                [
                    join(path, "/"),
                    BenchmarkTools.prettytime(median(t).time),
                    BenchmarkTools.prettymemory(median(t).memory),
                    median(t).allocs,
                ] for (path, t) in rows
            ]...
        )
    )
    pretty_table(
        data;
        column_labels = ["Benchmark", "Median Time", "Memory", "Allocs"],
        alignment = [:l, :r, :r, :r]
    )
end
