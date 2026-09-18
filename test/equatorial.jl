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
