"""
Momentum transfer coefficients.

# References

* [T08] Tsilingiris, P. T. (2008). Thermophysical and transport properties of
  humid air at temperature range between 0 and 100°C. *Energy Conversion and
  Management*, 49(5), 1098--1110.
  <https://doi.org/10.1016/j.enconman.2007.09.015>
"""
module Momentum

using Canopy.Constants: M_w, M_d
using Canopy.Water: vapor_mole_frac

include("../docstring_style.jl")

export dyn_visc_dryair,
    dyn_visc_vapor,
    dyn_visc_moistair

"""
Calculate the dynamic viscosity of dry air [kg m^-1 s^-1] from temperature [K].

Applicable between 250 and 600 K. The influence of pressure is negligible when
pressure < a few MPa.
"""
dyn_visc_dryair(temp) = @evalpoly(
    temp, -9.8601e-1, 9.080125e-2, -1.17635575e-4,
    1.2349703e-7, -5.7971299e-11) * 1e-6

"""
Calculate the dynamic viscosity of water vapor [kg m^-1 s^-1] from temperature
[K].

Applicable between 273 and 393 K. The influence of pressure is negligible when
pressure < a few MPa.
"""
dyn_visc_vapor(temp) = -2.869368957406498e-06 + 4.000549451e-8 * temp

"""
Calculate viscosity interaction terms from temperature [K]. This is a helper
function for calculating moist air properties.
"""
function viscosity_interaction_terms(temp)
    # `_d` - dry air; `_w` - water vapor
    M_dw = M_d / M_w
    M_wd = M_w / M_d
    mu_d = dyn_visc_dryair(temp)
    mu_w = dyn_visc_vapor(temp)
    # interaction coefficients
    phi_dw = sqrt(2.) * 0.25 * (1. + M_dw) ^ -0.5 *
        (1. + sqrt(mu_d / mu_w) * M_wd^0.25) ^ 2.
    phi_wd = sqrt(2.) * 0.25 * (1. + M_wd) ^ -0.5 *
        (1. + sqrt(mu_w / mu_d) * M_dw^0.25) ^ 2.
    return phi_dw, phi_wd, mu_d, mu_w
end

"""
Calculate the dynamic viscosity of moist air [kg m^-1 s^-1] from temperature
[K], pressure [Pa], and relative humidity [0--1].
"""
function dyn_visc_moistair(temp, pressure, RH)
    x_w = vapor_mole_frac(temp, pressure, RH)
    phi_dw, phi_wd, mu_d, mu_w = viscosity_interaction_terms(temp)
    return (1. - x_w) * mu_d / ((1. - x_w) + x_w * phi_dw) +
        x_w * mu_w / (x_w + (1. - x_w) * phi_wd)
end

end  # module
