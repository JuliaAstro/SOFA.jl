struct PeriodicTerms
    #  angular harmonics
    n::Vector{Int8}
    #  amplitude coefficients
    a::Vector{Float64}
end

# getindex(type, field) = [j for (j,f)=enumerate(fieldnames(type)) if f==field][1]
# getfields(term, field) = [getfield(term, j) for j=1:getindex(typeof(term), field)]
# getfields(term, N) = [getfield(term, j) for j=1:N]

Rx(θ) = SMatrix{3, 3}(1.0, 0.0, 0.0, 0.0, cos(θ), -sin(θ), 0.0, sin(θ), cos(θ))
Ry(θ) = SMatrix{3, 3}(cos(θ), 0.0, sin(θ), 0.0, 1.0, 0.0, -sin(θ), 0.0, cos(θ))
Rz(θ) = SMatrix{3, 3}(cos(θ), -sin(θ), 0.0, sin(θ), cos(θ), 0.0, 0.0, 0.0, 1.0)
function vec2mat(v::AbstractVector{<:Real})
    zerot = zero(eltype(v))
    return SMatrix{3, 3}(zerot, v[3], -v[2], -v[3], zerot, v[1], v[2], -v[1], zerot)
end

#=
function *(a::SMatrix{3,3}, b::SMatrix{3,3})
    SMatrix{3,3}(
        sum(a[1,:].*b[:,1]), sum(a[1,:].*b[:,2]), sum(a[1,:].*b[:,3]),
        sum(a[2,:].*b[:,1]), sum(a[2,:].*b[:,2]), sum(a[2,:].*b[:,3]),
        sum(a[3,:].*b[:,1]), sum(a[3,:].*b[:,2]), sum(a[3,:].*b[:,3]))
end
=#

function leapday(year::Integer, month::Integer)
    return month == 2 && year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
end

function calendar2MJD(year::Integer, month::Integer, day::Integer)
    year, month, day = Int64(year), Int64(month), Int64(day)

    @assert -4799 <= year "Year less than -4799."
    @assert 1 <= month <= 12 "Month out of range [1-12]."
    dayinmonth = DAYINMONTH[month] + (leapday(year, month) ? 1 : 0)
    @assert 1 <= day <= dayinmonth "Day out of range [1-$dayinmonth]."

    return (
        (Int64(1461) * (year + (month - 14) ÷ 12 + 4800)) ÷ 4 +
            (Int64(367) * (month - 2 - 12 * ((month - 14) ÷ 12))) ÷ 12 -
            (Int64(3) * ((year + (month - 14) ÷ 12 + 4900) ÷ 100)) ÷ 4 +
            day - 2432076
    )
end

"""
   @const_smatrix_from_series name series field

Defines a global constant SMatrix instance with a given `name` from
a `series` and using its `field` name.
"""
macro const_smatrix_from_series(name, series, field)
    return quote
        local tmp = reduce(vcat, [getfield(t, $(QuoteNode(field)))' for t in $(esc(series))])
        const $(esc(name)) = SMatrix{size(tmp)...}(tmp...)
    end
end
