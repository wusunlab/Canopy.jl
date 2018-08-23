module TestWater

using Test
using LinearAlgebra
using Canopy.Constants
using Canopy.Water

rho_w_validat = hcat(
    [0., 4., 5., 10., 15., 20., 25., 30.] .+ T_0,
    [999.8395, 999.9720, 999.96, 999.7026, 999.1026,
     998.2071, 997.0479, 995.6502])
pK_w_validat = hcat(
    collect(0:25:100) .+ T_0,
    [14.95, 13.99, 13.26, 12.70, 12.25])

@time @testset "Canopy.Water" begin
    @test norm(water_density.(rho_w_validat[:, 1]) -
               rho_w_validat[:, 2]) / norm(rho_w_validat[:, 2]) < 1e-4
    @test norm(water_dissoc.(pK_w_validat[:, 1]) - pK_w_validat[:, 2]) /
        norm(pK_w_validat[:, 2]) < 1e-3
end

end  # module
