####    Test Astronomy Timescales    ####

#   Julian day to Universal Coordinated Time (UTC), including leap second
@test all(abs.(values(SOFA.d2dtf("UTC", 5, 2400000.5, 49533.99999)) .-
               (1994, 6, 30, 23, 59, 60, 13599)) .== 0)

#   Calculate Δ(AT) = TAI-UTC
@test SOFA.dat(2003, 6, 1, 0.0) == 32.0
@test SOFA.dat(2008, 1, 17, 0.0) == 33.0
@test SOFA.dat(2017, 9, 1, 0.0) == 37.0

#   Approximation to TDB-TT
@test SOFA.dtdb(2448939.5, 0.123, 0.76543, 5.0123, 5525.242, 3190.0) ≈ -0.1280368005936998991e-2 atol=1e-15

#   Universal Coordinated Time (UTC) to Julian day, including leap second
@test sum(values(SOFA.dtf2d("UTC", 1994, 6, 30, 23, 59, 60.13599))) ≈ 2449534.49999 atol=1e-13

@test all(abs.(values(SOFA.taitt(2453750.5, 0.892482639)) .- (2453750.5, 0.892855139)) .<= 1e-12)

@test all(abs.(values(SOFA.taiut1(2453750.5, 0.892482639, -32.6659)) .-
               (2453750.5, 0.8921045614537037037)) .<= 1e-12)

@test all(abs.(values(SOFA.taiutc(2453750.5, 0.892482639)) .-
               (2453750.5, 0.8921006945555555556)) .<= 1e-12)

@test all(abs.(values(SOFA.tcbtdb(2453750.5, 0.893019599)) .-
               (2453750.5, 0.8928551362746343397)) .<= 1e-12)

@test all(abs.(values(SOFA.tcgtt(2453750.5, 0.892862531)) .-
               (2453750.5, 0.8928551387488816828)) .<= 1e-12)

@test all(abs.(values(SOFA.tdbtcb(2453750.5, 0.892855137)) .-
               (2453750.5, 0.8930195997253656716)) .<= 1e-12)

@test all(abs.(values(SOFA.tdbtt(2453750.5, 0.892855137, -0.000201)) .-
               (2453750.5, 0.8928551393263888889)) .<= 1e-12)

@test SOFA.tttai(2453750.5, 0.892482639) isa NamedTuple{(:day, :fraction)}

@test all(abs.(values(SOFA.tttai(2453750.5, 0.892482639)) .-
               (2453750.5, 0.892110139)) .<= 1e-12)

@test all(abs.(values(SOFA.tttcg(2453750.5, 0.892482639)) .-
               (2453750.5, 0.8924900312508587113)) .<= 1e-12)

@test all(abs.(values(SOFA.tttdb(2453750.5, 0.892855139, -0.000201)) .-
               (2453750.5, 0.8928551366736111111)) .<= 1e-12)

@test all(abs.(values(SOFA.ttut1(2453750.5, 0.892855139, 64.8499)) .-
               (2453750.5, 0.8921045614537037037)) .<= 1e-12)

@test all(abs.(values(SOFA.ut1tai(2453750.5, 0.892104561, -32.6659)) .-
               (2453750.5, 0.8924826385462962963)) .<= 1e-12)

@test all(abs.(values(SOFA.ut1tt(2453750.5, 0.892104561, 64.8499)) .-
               (2453750.5, 0.8928551385462962963)) .<= 1e-12)

@test all(abs.(values(SOFA.ut1utc(2453750.5, 0.892104561, 0.3341)) .-
               (2453750.5, 0.8921006941018518519)) .<= 1e-12)

@test all(abs.(values(SOFA.utctai(2453750.5, 0.892100694)) .-
               (2453750.5, 0.8924826384444444444)) .<= 1e-12)

@test all(abs.(values(SOFA.utctai(SOFA.MJD0, SOFA.MJD00)) .-
               (2400000.5, 51544.50037037037)) .<= 1e-12)

@test all(abs.(values(SOFA.utcut1(2453750.5, 0.892100694, 0.3341)) .-
                      (2453750.5, 0.8921045608981481481)) .<= 1e-12)

# Test additional methods
@test all(isapprox.(values(SOFA.utctai(2_451_555)|>SOFA.taiut1(-31.5)),
                    values(SOFA.utcut1(2_451_555, 0.5)); atol=1e-12))

@test all(isapprox.(values(SOFA.utctai(2_451_555)|>SOFA.taiutc),
                    (2_451_555.0, 0.0); atol=1e-12))

####    Regression tests (v2.0.0 pre-release review)    ####

#   dtf2d: seclim and the day-length change were undefined for any
#   non-UTC scale
@test all(isapprox.(values(SOFA.dtf2d("TAI", 1994, 6, 30, 12, 5, 2.0)),
                    (2449533.5, 0.5034953703703704); atol=1e-12))

#   dtf2d: time past the end of day is a warning, not an error
@test_logs (:warn, r"after end of day") SOFA.dtf2d("TAI", 1994, 6, 30, 23, 59, 60.5)

#   tcbtdb: the low-order branch used day1 where the C uses day2
@test abs(sum(SOFA.tcbtdb(0.893019599, 2453750.5)) -
          (2453750.5 + 0.8928551362746343397)) <= 1e-9

#   ut1utc: the leap-second scan and the result assembly used the wrong
#   part when the small part comes first; order must be preserved
let u = SOFA.ut1utc(0.892104561, 2453750.5, 0.3341)
    @test u.fraction == 2453750.5
    @test abs(u.day - 0.8921006941018518935) <= 1e-12
end

#   dat: month/day are validated for post-1972 dates too
@test_throws AssertionError SOFA.dat(2000, 13, 1, 0.0)
@test_throws AssertionError SOFA.dat(2000, 4, 31, 0.0)

#   dat: the pre-1972 drift path uses the corrected cal2jd
#   (1.4228180 + 1 day of 0.001296 s/day drift)
@test abs(SOFA.dat(1961, 1, 2, 0.0) - 1.424114) <= 1e-9

#   d2dtf: rounding to 10s or coarser on a leap-second day goes up to
#   the next day
let d = SOFA.dtf2d("UTC", 2016, 12, 31, 23, 59, 57.0)
    @test all(values(SOFA.d2dtf("UTC", -1, d...)) .== (2017, 1, 1, 0, 0, 0, 0))
    @test all(values(SOFA.d2dtf("UTC", 0, d...)) .== (2016, 12, 31, 23, 59, 57, 0))
end
