using Documenter, SOFA

# Generate documents
makedocs(
    modules   = [SOFA],
    doctest   = false,
    clean     = true,
    linkcheck = true,
    format    = Documenter.HTML(),
    warnonly = [:docs_block, :missing_docs],
    sitename  = "SOFA.jl",
    authors   = "Duncan Eddy",
    pages     = Any[
        "Home" => "index.md",
        "SOFA Library" => "sofa.md",
    ]
)

deploydocs(
    repo = "github.com/sisl/SOFA.jl",
    devbranch = "master",
    devurl = "latest",
)
