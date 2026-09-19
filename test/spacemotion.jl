####    Test Astronomy Space Motion    ####

@test all(
    abs.(
        values(
            SOFA.pvstar(
                [
                    [126668.5912743160601, 2136.792716839935195, -245251.2339876830091],
                    [-0.4051854035740712739e-2, -0.6253919754866173866e-2, 0.1189353719774107189e-1],
                ]
            )
        ) .-
            (
            0.1686756e-1, -1.093989828, -0.1783235160000472788e-4,
            0.2336024047000619347e-5, 0.74723, -21.6000001010730601,
        )
    ) .<= [1.0e-12, 1.0e-12, 1.0e-16, 1.0e-16, 1.0e-12, 1.0e-11]
)

@test all(
    abs.(
        SOFA.starpv(
            0.01686756, -1.093989828, -1.78323516e-5,
            2.336024047e-6, 0.74723, -21.6
        )[1] .-
            [126668.5912743160601, 2136.792716839935195, -245251.2339876830091]
    ) .<= [1.0e-10, 1.0e-12, 1.0e-10]
)

@test all(
    abs.(
        SOFA.starpv(
            0.01686756, -1.093989828, -1.78323516e-5,
            2.336024047e-6, 0.74723, -21.6
        )[2] .-
            [-0.4051854008955659551e-2, -0.625391975441477797e-2, 0.1189353714588109341e-1]
    ) .<= [1.0e-13, 1.0e-15, 1.0e-13]
)

####    Regression tests (v2.0.0 pre-release review)    ####

#   pvstar: superluminal velocity and null position are rejected
#   (the sanity check had inverted logic)
@test_throws AssertionError SOFA.pvstar([[1.0e5, 0.0, 0.0], [200.0, 0.0, 0.0]])
@test_throws AssertionError SOFA.pvstar([[0.0, 0.0, 0.0], [1.0e-5, 0.0, 0.0]])

####    Regression tests (issue #46: generic argument types)    ####

#   starpv: the velocity was written into an MVector in place, which
#   StaticArrays does not support for non-isbits element types (BigFloat)
let args = (0.01686756, -1.093989828, -1.78323516e-5, 2.336024047e-6, 0.74723, -21.6)
    pvF, pvB = SOFA.starpv(args...), SOFA.starpv(big.(args)...)
    @test eltype(pvB[1]) == BigFloat && eltype(pvB[2]) == BigFloat
    @test all(abs.(pvB[1] .- pvF[1]) .<= 1.0e-14 .* abs.(pvF[1]))
    @test all(abs.(pvB[2] .- pvF[2]) .<= 1.0e-14 .* abs.(pvF[2]))
end

#   starpv: below the minimum parallax the Float64 constant replaced a BigFloat
@test eltype(SOFA.starpv(0.1, 0.2, 1.0e-6, 1.0e-6, big"1.0e-8", 10.0)[1]) == BigFloat
