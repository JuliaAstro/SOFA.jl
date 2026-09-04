####   Test Calendar functions   ####

#   Calendar to Julian Date
@test all(abs.(values(SOFA.cal2jd(2003, 06, 01)) .- (2400000.5, 52791.0)) .<= (0.0, 0.0))

#   Julian Date to Besselian Epoch
@test abs(SOFA.epb(2415019.8135, 30103.18648) - 1982.41842415927858) <= 1.0e-12

#   Besselian Epoch to Julian Date
@test all(abs.(values(SOFA.epb2jd(1957.3)) .- (2400000.5, 35948.1915101513)) .<= (1.0e-9, 1.0e-9))

#   Julian Date to Julian Epoch
@test abs(SOFA.epj(2451545, -7392.5) - 1979.760438056125941) <= 1.0e-12

#   Julian Epoch to Julian Date
@test all(abs.(values(SOFA.epj2jd(1996.8)) .- (2400000.5, 50375.7)) .<= (1.0e-9, 1.0e-9))

#   Julian Date to Gregorian calendar
@test all(abs.(values(SOFA.jd2cal(2400000.5, 50123.9999)) .- (1996, 2, 10, 0.9999)) .<= (0, 0, 0, 1.0e-7))

#   Julian Date to Gregorian calendar
@test all(abs.(values(SOFA.jdcalf(4, 2400000.5, 50123.9999)) .- (1996, 2, 10, 9999)) .== (0, 0, 0, 0))

####    Regression tests (v2.0.0 pre-release review)    ####

#   cal2jd: century term was (year + month + 4900)/100, one day off for
#   January/February dates
@test SOFA.cal2jd(1900, 1, 1)[:mjd] == 15020
@test SOFA.cal2jd(2098, 3, 1)[:mjd] == 87398

#   jd2cal: the fraction-rounds-to-1.0 guards were dead code (typemin
#   instead of eps); the day must roll over and the fraction become 0
@test all(
    values(SOFA.jd2cal(2451545.0, 0.49999999999999994)) .==
        (2000, 1, 2, 0.0)
)

#   jdcalf: the returned fraction must come from jd2cal after any day
#   rollover (used to return fraction = denominator)
@test all(values(SOFA.jdcalf(2, 2400000.5, 50123.9999)) .== (1996, 2, 11, 0))
