using Documenter, SOFA

# Generate documents
makedocs(
    modules   = [SOFA],
    doctest   = false,
    clean     = true,
    linkcheck = true,
    format    = Documenter.HTML(
        size_threshold_warn = 400 * 1024,   # 200 KiB
        size_threshold = 800 * 1024,        # 400 KiB
    ),
    warnonly = [:docs_block, :missing_docs],
    sitename  = "SOFA.jl",
    authors   = "Duncan Eddy",
    pages     = Any[
        "Home" => "index.md",
        "SOFA Library" => "sofa.md",
    ]
)

deploydocs(
    repo = "github.com/JuliaAstro/SOFA.jl",
    devbranch = "master",
    devurl = "latest",
)
