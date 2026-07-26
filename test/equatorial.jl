####    Test Astronomy Horizontal-Equatorial    ####

@test all(abs.(values(SOFA.ae2hd(5.5, 1.1, 0.7)) .-
               (0.5933291115507309663, 0.9613934761647817620)) .<= 1e-13)

@test all(abs.(values(SOFA.hd2ae(1.1, 1.2, 0.3)) .-
               (5.916889243730066194, 0.4472186304990486228)) .<= 1e-13)

@test abs.(SOFA.hd2pa(1.1, 1.2, 0.3) .- 1.906227428001995580) .<= 1e-13
