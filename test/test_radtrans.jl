module TestRadTrans

using Test
using Dates: DateTime
using Canopy.RadTrans.Blackbody
using Canopy.RadTrans.Solar

@time @testset "Canopy.RadTrans.Blackbody" begin
    # ephoton
    @test isapprox(ephoton(450e-9), 4.414e-19, rtol=1e-3)  # blue
    @test isapprox(ephoton(700e-9), 2.838e-19, rtol=1e-3)  # red
    # energy2photon
    @test isapprox(energy2photon(600, 0.5e-6), 2508e-6, rtol=1e-3)
    # planck
    @test isapprox(planck(500e-9, 5772), 2.624e13, rtol=1e-3)  # sun
    @test isapprox(planck(10e-6, 288), 8.114e6, rtol=1e-3)  # earth
    # stefan_boltzmann
    @test isapprox(stefan_boltzmann(5772), 6.294e7, rtol=1e-3)  # sun
    @test isapprox(stefan_boltzmann(255), 239.8, rtol=1e-3)  # earth
    # blackbody_temp
    @test isapprox(blackbody_temp(240), 255, rtol=1e-3)  # earth
    @test isapprox(blackbody_temp(149.6), 226.6, rtol=1e-3)  # venus
end

@time @testset "Canopy.RadTrans.Solar" begin
    # eccentricity
    @test isapprox(eccentricity(-1), 0.01712, rtol=1e-3)  # 1000 AD
    @test isapprox(eccentricity(DateTime(1000)), eccentricity(-1), rtol=1e-6)
    @test isapprox(eccentricity(1), 0.01627, rtol=1e-3)  # 3000 AD
    @test isapprox(eccentricity(DateTime(3000)), eccentricity(1), rtol=1e-6)

    # atmospheric_refraction
    @test atmospheric_refraction(89.) == 0.0
    angle = 40.
    # compare with a simpler approximation by Bennett (1982) J. Navigat.
    # accuracy = 0.1 arcmin
    @test isapprox(atmospheric_refraction(angle),
                   cotd(angle + 7.31 / (angle + 4.4)) / 60., atol=0.1 / 60.)

    # solar_angle
    solar_angle_result = solar_angle(
        DateTime(2018, 9, 20, 12), 34.069444, -118.445278, -7)
    sunrise = solar_angle_result["sunrise"]
    sunset = solar_angle_result["sunset"]
    @test isapprox(Solar.partial_day(DateTime(2018, 9, 20, 6, 40)),
                   sunrise, atol=2. / 1440.)  # tolerance = 2 min
    @test isapprox(Solar.partial_day(DateTime(2018, 9, 20, 18, 52)),
                   sunset, atol=2. / 1440.)  # tolerance = 2 min
end

end  # module
