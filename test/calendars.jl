####   Test Calendar functions   ####

#   Calender to Julian Date
@test all(abs.(values(SOFA.cal2jd(2003, 06, 01)) .- (2400000.5, 52791.0)) .<= (0., 0.))

#   Julian Date to Besselian Epoch
@test abs(SOFA.epb(2415019.8135, 30103.18648) - 1982.418424159278580) <= 1e-12

#   Besselian Epoch to Julian Date
@test all(abs.(values(SOFA.epb2jd(1957.3)) .- (2400000.5, 35948.1915101513)) .<= (1e-9, 1e-9))

#   Julian Date to Julian Epoch
@test abs(SOFA.epj(2451545, -7392.5) - 1979.760438056125941) <= 1e-12

#   Julian Epoch to Julian Date
@test all(abs.(values(SOFA.epj2jd(1996.8)) .- (2400000.5, 50375.7)) .<= (1e-9, 1e-9))

#   Julian Date to Gregorian calendar
@test all(abs.(values(SOFA.jd2cal(2400000.5, 50123.9999)) .- (1996, 2, 10, 0.9999)) .<= (0, 0, 0, 1e-7))

#   Julian Date to Gregorian calendar
@test all(abs.(values(SOFA.jdcalf(4, 2400000.5, 50123.9999)) .- (1996, 2, 10, 9999)) .== (0, 0, 0, 0))
