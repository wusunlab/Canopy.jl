module TestConstants

using Test
using Canopy.Constants

"""Read CODATA 2014 physical constants table."""
function read_codata(filename)
    codata_constants = Dict{String, Float64}()
    codata_raw = open(readlines, filename)
    for line in codata_raw[eachindex(codata_raw)[10:end]]
        if length(line) < 85
            break
        end
        key = strip(line[1:59])
        val = parse(Float64, replace(line[61:85], r"(\s+|\.\.\.)" => ""))
        push!(codata_constants, key => val)
    end
    return codata_constants
end

codata_constants = read_codata((@__DIR__) * "/assets/codata/codata2014.txt")

validation_pairs = [
    (c, codata_constants["speed of light in vacuum"]),
    (h, codata_constants["Planck constant"]),
    (N_A, codata_constants["Avogadro constant"]),
    (k_B, codata_constants["Boltzmann constant"]),
    (sigma_SB, codata_constants["Stefan-Boltzmann constant"]),
    (c_1, codata_constants["first radiation constant"]),
    (c_1L, codata_constants["first radiation constant for spectral radiance"]),
    (c_2, codata_constants["second radiation constant"]),
    (R, codata_constants["molar gas constant"]),
    (g, codata_constants["standard acceleration of gravity"]),
    (atm, codata_constants["standard atmosphere"]),
    (T_0, 273.15),
    (kappa, 0.4),
    (M_w, 18.015e-3),
    (M_d, 28.965e-3)]

@time @testset "Canopy.Constants" begin
    for (val1, val2) in validation_pairs
        @test isapprox(val1, val2, rtol=1e-3)
    end
end

end  # module
