using Documenter
using Documenter.Remotes: GitHub
using SOFA

# Generate documents
makedocs(
    modules   = [SOFA],
    authors   = "Duncan Eddy",
    repo = GitHub("JuliaAstro/SOFA.jl"),
    sitename  = "SOFA.jl",
    format = Documenter.HTML(;
        canonical = "https://juliaastro.org/SOFA/stable/",
    ),
    pages = [
        "Home" => "index.md",
        "SOFA Library" => "sofa.md",
    ],
)

deploydocs(
    repo = "github.com/JuliaAstro/SOFA.jl",
    push_preview = true,
    versions = ["stable" => "v^", "v#.#"], # Restrict to minor releases
)
