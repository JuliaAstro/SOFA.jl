export iauPxp
"""
p-vector outer (=vector=cross) product.

This function is part of the International Astronomical Union's
SOFA (Standards Of Fundamental Astronomy) software collection.

Status:  vector/matrix support function.

### Given
   a        double[3]      first p-vector
   b        double[3]      second p-vector

### Returned
   axb      double[3]      a x b

Note:
   It is permissible to re-use the same array for any of the
   arguments.

This revision:  2013 June 18

SOFA release 2018-01-30

Copyright (C) 2018 IAU SOFA Board.  See notes at end.
"""
function iauPxp(a::AbstractVector{<:Real}, b::AbstractVector{<:Real})
    # Preallocate return values
    axb = zeros(Float64, 3)

    ccall(
        (:iauPxp, libsofa_c), Cvoid,
        (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
        convert(Vector{Float64}, a),
        convert(Vector{Float64}, b),
        axb
    )

    return SVector{3}(axb)
end
