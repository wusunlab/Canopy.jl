"""
Leaf energy balance.

* [`bl_cond_heat`](@ref)
* [`bl_cond_vapor`](@ref)
* [`PAR_to_shortwave`](@ref)
* [`sensible_heat`](@ref)
* [`leaf_vapor_deficit`](@ref)
* [`latent_heat`](@ref)
* [`energy_imbalance`](@ref)

# References

## Leaf boundary layer conductances

* Campbell, G. S. & Norman, J. M. (1998). _An Introduction to Environmental
  Biophysics_ (2nd ed., pp. 99--101). Springer, New York.
* Bonan, G. (2008). _Ecological Climatology: Concepts and Applications_ (2nd
  ed., pp. 229--232). Cambridge University Press.

## Relationship between PAR and shortwave radiation

* Meek, D. W., Hatfield, J. L., Howell, T. A., Idso, S. B., & Reginato, R. J.
  (1984). A generalized relationship between photosynthetically active
  radiation and solar radiation. _Agronomy Journal_, 76(6), 939--945.
  <https://doi.org/10.2134/agronj1984.00021962007600060018x>
"""
module EnergyBalance

include("../docstring_style.jl")

using Canopy.Water: e_sat, latent_heat_vap
using Canopy.Air: air_molar, air_density
using Canopy.RadTrans: stefan_boltzmann
using Canopy.Transfer:
    dyn_visc_moistair,
    prandtl,
    therm_diff_moistair,
    diffus_air,
    heat_cap_moistair
using Canopy.Leaf.Transpiration: transpiration

export bl_cond_heat,
    bl_cond_vapor,
    PAR_to_shortwave,
    sensible_heat,
    leaf_vapor_deficit,
    latent_heat,
    energy_imbalance

"""
Calculate leaf boundary layer conductance for heat transfer
(``g_\\mathrm{b,H}``) [mol m^-2 s^-1].

```math
g_\\mathrm{b,H}
= \\frac{1.4\\,\\mathrm{Nu}\\cdot \\chi_\\mathrm{a}\\cdot D_\\mathrm{H}}{d}
```

where

* Nu = 0.664 Re``^{1/2}`` Pr``^{1/3}`` is the Nusselt number;
* ``\\chi_\\mathrm{a}`` [mol m^-3] is the molar concentration of air;
* ``D_\\mathrm{H}`` [m^2 s^-1] is the thermal diffusivity of air;
* The multiplier 1.4 is a correction factor for leaves in field conditions.

# Arguments

* `pressure`: Ambient pressure [Pa].
* `temp`: Air temperature [K].
* `rh`: Relative humidity [0--1].
* `wind_speed`: Wind speed [m s^-1].
* `d_leaf`: Characteristic leaf size [m].

# See also

[`bl_cond_vapor`](@ref)
"""
function bl_cond_heat(pressure, temp, rh, wind_speed, d_leaf)
    # kinematic viscosity of moist air [m^2 s^-1]
    nu_a =
        dyn_visc_moistair(temp, pressure, rh) / air_density(temp, pressure, rh)
    Pr = prandtl(temp, pressure, rh)
    air_conc = air_molar(temp, pressure)  # [mol m^-3]

    return 1.4 *
           0.664 *
           cbrt(Pr) *
           air_conc *
           therm_diff_moistair(temp, pressure, rh) *
           sqrt(wind_speed / (d_leaf * nu_a))
end

"""
Calculate leaf boundary layer conductance for water vapor transfer
(``g_\\mathrm{b,W}``).

```math
g_\\mathrm{b,W}
= \\frac{1.4\\cdot 0.664\\ \\mathrm{Re}^{1/2}\\
\\mathrm{Sc}^{1/3} \\cdot \\chi_\\mathrm{a} \\cdot D_\\mathrm{W}}{d}
```

where

* ``\\mathrm{Sc} = \\nu_\\mathrm{a} / D_\\mathrm{W}`` is the Schmidt number;
* ``\\nu_\\mathrm{a}`` [m^2 s^-1] is the kinematic viscosity of air;
* ``D_\\mathrm{W}`` [m^2 s^-1] is the diffusivity of water vapor in air;
* ``\\chi_\\mathrm{a}`` [mol m^-3] is the molar concentration of air;
* The multiplier 1.4 is a correction factor for leaves in field conditions.

# Arguments

* `pressure`: Ambient pressure [Pa].
* `temp`: Air temperature [K].
* `rh`: Relative humidity [0--1].
* `wind_speed`: Wind speed [m s^-1].
* `d_leaf`: Characteristic leaf size [m].

# See also

[`bl_cond_heat`](@ref)
"""
function bl_cond_vapor(pressure, temp, rh, wind_speed, d_leaf)
    # kinematic viscosity of moist air [m^2 s^-1]
    nu_a =
        dyn_visc_moistair(temp, pressure, rh) / air_density(temp, pressure, rh)
    D_w = diffus_air("h2o", temp, pressure)
    Sc = nu_a / D_w  # Schmidt number
    air_conc = air_molar(temp, pressure)  # [mol m^-3]

    return 1.4 *
           0.664 *
           cbrt(Sc) *
           air_conc *
           D_w *
           sqrt(wind_speed / (d_leaf * nu_a))
end

"""
Calculate the incoming shortwave radiation [W m^-2] from photosynthetically
active radiation (PAR) [µmol m^-2 s^-1]. The calculation is based on an
empirical equation fitted between PAR and shortwave radiation measured at
various sites in western US.
"""
PAR_to_shortwave(PAR) = 0.495785820525533 * PAR - 0.08081308874566188

"""
Calculate sensible heat transfer rate at the leaf surface [W m^-2].

```math
\\mathrm{SH} = 2 g_\\mathrm{b,H} \\cdot c_{p,\\mathrm{a}} \\cdot
    \\left( T_\\mathrm{leaf} - T_\\mathrm{air} \\right)
```

Note that both sides of a leaf are taken into account by the factor 2.

# Arguments

* `temp`: Air temperature [K].
* `temp_leaf`: Leaf temperature [K].
* `cp_a`: Molar heat capacity of the moist air [J K^-1 mol^-1].
* `g_bh`: Boundary layer conductance for heat transfer [mol m^-2 s^-1].
"""
function sensible_heat(temp, temp_leaf, cp_a, g_bh)
    2.0 * g_bh * cp_a * (temp_leaf - temp)
end

"""
Calculate leaf-to-air vapor pressure deficit [Pa].

# Arguments

* `temp`: Air temperature [K].
* `temp_leaf`: Leaf temperature [K].
* `rh`: Relative humidity [0--1].
"""
function leaf_vapor_deficit(temp, temp_leaf, rh)
    e_sat(temp_leaf) - e_sat(temp_air) * rh
end

"""
Calculate latent heat transfer rate at the leaf surface [W m^-2].

```math
\\mathrm{LE} = L_\\mathrm{v} \\cdot g_\\mathrm{tot,W} \\cdot
\\frac{\\mathrm{VPD}}{p_\\mathrm{atm}}
```

where ``L_\\mathrm{v}`` is the latent heat of vaporization of water [J mol^-1],
and ``g_\\mathrm{tot,W}`` is the total conductance of water vapor.

# Arguments

* `pressure`: Ambient pressure [Pa].
* `temp_leaf`: Leaf temperature [K].
* `vpd_leaf`: Leaf-to-air vapor pressure deficit [Pa].
* `g_bw`: Boundary layer conductance of water vapor [mol m^-2 s^-1].
* `g_sw`: Stomatal conductance of water vapor [mol m^-2 s^-1].
"""
function latent_heat(pressure, temp_leaf, vpd_leaf, g_bw, g_sw)
    transpiration(pressure, vpd_leaf, g_bw, g_sw) * latent_heat_vap(temp_leaf)
end

"""
Calculate the imbalance of energy transfer at the leaf surface [W m^-2]. This
function is used as a constraint for the coupled leaf temperature--flux solver.

# Arguments

* `pressure`: Ambient pressure [Pa].
* `temp`: Air temperature [K].
* `temp_leaf`: Leaf temperature [K].
* `rh`: Relative humidity [0--1].
* `R_sw`: Incoming shortwave radiation [W m^-2].
* `wind_speed`: Wind speed [m s^-1].
* `d_leaf`: Characteristic leaf size [m].
* `em_leaf`: Emissivity of leaf [0--1].
* `g_sw`: Stomatal conductance of water vapor [mol m^-2 s^-1].
"""
function energy_imbalance(
    pressure,
    temp,
    temp_leaf,
    rh,
    R_sw,
    wind_speed,
    d_leaf,
    em_leaf,
    g_sw,
)
    R_net = R_sw - em_leaf * stefan_boltzmann(temp_leaf)
    VPD_leaf = leaf_vapor_deficit(temp, temp_leaf, rh)
    cp_a = heat_cap_moistair(temp_leaf, pressure, RH)
    g_bh = bl_cond_heat(pressure, temp, rh, wind_speed, d_leaf)
    g_bw = bl_cond_vapor(pressure, temp, rh, wind_speed, d_leaf)
    SH = sensible_heat(temp, temp_leaf, cp_a, g_bh)
    LE = latent_heat(pressure, temp_leaf, vpd_leaf, g_bw, g_sw)

    R_net - SH - LE
end

end  # module
