# Run the benchmark suite against the current working tree (including
# uncommitted changes) and print AirspeedVelocity's markdown results tables
# (median ± IQR times, then memory), plus a summary of the pyerfa comparison
# CSVs when they exist.

using AirspeedVelocity
using BenchmarkTools: prettytime
using PrettyTables

const PKG = "SOFA"
const REV = "dirty"
const RESULTS_DIR = joinpath(@__DIR__, "results")
const RESULTS_FILE = joinpath(RESULTS_DIR, "results_$(PKG)@$(REV).json")

if !isfile(RESULTS_FILE)
    @info "No results found at $RESULTS_FILE, running benchpkg"
    mkpath(RESULTS_DIR)   # the benchmark runner does not create it
    benchpkg(PKG;
        rev = REV,
        path = dirname(@__DIR__),
        output_dir = RESULTS_DIR,
        script = joinpath(@__DIR__, "benchmarks.jl"),
        dont_print = true,
    )
end

benchpkgtable(PKG; rev = REV, input_dir = RESULTS_DIR, mode = "time,memory")

# ── pyerfa comparison summary ───────────────────────────────────────────────
# Renders the committed CSVs produced by pyerfa/compare.jl. They are plain
# numeric tables with unquoted fields, so a split-based parse keeps CSV.jl
# out of this environment. Columns are looked up by header name.

const SCALAR_CSV = joinpath(@__DIR__, "pyerfa", "scalar_comparison.csv")
const ARRAY_CSV = joinpath(@__DIR__, "pyerfa", "array_comparison.csv")

function read_csv(path)
    lines = readlines(path)
    col = Dict(h => i for (i, h) in enumerate(split(first(lines), ',')))
    return col, [split(line, ',') for line in lines[2:end]]
end

# Missing/NaN cells (a ufunc case that failed to bench) render as an em dash.
parse_ns(s) = isempty(s) ? NaN : parse(Float64, s)
fmt_ns(s) = (x = parse_ns(s); isnan(x) ? "—" : prettytime(x))
function fmt_ratio(s)
    x = parse_ns(s)
    isnan(x) && return "—"
    return string(x >= 100 ? round(Int, x) : round(x; sigdigits = 3), "×")
end

if isfile(SCALAR_CSV)
    col, rows = read_csv(SCALAR_CSV)
    sort!(rows; by = r -> r[col["function_name"]])
    data = permutedims(hcat([[r[col["function_name"]],
                              fmt_ns(r[col["julia_ns"]]),
                              fmt_ns(r[col["pyerfa_ns"]]),
                              fmt_ns(r[col["pyerfa_ufunc_ns"]]),
                              fmt_ratio(r[col["ratio_pyerfa"]]),
                              fmt_ratio(r[col["ratio_ufunc"]])] for r in rows]...))
    pretty_table(data;
        title = "SOFA.jl vs pyerfa — scalar calls (ratio > 1: SOFA.jl faster)",
        column_labels = ["function", "SOFA.jl", "erfa.<f>", "erfa.ufunc.<f>",
                         "vs erfa", "vs ufunc"],
        alignment = [:l, :r, :r, :r, :r, :r],
        fit_table_in_display_vertically = false,
        fit_table_in_display_horizontally = false,
    )
else
    @info "No pyerfa scalar results at $SCALAR_CSV, run benchmark/pyerfa/compare.jl"
end

if isfile(ARRAY_CSV)
    col, rows = read_csv(ARRAY_CSV)
    sort!(rows; by = r -> (r[col["function_name"]], parse(Int, r[col["n"]])))
    data = permutedims(hcat([[r[col["function_name"]],
                              r[col["n"]],
                              fmt_ns(r[col["julia_ns_per_elem"]]),
                              fmt_ns(r[col["pyerfa_ufunc_ns_per_elem"]]),
                              fmt_ratio(r[col["ratio_per_elem"]])] for r in rows]...))
    pretty_table(data;
        title = "SOFA.jl broadcast vs erfa ufunc — per element",
        column_labels = ["function", "n", "SOFA.jl", "erfa.ufunc.<f>", "ratio"],
        alignment = [:l, :r, :r, :r, :r],
        fit_table_in_display_vertically = false,
        fit_table_in_display_horizontally = false,
    )
else
    @info "No pyerfa array results at $ARRAY_CSV, run benchmark/pyerfa/compare.jl"
end
