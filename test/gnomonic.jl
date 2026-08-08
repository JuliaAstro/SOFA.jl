####    Test Astronomy Gnomonic    ####

@test all(abs.(values(SOFA.tpors(-0.03, 0.07, 1.3, 1.5)) .-
               (1.736621577783208748, 1.436736561844090323,
                4.004971075806584490, 1.565084088476417917)) .<= 1e-13)

@test all(abs.(SOFA.tporv(-0.03, 0.07, SOFA.s2c(1.3, 1.5)).v01 .-
               [-0.02206252822366888610, 0.1318251060359645016, 0.9910274397144543895]) .<= 1e-13) &&
      all(abs.(SOFA.tporv(-0.03, 0.07, SOFA.s2c(1.3, 1.5)).v02 .-
               [-0.003712211763801968173, -0.004341519956299836813, 0.9999836852110587012]) .<= 1e-13)

@test all(abs.(values(SOFA.tpsts(-0.03, 0.07, 2.3, 1.5)) .-
               (0.7596127167359629775, 1.540864645109263028)) .<= 1e-13)

@test all(abs.(SOFA.tpstv(-0.03, 0.07, SOFA.s2c(2.3, 1.5)) .-
               [0.02170030454907376677, 0.02060909590535367447, 0.9995520806583523804]) .<= 1e-12)

@test all(abs.(values(SOFA.tpxes(1.3, 1.55, 2.3, 1.5)) .-
               (-0.01753200983236980595, 0.05962940005778712891)) .<= 1e-13)

@test all(abs.(values(SOFA.tpxev(SOFA.s2c(1.3, 1.55), SOFA.s2c(2.3, 1.5))) .-
               (-0.01753200983236980595, 0.05962940005778712891)) .<= 1e-13)

####    Regression tests (v2.0.0 pre-release review)    ####

#   tpors: near-pole sanity check, hand-derived from the spherical triangle
#   (the exact ξ = 0, w = 0 degenerate branch is unreachable in floating
#   point, since cos(b) is never exactly zero)
let rt = SOFA.tpors(0.0, 0.07, 2.3, pi/2), r = sqrt(1.0 + 0.07^2)
    @test rt.a01 ≈ 2.3
    @test rt.b01 ≈ atan(r, r*0.07)
end
