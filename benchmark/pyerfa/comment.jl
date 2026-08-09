# Render the pyerfa comparison outputs as a GitHub-markdown PR comment body.
# Dependency-free (Base + the TOML stdlib) so CI can run it outside any
# project environment, immediately after compare.jl has refreshed the files:
#
#     julia benchmark/pyerfa/comment.jl > pyerfa-comment.md

using TOML

const DIR = @__DIR__

function read_csv(path)
    lines = readlines(path)
    col = Dict(h => i for (i, h) in enumerate(split(first(lines), ',')))
    return col, [split(line, ',') for line in lines[2:end]]
end

parse_ns(s) = isempty(s) ? NaN : parse(Float64, s)

function fmt_ns(s)
    x = parse_ns(s)
    isnan(x) && return "—"
    x < 1e3 && return string(round(x; sigdigits = 4), " ns")
    x < 1e6 && return string(round(x / 1e3; sigdigits = 4), " μs")
    x < 1e9 && return string(round(x / 1e6; sigdigits = 4), " ms")
    return string(round(x / 1e9; sigdigits = 4), " s")
end

function fmt_ratio(s)
    x = parse_ns(s)
    isnan(x) && return "—"
    return string(x >= 100 ? round(Int, x) : round(x; sigdigits = 3), "×")
end

function markdown_table(io, header, rows)
    println(io, "| ", join(header, " | "), " |")
    println(io, "|:---", repeat("|---:", length(header) - 1), "|")
    for r in rows
        println(io, "| ", join(r, " | "), " |")
    end
end

prov = TOML.parsefile(joinpath(DIR, "provenance.toml"))
io = stdout

# Section heading: in CI this body is appended to the AirspeedVelocity
# comment body (body.md) to form one merged PR comment.
println(io, "## SOFA.jl vs pyerfa")
println(io)
sha = get(ENV, "PR_HEAD_SHA", "")
run_note = isempty(sha) ? "this working tree" : "PR head `$(first(sha, 7))`"
println(io, "Fresh comparison run for $run_note: SOFA.jl against pyerfa ",
        "$(prov["pyerfa"]) (ERFA $(prov["erfa_version"]), SOFA ",
        "$(prov["sofa_version"])). Ratios > 1 mean SOFA.jl is faster.")
println(io)

let (col, rows) = read_csv(joinpath(DIR, "scalar_comparison.csv"))
    sort!(rows; by = r -> r[col["function_name"]])
    println(io, "<details><summary>Scalar calls</summary>")
    println(io)
    markdown_table(io,
        ["function", "SOFA.jl", "`erfa.<f>`", "`erfa.ufunc.<f>`", "vs erfa", "vs ufunc"],
        [[r[col["function_name"]],
          fmt_ns(r[col["julia_ns"]]),
          fmt_ns(r[col["pyerfa_ns"]]),
          fmt_ns(r[col["pyerfa_ufunc_ns"]]),
          fmt_ratio(r[col["ratio_pyerfa"]]),
          fmt_ratio(r[col["ratio_ufunc"]])] for r in rows])
    println(io)
    println(io, "</details>")
    println(io)
end

let (col, rows) = read_csv(joinpath(DIR, "array_comparison.csv"))
    sort!(rows; by = r -> (r[col["function_name"]], parse(Int, r[col["n"]])))
    println(io, "<details><summary>Array sweep (per element)</summary>")
    println(io)
    markdown_table(io,
        ["function", "n", "SOFA.jl", "`erfa.ufunc.<f>`", "ratio"],
        [[r[col["function_name"]],
          r[col["n"]],
          fmt_ns(r[col["julia_ns_per_elem"]]),
          fmt_ns(r[col["pyerfa_ufunc_ns_per_elem"]]),
          fmt_ratio(r[col["ratio_per_elem"]])] for r in rows])
    println(io)
    println(io, "</details>")
    println(io)
end

println(io, "*Julia $(prov["julia_version"]), numpy $(prov["numpy"]), ",
        "single-threaded, $(prov["cpu"]), $(prov["date"]). ",
        "Timings from a shared CI runner — treat ratios as indicative; ",
        "run `benchmark/pyerfa/compare.jl` on a quiet machine for ",
        "reference-quality numbers.*")
