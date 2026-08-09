# SOFA.jl benchmarks

Two independent layers:

1. **Regression tracking** (`benchmarks.jl`): a
   [BenchmarkTools](https://github.com/JuliaCI/BenchmarkTools.jl) suite run by
   [AirspeedVelocity.jl](https://github.com/MilesCranmer/AirspeedVelocity.jl)
   on every pull request. ~29 representative benchmarks spanning cheap to
   expensive kernels in eight groups mirroring `src/`, plus the automatic
   `time_to_load` measurement.
2. **Cross-language comparison** (`pyerfa/`): SOFA.jl vs.
   [pyerfa](https://github.com/liberfa/pyerfa), the numpy ufunc binding of the
   ERFA C library. ERFA is the relicensed IAU SOFA C code, and the pinned
   `pyerfa==2.0.1.5` bundles liberfa 2.0.1, derived from **SOFA release
   20231011 — the exact release SOFA.jl v2 implements**, so this compares the
   same algorithms at the same release, Julia vs C.

## CI

`.github/workflows/Benchmark.yml` runs the suite on the PR head and on `main`
and posts the comparison tables as a PR comment (updated in place on each
push; requires the `pull-requests: write` permission granted in the workflow).
A regression shows up as a time ratio > 1 with confidence intervals. Fork PRs
are skipped: benchpkg cannot reach fork head SHAs and their read-only token
could not post the comment.

The workflow also runs the pyerfa comparison fresh on the PR head
(`compare.jl` + `comment.jl`) and appends it to the same comment, below the
AirspeedVelocity tables (the ASV results additionally appear in the Actions
job summary). Those CI numbers come from a shared runner and are indicative;
run `compare.jl` on a quiet machine for reference-quality numbers.

## Running the suite locally

Quick run with a summary table (uses this directory's environment, which is a
workspace member — the parent SOFA checkout is used automatically):

```sh
julia --project=benchmark -e 'using Pkg; Pkg.instantiate()'
julia --project=benchmark benchmark/benchmarks.jl
```

AirspeedVelocity-formatted table (median ± IQR) for the current working tree,
including uncommitted changes, followed by a summary of the committed pyerfa
comparison CSVs (when present):

```sh
julia -e 'using Pkg; Pkg.add("AirspeedVelocity")'   # once, into the global env
julia --project=benchmark benchmark/table.jl
```

(AirspeedVelocity is found through Julia's default environment stack, which
falls back from the benchmark project to the global environment.)

Results are cached in `benchmark/results/` (gitignored); delete the JSON there
to force a re-run. To compare two revisions locally, use the `benchpkg` CLI
that AirspeedVelocity installs, e.g.:

```sh
benchpkg SOFA --rev=main,dirty --path=. --script=benchmark/benchmarks.jl \
    --output-dir=benchmark/results/
```

(Without `--output-dir` the results JSON lands in the repo root, which is not
gitignored.) The benchmark projects require Julia ≥ 1.11: on 1.10 Pkg has no
workspace/`[sources]` support and would silently resolve the registered SOFA
release instead of this checkout.

Note for suite authors: AirspeedVelocity `include()`s `benchmarks.jl` inside a
minimal temporary environment containing only SOFA and BenchmarkTools, so the
file must have no other top-level dependency — anything else (PrettyTables,
the suite execution itself) stays behind the `PROGRAM_FILE == @__FILE__`
guard at the bottom.

## pyerfa comparison

```sh
julia -t 1 --project=benchmark/pyerfa -e 'using Pkg; Pkg.instantiate()'
julia -t 1 --project=benchmark/pyerfa benchmark/pyerfa/compare.jl
```

The first run resolves a pinned Conda environment (python 3.12, numpy 2.2) and
pip-installs `pyerfa==2.0.1.5`. pyerfa comes from **pip, not conda-forge**: the
pip wheel bundles its own liberfa, so the single pin fixes the entire C stack.
Never set `PYERFA_USE_SYSTEM_LIBERFA` — it would silently swap in an arbitrary
system liberfa and void the version contract. The script hard-fails if
`erfa.version.sofa_version != "20231011"` and cross-validates numerical results
on both sides before timing anything.

Outputs, written next to the script (gitignored — CI regenerates them per PR
and posts them as a comment; run locally for reference-quality numbers):

- `pyerfa/scalar_comparison.csv` — scalar call, name for name: SOFA.jl vs
  `erfa.<name>` (checked wrapper, what users call) vs `erfa.ufunc.<name>` (raw
  kernel). Ratios > 1 mean SOFA.jl is faster.
- `pyerfa/array_comparison.csv` — Julia broadcast vs erfa ufunc over arrays of
  10² to 10⁶ elements: the per-element amortization story.
- `pyerfa/provenance.toml` — versions, CPU, and date of the numbers.

Methodology: single-threaded on both sides (`julia -t 1`, `OPENBLAS/OMP/MKL/
NUMEXPR_NUM_THREADS=1`); Julia timed with Chairmarks (built-in warmup), Python
with `time.perf_counter` around an inner repetition loop sized to ≥ 1 ms per
trial, ≥ 2 warmup rounds discarded, median of ≥ 7 trials.
