####    Test Astronomy Horizontal-Equatorial    ####

@test all(
    abs.(
        values(SOFA.ae2hd(5.5, 1.1, 0.7)) .-
            (0.5933291115507309663, 0.961393476164781762)
    ) .<= 1.0e-13
)

@test all(
    abs.(
        values(SOFA.hd2ae(1.1, 1.2, 0.3)) .-
            (5.916889243730066194, 0.4472186304990486228)
    ) .<= 1.0e-13
)

@test abs.(SOFA.hd2pa(1.1, 1.2, 0.3) .- 1.90622742800199558) .<= 1.0e-13

####    Regression tests (v2.0.0 pre-release review)    ####

#   hd2pa: hour angle zero (sqsz == 0) threw a TypeError
@test SOFA.hd2pa(0.0, 0.3, 0.5) == 0.0
@test abs(SOFA.hd2pa(0.0, 0.5, 0.3) - pi) <= 1.0e-13

####    Regression tests (issue #46: generic argument types)    ####

#   ae2hd, hd2ae, hd2pa: the degenerate branches returned a Float64 literal
@test SOFA.ae2hd(big"0.0", big"0.0", big"0.0")[1] isa BigFloat
@test SOFA.hd2ae(big"0.0", big"0.0", big"0.0").azi isa BigFloat
@test SOFA.hd2pa(big"0.0", big"0.0", big"0.0") isa BigFloat
