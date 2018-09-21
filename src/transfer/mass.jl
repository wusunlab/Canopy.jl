"""
Mass transfer coefficients.

- [`diffus_air`](@ref)
- [`diffus_water`](@ref)
- [`diffus_soil_air`](@ref)
- [`diffus_soil_water`](@ref)
- [`diffus_soil`](@ref)

# References

## Diffusivity in air

- [M98] Massman, W. J. (1998). A review of the molecular diffusivities of
  H2O, CO2, CH4, CO, O3, SO2, NH3, N2O, NO, and NO2 in air, O2 and N2 near STP.
  *Atmos. Environ.*, 32(6), 1111--1127.
  <https://doi.org/10.1016/S1352-2310(97)00391-9>
- [S10] Seibt, U. et al. (2010). A kinetic analysis of leaf uptake of COS
  and its relation to transpiration, photosynthesis and carbon isotope
  fractionation. *Biogeosci.*, 7, 333--341.
  <https://doi.org/10.5194/bg-7-333-2010>

## Diffusivity in water

- [J87] Jähne, B. et al. (1987). Measurement of the diffusion
  coefficients of sparingly soluble gases in water. *J. Geophys. Res.*,
  92(C10), 10767--10776. <https://doi.org/10.1029/JC092iC10p10767>
- [WH68] Wise, D. L. and Houghton, G. (1968). Diffusion coefficients of
  neon, krypton, xenon, carbon monoxide and nitric oxide in water at 10-6O C.
  *Chem. Eng. Sci.*, 23, 1211--1216.
  <https://doi.org/10.1016/0009-2509(68)89029-3>
- [UFUA96] Ulshöfer, V. S., Flöck, O. R., Uher, G., and Andreae, M. O.
  (1996). Photochemical production and air-sea exchange of sulfide in the
  eastern Mediterranean Sea. *Mar. Chem.*, 53, 25--39.
  <https://doi.org/10.1016/0304-4203(96)00010-2>

## Diffusivity in soil air and water

- [CH78] Clapp, R. B. and Hornberger, G. M. (1978). Empirical equations
  for some soil hydraulic properties. *Water Resources Res.*, 14(4), 601--604.
  <https://doi.org/10.1029/WR014i004p00601>
- [M03] Moldrup, P., Olesen, T., Komatsu, T, Yoshikawa, S, Schjønning, P, and
  Rolston, D. E. (2003). Modeling diffusion and reaction in soils: X. A
  unifying model for solute and gas diffusivity in unsaturated soil. *Soil
  Sci.*, 168(5), 321--337. <https://doi.org/10.1097/01.ss.0000070907.55992.3c>
"""
module Mass

include("../docstring_style.jl")

using Canopy.Constants: R, atm, T_0

export diffus_air,
    diffus_water,
    diffus_soil_air,
    diffus_soil_water,
    diffus_soil

"""Gas diffusivity in air under STP condition [m^2 s^-1]."""
const diffus_air_stp = Dict{String, Float64}(
    "h2o" => 2.178e-5,
    "co2" => 1.381e-5,
    "ch4" => 1.952e-5,
    "co" => 1.807e-5,
    "so2" => 1.089e-5,
    "o3" => 1.444e-5,
    "nh3" => 1.978e-5,
    "n2o" => 1.436e-5,
    "no" => 1.802e-5,
    "no2" => 1.361e-5,
    "n2" => 1.788e-5,
    "o2" => 1.820e-5,
    "cos" => 1.381e-5 / 1.21)

"""
Pre-exponential factor and activation energy for the calculation of gas
diffusivity in water [m^2 s^-1] under STP condition.
"""
const diffus_water_stp = Dict{String, Tuple{Float64, Float64}}(
    "he" => (818e-9, 11.70e3),
    "ne" => (1608e-9, 14.84e3),
    "kr" => (6393e-9, 20.20e3),
    "xe" => (9007e-9, 21.61e3),
    "rn" => (15877e-9, 23.26e3),
    "h2" => (3338e-9, 16.06e3),
    "ch4" => (3047e-9, 18.36e3),
    "co2" => (5019e-9, 19.51e3),
    "cos" => (4.735872481253359e-6, 19336.20405260121),
    "co" => (0.407e-4, 24518.24),
    "no" => (39.8e-4, 34978.24))

# note: this shall be moved to a soil module once it is started
"""Clapp--Hornberger shape parameters for tortuosity effect."""
const soil_shape_params = Dict{String, Float64}(
    "sand" => 4.05,
    "loamy sand" => 4.38,
    "sandy loam" => 4.9,
    "silt loam" => 5.30,
    "loam" => 5.39,
    "sandy clay loam" => 7.12,
    "silty clay loam" => 7.75,
    "clay loam" => 8.52,
    "sandy clay" => 10.4,
    "silty clay" => 10.4,
    "clay" => 11.4)

"""
Calculate the diffusivity of a gas in air [m^2 s^-1] from temperature [K] and
pressure [Pa].

Support gas species including H2O, CO2, CH4, CO, SO2, O3, NH3, N2O, NO, NO2,
N2, O2, and COS. Note that the `species` argument must be in all lower case.

# See also

[`diffus_soil_air`](@ref)
"""
function diffus_air(species::String, temp, pressure=atm)
    if !haskey(diffus_air_stp, species)
        throw(ArgumentError("species \"$species\" not supported"))
    else
        return diffus_air_stp[species] * (atm / pressure) * (temp / T_0)^1.81
    end
end

"""
Calculate the diffusivity of a gas in water [m^2 s^-1] from temperature [K].

Support gas species including He, Ne, Kr, Xe, Rn, H2, CH4, CO2, CO, NO, and
COS. Note that the `species` argument must be in all lower case.

# See also

[`diffus_soil_water`](@ref)
"""
function diffus_water(species::String, temp)
    if !haskey(diffus_water_stp, species)
        throw(ArgumentError("species \"$species\" not supported"))
    else
        preexp, E_act = diffus_water_stp[species]
        return preexp * exp(-E_act / (R * temp))
    end
end

"""
Calculate the diffusivity of a gas in soil air [m^2 s^-1]. Support gas species
including H2O, CO2, CH4, CO, SO2, O3, NH3, N2O, NO, NO2, N2, O2, and COS.

# Arguments

- `species`: Chemical name of the gas species to be evaluated. In lower case.
- `texture`: Soil texture name in lower case.
- `temp`: Temperature [K].
- `theta_sat`: Total porosity of the soil [m^3 m^-3].
- `theta_w`: Water-filled porosity of the soil [m^3 m^-3].
- `pressure` (*optional*): Ambient pressure [Pa]. Default is the standard
  atmospheric pressure.

# See also

- [`diffus_air`](@ref)
- [`diffus_soil_water`](@ref)
- [`diffus_soil`](@ref)
"""
function diffus_soil_air(species::String, texture::String, temp, theta_sat,
                         theta_w, pressure=atm)
    if !haskey(soil_shape_params, texture)
        throw(ArgumentError("soil texture \"$texture\" not supported"))
    else
        theta_a = theta_sat - theta_w
        tau_a = theta_a * (theta_a / theta_sat) ^
            (3. / soil_shape_params[texture])  # tortuosity in soil air
        return diffus_air(species, temp, pressure) * theta_a * tau_a
    end
end

"""
Calculate the diffusivity of a gas in soil water [m^2 s^-1]. Support gas
species including He, Ne, Kr, Xe, Rn, H2, CH4, CO2, CO, NO, and COS.

# Arguments

- `species`: Chemical name of the gas species to be evaluated. In lower case.
- `texture`: Soil texture name in lower case.
- `temp`: Temperature [K].
- `theta_sat`: Total porosity of the soil [m^3 m^-3].
- `theta_w`: Water-filled porosity of the soil [m^3 m^-3].

# See also

- [`diffus_water`](@ref)
- [`diffus_soil_air`](@ref)
- [`diffus_soil`](@ref)
"""
function diffus_soil_water(species::String, texture::String, temp, theta_sat,
                           theta_w)
    if !haskey(soil_shape_params, texture)
        throw(ArgumentError("soil texture \"$texture\" not supported"))
    else
        tau_w = theta_w * (theta_w / theta_sat) ^
            (soil_shape_params[texture] / 3. - 1.)  # tortuosity in soil water
        return diffus_water(species, temp) * theta_w * tau_w
    end
end

"""
Calculate the total diffusivity of a gas in soil gaseous and aqueous phases
[m^2 s^-1]. Supporting gas species including CO2, CO, NO, CH4, and COS.

# Arguments

- `species`: Chemical name of the gas species to be evaluated. In lower case.
- `texture`: Soil texture name in lower case.
- `temp`: Temperature [K].
- `theta_sat`: Total porosity of the soil [m^3 m^-3].
- `theta_w`: Water-filled porosity of the soil [m^3 m^-3].
- `pressure` (*optional*): Ambient pressure [Pa]. Default is the standard
  atmospheric pressure.

# See also

- [`diffus_soil_air`](@ref)
- [`diffus_soil_water`](@ref)
"""
function diffus_soil(species::String, texture::String, temp, theta_sat,
                     theta_w, pressure=atm)
    if !haskey(soil_shape_params, texture)
        throw(ArgumentError("soil texture \"$texture\" not supported"))
    end

    if !haskey(diffus_air_stp, species) || !haskey(diffus_water_stp, species)
        throw(ArgumentError("species \"$species\" not supported"))
    end

    return diffus_soil_water(species, texture, temp, theta_sat, theta_w) +
        diffus_soil_air(species, texture, temp, theta_sat, theta_w, pressure)
end

end  # module
