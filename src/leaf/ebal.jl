"""
Leaf energy balance module.

* [`bl_cond_heat`](@ref)
* [`bl_cond_vapor`](@ref)
* [`PAR_to_shortwave`](@ref)
* [`sensible_heat`](@ref)
* [`leaf_vapor_deficit`](@ref)
* [`water_flux`](@ref)
* [`latent_heat`](@ref)
* [`energy_imbalance`](@ref)

# References

## Leaf boundary layer conductances

* [CN98] Campbell, G. S. and Norman, J. M. (1998). *An Introduction to
  Environmental Biophysics* (2nd ed.), pp. 99--101. Springer Science+Business
  Media, New York, NY, USA.
* [B08] Bonan, G. (2008). *Ecological Climatology: Concepts and Applications*,
  pp. 229--232. Cambridge University Press, Cambridge, UK.

## Relationship between PAR and shortwave radiation

* [MHH84] Meek, D. W., Hatfield, J. L., Howell, T. A., Idso, S. B., and
  Reginato, R. J. (1984). A generalized relationship between photosynthetically
  active radiation and solar radiation. *Agron. J.*, 76(6), 939--945.
  <https://doi.org/10.2134/agronj1984.00021962007600060018x>
"""
module EBal

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
using Canopy.Leaf.StomCond: total_cond_h2o  # TODO: TO BE IMPLEMENTED

export bl_cond_heat,
    bl_cond_vapor,
    PAR_to_shortwave,
    sensible_heat,
    leaf_vapor_deficit,
    water_flux,
    latent_heat,
    energy_imbalance

"""
Calculate leaf boundary layer conductance for heat transfer
(``g_\\mathrm{b,H}``) [mol m^-2 s^-1].

```math
g_\\mathrm{b,H} = \\frac{1.4\\,\\mathrm{Nu}\\cdot \\chi_\\mathrm{a}\\cdot
    D_\\mathrm{H}}{d}
```

where

* Nu = 0.664 Re``^{1/2}`` Pr``^{1/3}`` is the Nusselt number;
* ``\\chi_\\mathrm{a}`` [mol m^-3] is the molar concentration of air;
* ``D_\\mathrm{H}`` [m^2 s^-1] is the thermal diffusivity of air.

The multiplier 1.4 is a correction factor for leaves in field conditions.

# Arguments

* `temp`: Air temperature [K].
* `pressure`: Ambient pressure [Pa].
* `RH`: Relative humidity [0--1].
* `wind_speed`: Wind speed [m s^-1].
* `d_leaf`: Characteristic leaf size [m].

# See also

[`bl_cond_vapor`](@ref)
"""
function bl_cond_heat(temp, pressure, RH, wind_speed, d_leaf)
    # kinematic viscosity of moist air [m^2 s^-1]
    nu_a = dyn_visc_moistair(temp, pressure, RH) /
        air_density(temp, pressure, RH)
    Pr = prandtl(temp, pressure, RH)
    air_conc = air_molar(temp, pressure)  # [mol m^-3]

    return 1.4 * 0.664 * cbrt(Pr) * air_conc *
        therm_diff_moistair(temp, pressure, RH) *
        sqrt(wind_speed / (d_leaf * nu_a))
end

"""
Calculate leaf boundary layer conductance for water vapor transfer
(``g_\\mathrm{b,W}``).

```math
g_\\mathrm{b,W} = \\frac{1.4\\cdot 0.664\\ \\mathrm{Re}^{1/2}\\
    \\mathrm{Sc}^{1/3} \\cdot \\chi_\\mathrm{a} \\cdot D_\\mathrm{W}}{d}
```

where

* ``\\mathrm{Sc} = \\nu_\\mathrm{a} / D_\\mathrm{W}`` is the Schmidt number;
* ``\\nu_\\mathrm{a}`` [m^2 s^-1] is the kinematic viscosity of air;
* ``D_\\mathrm{W}`` [m^2 s^-1] is the diffusivity of water vapor in air;
* ``\\chi_\\mathrm{a}`` [mol m^-3] is the molar concentration of air.

The multiplier 1.4 is a correction factor for leaves in field conditions.

# Arguments

* `temp`: Air temperature [K].
* `pressure`: Ambient pressure [Pa].
* `RH`: Relative humidity [0--1].
* `wind_speed`: Wind speed [m s^-1].
* `d_leaf`: Characteristic leaf size [m].

# See also

[`bl_cond_heat`](@ref)
"""
function bl_cond_vapor(temp, pressure, RH, wind_speed, d_leaf)
    # kinematic viscosity of moist air [m^2 s^-1]
    nu_a = dyn_visc_moistair(temp, pressure, RH) /
        air_density(temp, pressure, RH)
    D_w = diffus_air("h2o", temp, pressure)
    Sc = nu_a / D_w  # Schmidt number
    air_conc = air_molar(temp, pressure)  # [mol m^-3]

    return 1.4 * 0.664 * cbrt(Sc) * air_conc * D_w *
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

* `T_leaf`: Leaf temperature [K].
* `T_air`: Air temperature [K].
* `cp_a`: Molar heat capacity of the moist air [J K^-1 mol^-1].
* `g_bh`: Boundary layer conductance for heat transfer [mol m^-2 s^-1].
"""
sensible_heat(T_leaf, T_air, cp_a, g_bh) = 2. * g_bh * cp_a * (T_leaf - T_air)

"""
Calculate leaf-to-air vapor pressure deficit [Pa].

# Arguments

* `T_leaf`: Leaf temperature [K].
* `T_air`: Air temperature [K].
* `RH`: Relative humidity [0--1].
"""
leaf_vapor_deficit(T_leaf, T_air, RH) = e_sat(T_leaf) - e_sat(T_air) * RH

"""
Calculate leaf water flux [mol m^-2 s^-1].

```math
F_\\mathrm{H_2O} = g_\\mathrm{tot,W} \\cdot
    \\frac{\\mathrm{VPD}}{p_\\mathrm{atm}}
```

where

```math
g_\\mathrm{tot,W} = \\frac{1}{g_\\mathrm{b,W}^{-1} + g_\\mathrm{s,W}^{-1}}
```

is the total conductance of water vapor [mol m^-2 s^-1].

# Arguments

* `VPD_leaf`: Leaf-to-air vapor pressure deficit [Pa].
* `pressure`: Ambient pressure [Pa].
* `g_sw`: Stomatal conductance of water vapor [mol m^-2 s^-1].
* `g_bw`: Boundary layer conductance of water vapor [mol m^-2 s^-1].
"""
water_flux(VPD_leaf, pressure, g_sw, g_bw) = total_cond_h2o(g_bw, g_sw) *
    VPD_leaf / pressure

"""
Calculate latent heat transfer rate at the leaf surface [W m^-2].

```math
\\mathrm{LE} = L_\\mathrm{v} \\cdot g_\\mathrm{tot,W} \\cdot
\\frac{\\mathrm{VPD}}{p_\\mathrm{atm}}
```

where ``L_\\mathrm{v}`` is the latent heat of vaporization of water [J mol^-1],
and ``g_\\mathrm{tot,W}`` is the total conductance of water vapor.

# Arguments

* `T_leaf`: Leaf temperature [K].
* `VPD_leaf`: Leaf-to-air vapor pressure deficit [Pa].
* `pressure`: Ambient pressure [Pa].
* `g_sw`: Stomatal conductance of water vapor [mol m^-2 s^-1].
* `g_bw`: Boundary layer conductance of water vapor [mol m^-2 s^-1].
"""
latent_heat(T_leaf, VPD_leaf, pressure, g_sw, g_bw) =
    water_flux(VPD_leaf, pressure, g_sw, g_bw) *
    latent_heat_vap(T_leaf)

"""
Calculate the imbalance of energy transfer at the leaf surface [W m^-2]. This
function is used as a constraint for the coupled leaf temperature--flux solver.

# Arguments

* `T_leaf`: Leaf temperature [K].
* `T_air`: Air temperature [K].
* `pressure`: Ambient pressure [Pa].
* `RH`: Relative humidity [0--1].
* `R_sw`: Incoming shortwave radiation [W m^-2].
* `wind_speed`: Wind speed [m s^-1].
* `d_leaf`: Characteristic leaf size [m].
* `em_leaf`: Emissivity of leaf [0--1].
* `g_sw`: Stomatal conductance of water vapor [mol m^-2 s^-1].
"""
function energy_imbalance(T_leaf, T_air, pressure, RH, R_sw, wind_speed,
                          d_leaf, em_leaf, g_sw)
    R_net = R_sw - em_leaf * stefan_boltzmann(T_leaf)
    VPD_leaf = leaf_vapor_pressure_deficit(T_leaf, T_air, RH)
    cp_a = heat_cap_moistair(T_leaf, pressure, RH)
    g_bh = bl_cond_heat(T_air, pressure, RH, wind_speed, d_leaf)
    g_bw = bl_cond_vapor(T_air, pressure, RH, wind_speed, d_leaf)
    SH = sensible_heat(T_leaf, T_air, cp_a, g_bh)
    LE = latent_heat(T_leaf, VPD_leaf, pressure, g_sw, g_bw)

    return R_net - SH - LE
end

end  # module
