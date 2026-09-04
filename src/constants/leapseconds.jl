const IYV = 2023  # release year of the original dat function from the SOFA library

"""
    Drift second parameters
"""
struct Driftsecond{T <: Integer, U <: Real}
    year::T
    month::T
    mjd::U
    offset::U
    rate::U
end

# Reference dates and drift rates (sec/day), pre leap seconds.
const DRIFTSECOND =
    (
    Driftsecond(1960, 1, 37300.0, 1.417818, 0.001296),
    Driftsecond(1961, 1, 37300.0, 1.422818, 0.001296),
    Driftsecond(1961, 8, 37300.0, 1.372818, 0.001296),
    Driftsecond(1962, 1, 37665.0, 1.845858, 0.0011232),
    Driftsecond(1963, 11, 37665.0, 1.945858, 0.0011232),
    Driftsecond(1964, 1, 38761.0, 3.24013, 0.001296),
    Driftsecond(1964, 4, 38761.0, 3.34013, 0.001296),
    Driftsecond(1964, 9, 38761.0, 3.44013, 0.001296),
    Driftsecond(1965, 1, 38761.0, 3.54013, 0.001296),
    Driftsecond(1965, 3, 38761.0, 3.64013, 0.001296),
    Driftsecond(1965, 7, 38761.0, 3.74013, 0.001296),
    Driftsecond(1965, 9, 38761.0, 3.84013, 0.001296),
    Driftsecond(1966, 1, 39126.0, 4.31317, 0.002592),
    Driftsecond(1968, 2, 39126.0, 4.21317, 0.002592),
)

"""
    Leap second parameters
"""
struct Leapsecond{T <: Integer, U <: Real}
    year::T
    month::T
    second::U
end

# Dates and Δ(AT)s.
const LEAPSECOND =
    (
    Leapsecond(1972, 1, 10.0),
    Leapsecond(1972, 7, 11.0),
    Leapsecond(1973, 1, 12.0),
    Leapsecond(1974, 1, 13.0),
    Leapsecond(1975, 1, 14.0),
    Leapsecond(1976, 1, 15.0),
    Leapsecond(1977, 1, 16.0),
    Leapsecond(1978, 1, 17.0),
    Leapsecond(1979, 1, 18.0),
    Leapsecond(1980, 1, 19.0),
    Leapsecond(1981, 7, 20.0),
    Leapsecond(1982, 7, 21.0),
    Leapsecond(1983, 7, 22.0),
    Leapsecond(1985, 7, 23.0),
    Leapsecond(1988, 1, 24.0),
    Leapsecond(1990, 1, 25.0),
    Leapsecond(1991, 1, 26.0),
    Leapsecond(1992, 7, 27.0),
    Leapsecond(1993, 7, 28.0),
    Leapsecond(1994, 7, 29.0),
    Leapsecond(1996, 1, 30.0),
    Leapsecond(1997, 7, 31.0),
    Leapsecond(1999, 1, 32.0),
    Leapsecond(2006, 1, 33.0),
    Leapsecond(2009, 1, 34.0),
    Leapsecond(2012, 7, 35.0),
    Leapsecond(2015, 7, 36.0),
    Leapsecond(2017, 1, 37.0),
)
