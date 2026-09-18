using Documenter
using Documenter.Remotes: GitHub
using SOFA

# Generate documents
makedocs(
    modules = [SOFA],
    # Doctests are run as part of the test suite instead (test/doctest.jl)
    doctest = false,
    authors = "Duncan Eddy, Paul Barrett",
    repo = GitHub("JuliaAstro/SOFA.jl"),
    sitename = "SOFA.jl",
    format = Documenter.HTML(;
        canonical = "https://juliaastro.org/SOFA/stable/",
        size_threshold = 800 * 1024, # 800 KiB
        size_threshold_warn = 200 * 1024, # 200 KiB
    ),
    pages = [
        "Home" => "index.md",
        "API Reference" => [
            "Overview" => "api/index.md",
            "Calendars" => "api/calendars.md",
            "Astrometry" => "api/astrometry.md",
            "Ephemerides" => "api/ephemerides.md",
            "Fundamental Arguments" => "api/coefficients.md",
            "Precession, Nutation, and Polar Motion" => "api/precession.md",
            "Earth Rotation and Sidereal Time" => "api/rotations.md",
            "Space Motion" => "api/spacemotion.md",
            "Star Catalogs" => "api/starcatalogs.md",
            "Ecliptic Coordinates" => "api/ecliptic.md",
            "Galactic Coordinates" => "api/galactic.md",
            "Geocentric Coordinates" => "api/geocentric.md",
            "Timescales" => "api/timescales.md",
            "Horizontal and Equatorial Coordinates" => "api/equatorial.md",
            "Gnomonic Projection" => "api/gnomonic.md",
            "Vector and Matrix Operations" => "api/vectorops.md",
            "Internals" => "api/internals.md",
        ],
    ],
)

deploydocs(
    repo = "github.com/JuliaAstro/SOFA.jl",
    push_preview = true,
    versions = ["stable" => "v^", "v#.#"], # Restrict to minor releases
)
