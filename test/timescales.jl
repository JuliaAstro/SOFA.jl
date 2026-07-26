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
