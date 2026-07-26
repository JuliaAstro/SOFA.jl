using Documenter

DocMeta.setdocmeta!(SOFA, :DocTestSetup, :(using SOFA); recursive = true)

# Trailing digits of printed floats can differ by one ulp across Julia versions
# and platforms, so compare doctest output only down to 8 fractional digits.
doctest(SOFA; doctestfilters = [r"(\d\.\d{8})\d+" => s"\1"])
