####    Test Astronomy Fundamental Arguments    ####

@test abs(SOFA.fad03(0.8) - 1.946709205396925672) <= 1e-12

@test abs(SOFA.fae03(0.8) - 1.744713738913081846) <= 1e-12

@test abs(SOFA.faf03(0.8) - 0.2597711366745499518) <= 1e-12

@test abs(SOFA.faju03(0.8) - 5.275711665202481138) <= 1e-12

@test abs(SOFA.fal03(0.8) - 5.132369751108684150) <= 1e-12

@test abs(SOFA.falp03(0.8) - 6.226797973505507345) <= 1e-12

@test abs(SOFA.fama03(0.8) - 3.275506840277781492) <= 1e-12

@test abs(SOFA.fame03(0.8) - 5.417338184297289661) <= 1e-12

@test abs(SOFA.fane03(0.8) - 2.079343830860413523) <= 1e-12

@test abs(SOFA.faom03(0.8) - -5.973618440951302183) <= 1e-12

@test abs(SOFA.fapa03(0.8) - 0.1950884762240000000e-1) <= 1e-12

@test abs(SOFA.fasa03(0.8) - 5.371574539440827046) <= 1e-12

@test abs(SOFA.faur03(0.8) - 5.180636450180413523) <= 1e-12

@test abs(SOFA.fave03(0.8) - 3.424900460533758000) <= 1e-12

####    Regression tests (v2.0.0 pre-release review)    ####

#   fapa03: no 2pi reduction (accumulated general precession), so
#   pre-J2000 dates give negative values
@test abs(SOFA.fapa03(-1.0) + 0.02437636309) <= 1e-12

#   planetary longitudes use fmod semantics (sign preserved for t < 0)
@test SOFA.fae03(-10.0) < 0.0
