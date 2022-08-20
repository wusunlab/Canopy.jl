module TestLeaf

using Test
using Dates: DateTime
using Canopy.Constants
using Canopy.Leaf.Transpiration

@time @testset "Canopy.Leaf.Transpiration" begin
    @test isapprox(leaf_vapor_deficit(293.15, 290.15, 0.7), 300.4; rtol=1e-4)
    @test isapprox(total_cond_vapor(1.0, 0.25), 0.2)
    @test isapprox(transpiration(atm, 0.01 * atm, 1.0, 0.25), 2e-3)
end

end  # module
