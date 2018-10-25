"""
Heat transfer coefficients.

* [`therm_cond_dryair`](@ref)
* [`heat_cap_dryair`](@ref)
* [`therm_cond_vapor`](@ref)
* [`heat_cap_vapor`](@ref)
* [`therm_cond_moistair`](@ref)
* [`heat_cap_moistair`](@ref)
* [`heat_cap_mass_moistair`](@ref)
* [`therm_diff_moistair`](@ref)
* [`prandtl`](@ref)

# References

* [T08] Tsilingiris, P. T. (2008). Thermophysical and transport properties of
  humid air at temperature range between 0 and 100°C. *Energy Conversion and
  Management*, 49(5), 1098--1110.
  <https://doi.org/10.1016/j.enconman.2007.09.015>
"""
module Heat

include("../docstring_style.jl")

using Canopy.Constants: T_0, M_w, M_d
using Canopy.Water: vapor_mole_frac
using Canopy.Air: air_density
using Canopy.Transfer.Momentum: dyn_visc_moistair, viscosity_interaction_terms

export therm_cond_dryair,
    heat_cap_dryair,
    therm_cond_vapor,
    heat_cap_vapor,
    therm_cond_moistair,
    heat_cap_moistair,
    heat_cap_mass_moistair,
    therm_diff_moistair,
    prandtl

# == dry air ==

"""
Calculate the thermal conductivity of dry air [W m^-1 K^-1] from temperature
[K]. Applicable between 250 and 1050 K.
"""
therm_cond_dryair(temp) = @evalpoly(
    temp, -2.276501e-3, 1.2598485e-4, -1.4815235e-7,
    1.73550646e-10, -1.066657e-13, 2.47663035e-17)

"""
Calculate the isobaric heat capacity of dry air [J mol^-1 K^-1] from
temperature [K]. Applicable between 250 and 1050 K.
"""
heat_cap_dryair(temp) = @evalpoly(
    temp, 1.03409, -0.284887e-3, 0.7816818e-6,
    -0.4970786e-9, 0.1077024e-12) * 1e3 * M_d

# == water vapor ==

"""
Calculate the themal conductivity of water vapor [W m^-1 K^-1] from temperature
[K]. Applicable between 273 and 393 K.
"""
therm_cond_vapor(temp) = @evalpoly(
    temp - T_0,  # <- the empirical eqn takes Celsius values
    1.761758242e-2, 5.558941059e-5, 1.663336663e-7)

"""
Calculate the isobaric heat capacity of water vapor [J mol^-1 K^-1] from
temperature [K]. Applicable between 273 and 393 K.
"""
heat_cap_vapor(temp) = @evalpoly(
    temp - T_0,  # <- the empirical eqn takes Celsius values
    1.86910989, -2.578421578e-4, 1.941058941e-5) * 1e3 * M_w

# == moist air ==

"""
Calculate the thermal conductivity of moist air [W m^-1 K^-1] from temperature
[K], pressure [Pa], and relative humidity [0--1].
"""
function therm_cond_moistair(temp, pressure, RH)
    x_w = vapor_mole_frac(temp, pressure, RH)
    kappa_d = therm_cond_dryair(temp)
    kappa_w = therm_cond_vapor(temp)
    phi_dw, phi_wd, _, _ = viscosity_interaction_terms(temp)
    return (1. - x_w) * kappa_d / ((1. - x_w) + x_w * phi_dw) +
        x_w * kappa_w / (x_w + (1. - x_w) * phi_wd)
end

"""
Calculate the isobaric heat capacity of moist air [J mol^-1 K^-1] from
temperature [K], pressure [Pa], and relative humidity [0--1].
"""
function heat_cap_moistair(temp, pressure, RH)
    cp_d = heat_cap_dryair(temp)
    cp_w = heat_cap_vapor(temp)
    x_w = vapor_mole_frac(temp, pressure, RH)
    return (1. - x_w) * cp_d + x_w * cp_w
end

"""
Calculate the isobaric heat capacity (per unit mass) of moist air [J kg^-1
K^-1] from temperature [K], pressure [Pa], and relative humidity [0--1].
"""
function heat_cap_mass_moistair(temp, pressure, RH)
    cp_d = heat_cap_dryair(temp)
    cp_w = heat_cap_vapor(temp)
    x_w = vapor_mole_frac(temp, pressure, RH)
    return ((1. - x_w) * cp_d + x_w * cp_w) / ((1. - x_w) * M_d + x_w * M_w)
end

"""
Calculate the thermal diffusivity of moist air [m^2 s^-1] from temperature [K],
pressure [Pa], and relative humidity [0--1].
"""
function therm_diff_moistair(temp, pressure, RH)
    rho_a = air_density(temp, pressure, RH)
    # isobaric specific heat capacity (per unit mass) of moist air
    cpm_a = heat_cap_mass_moistair(temp, pressure, RH)  # [J kg^-1 K^-1]
    return therm_cond_moistair(temp, pressure, RH) / (rho_a * cpm_a)
end

"""
Calculate the Prandtl number of moist air from temperature [K], pressure [Pa],
and relative humidity [0--1].
"""
prandtl(temp, pressure, RH) = dyn_visc_moistair(temp, pressure, RH) *
    heat_cap_mass_moistair(temp, pressure, RH) /
    therm_cond_moistair(temp, pressure, RH)

end  # module
