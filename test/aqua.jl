@testset "Aqua" begin
    using SOFA, Aqua
    Aqua.test_all(SOFA)
end

####    Regression tests (v2.0.0 pre-release review)    ####

#   numat and the public argument types are exported
@test Base.isexported(SOFA, :numat)
@test Base.isexported(SOFA, :Astrom)
@test Base.isexported(SOFA, :Ldbody)
