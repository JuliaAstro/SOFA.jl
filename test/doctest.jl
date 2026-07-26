using Documenter

DocMeta.setdocmeta!(SOFA, :DocTestSetup, :(using SOFA); recursive = true)

doctest(SOFA)
