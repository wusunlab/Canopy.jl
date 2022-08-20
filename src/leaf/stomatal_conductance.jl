"""
Stomatal conductance models.

* [`stom_cond_ball_berry`](@ref)
* [`stom_cond_leuning`](@ref)
* [`stom_cond_medlyn`](@ref)
* [`total_cond_co2`](@ref)
"""

module StomatalConductance

include("../docstring_style.jl")

export ratio_gb_co2,
    ratio_gb_ocs,
    ratio_gs_co2,
    ratio_gs_ocs,
    stom_cond_ball_berry,
    stom_cond_leuning,
    stom_cond_medlyn,
    total_cond_co2

"""Ratio between leaf boundary layer conductances to water vapor and CO2."""
const ratio_gb_co2 = 1.37

"""Ratio between leaf boundary layer conductances to water vapor and OCS."""
const ratio_gb_ocs = 1.56

"""Ratio between stomatal conductances to water vapor and CO2."""
const ratio_gs_co2 = 1.60

"""Ratio between stomatal conductances to water vapor and OCS."""
const ratio_gs_ocs = 1.94

"""
Ball--Berry equation of stomatal conductance [mol m^-2 s^-1].

Calculates stomatal conductance from CO2 assimilation rate and environmental
conditions:

```math
g_\\mathrm{s,W}
= \\max\\left\\{m\\frac{A_\\mathrm{n} h_\\mathrm{s}}{c_\\mathrm{s}},0\\right\\}
+ g_\\mathrm{s,W,min}
```

where

* ``m`` is the Ball--Berry slope parameter [dimensionless];
* ``A_\\mathrm{n}`` is the net CO2 assimilation rate [µmol m^-2 s^-1];
* ``c_\\mathrm{s}`` is the CO2 concentration at the leaf surface [µmol mol^-1];
* ``h_\\mathrm{s}`` is relative humidity at the leaf surface [0--1];
* ``g_\\mathrm{s,W,min}`` is the minimum stomatal conductance to water vapor
  [mol mol^-2 s^-1].

# Arguments

* `assim`: CO2 assimilation rate [µmol m^-2 s^-1];
* `co2_s`: Leaf surface CO2 mixing ratio [µmol mol^-1];
* `h_s`: Leaf surface relative humidity [0--1];
* `slope`: Ball--Berry slope [dimensionless];
* `g_sw_min`: Minimum stomatal conductance [mol m^-2 s^-1].

# References

* Ball, J. T. (1988). _An analysis of stomatal conductance_ [Ph.D. Thesis].
  Stanford University.
* Collatz, G. J., Ball, J. T., Grivet, C., & Berry, J. A. (1991). Physiological
  and environmental regulation of stomatal conductance, photosynthesis and
  transpiration: A model that includes a laminar boundary layer. _Agricultural
  and Forest Meteorology_, 54(2--4), 107--136.
  <https://doi.org/10.1016/0168-1923(91)90002-8>

# See also

* [`stom_cond_leuning`](@ref): Leuning equation of stomatal conductance.
* [`stom_cond_medlyn`](@ref): Medlyn equation of stomatal conductance.
"""
function stom_cond_ball_berry(assim, co2_s, h_s, slope, g_sw_min)
    g_sw = slope * assim * h_s / co2_s + g_sw_min
    max(g_sw, g_sw_min)
end

"""
Leuning equation of stomatal conductance [mol m^-2 s^-1].

Calculates stomatal conductance from CO2 assimilation rate and environmental
conditions. The Leuning equation replaces relative humidity dependence in the
Ball--Berry equation with dependence on leaf-to-air vapor pressure deficit.

```math
g_\\mathrm{s,W}
= \\max\\left\\{m \\frac{A_\\mathrm{n}}{c_\\mathrm{s}}
  \\left(1 + \\frac{D}{D_0} \\right)^{-1}, 0\\right\\}
+ g_\\mathrm{s,W,min}
```

where

* ``m`` is the Ball--Berry--Leuning slope parameter [dimensionless];
* ``A_\\mathrm{n}`` is the net CO2 assimilation rate [µmol m^-2 s^-1];
* ``c_\\mathrm{s}`` is the CO2 concentration at the leaf surface [µmol mol^-1];
* ``D`` is the leaf-to-air vapor pressure deficit [Pa];
* ``D_0`` is a parameter for vapor pressure deficit dependence [Pa];
* ``g_\\mathrm{s,W,min}`` is the minimum stomatal conductance to water vapor
  [mol mol^-2 s^-1].

# Arguments

* `assim`: CO2 assimilation rate [µmol m^-2 s^-1];
* `co2_s`: Leaf surface CO2 mixing ratio [µmol mol^-1];
* `vpd_leaf`: Leaf-to-air vapor pressure deficit [Pa];
* `vpd_0`: A parameter for vapor pressure deficit dependence [Pa];
* `slope`: Ball--Berry--Leuning slope [dimensionless];
* `g_sw_min`: Minimum stomatal conductance [mol m^-2 s^-1].

# References

* Leuning, R. (1995). A critical appraisal of a combined
  stomatal-photosynthesis model for C3 plants. _Plant, Cell and Environment_,
  18(4), 339--355. <https://doi.org/10.1111/j.1365-3040.1995.tb00370.x>

# See also

* [`stom_cond_ball_berry`](@ref): Ball--Berry equation of stomatal conductance.
* [`stom_cond_medlyn`](@ref): Medlyn equation of stomatal conductance.
"""
function stom_cond_leuning(assim, co2_s, vpd_leaf, vpd_0, slope, g_sw_min)
    g_sw = slope * assim / co2_s / (1.0 + vpd_leaf / vpd_0) + g_sw_min
    max(g_sw, g_sw_min)
end

"""
Medlyn equation of stomatal conductance [mol m^-2 s^-1].

The Medlyn equation is grounded in stomatal optimization theory and takes the
form of an empirical equation of stomatal conductance.

```math
g_\\mathrm{s,W}
= \\max\\left\\{
    R_\\mathrm{W/C}\\left(1 + \\frac{g_1}{\\sqrt{D}}\\right)
    \\frac{A_\\mathrm{n}}{c_\\mathrm{s}}, 0
    \\right\\}
+ g_\\mathrm{s,W,min}
```

where

* ``R_\\mathrm{W/C}`` is the ratio between stomatal conductances to water vapor
  and CO2 [dimensionless];
* ``g_1`` is the Medlyn slope parameter [Pa^0.5];
* ``A_\\mathrm{n}`` is the net CO2 assimilation rate [µmol m^-2 s^-1];
* ``c_\\mathrm{s}`` is the CO2 concentration at the leaf surface [µmol mol^-1];
* ``D`` is the leaf-to-air vapor pressure deficit [Pa];
* ``g_\\mathrm{s,W,min}`` is the minimum stomatal conductance to water vapor
  [mol mol^-2 s^-1].

# Arguments

* `assim`: CO2 assimilation rate [µmol m^-2 s^-1];
* `co2_s`: Leaf surface CO2 mixing ratio [µmol mol^-1];
* `vpd_leaf`: Leaf-to-air vapor pressure deficit [Pa];
* `slope`: Medlyn slope [Pa^0.5];
* `g_sw_min`: Minimum stomatal conductance [mol m^-2 s^-1].

# References

* Medlyn, B. E., Duursma, R. A., Eamus, D., Ellsworth, D. S., Prentice, I. C.,
  Barton, C. V. M., Crous, K. Y., De Angelis, P., Freeman, M., & Wingate, L.
  (2011). Reconciling the optimal and empirical approaches to modelling
  stomatal conductance. _Global Change Biology_, 17(6), 2134--2144.
  <https://doi.org/10.1111/j.1365-2486.2010.02375.x>

# See also

* [`stom_cond_ball_berry`](@ref): Ball--Berry equation of stomatal conductance.
* [`stom_cond_leuning`](@ref): Leuning equation of stomatal conductance.
"""
function stom_cond_medlyn(assim, co2_s, vpd_leaf, slope, g_sw_min)
    g_sw =
        (ratio_gs_co2 * (1.0 + (slope / sqrt(vpd_leaf))) * assim / co2_s) +
        g_sw_min
    max(g_sw, g_sw_min)
end

"""
Calculate the total conductance to CO2 [mol m^-2 s^-1].

# Arguments

* `g_bw`: Leaf boundary layer conductance to water vapor [mol m^-2 s^-1];
* `g_sw`: Stomatal conductance to water vapor [mol m^-2 s^-1];
* `g_mc`: Mesophyll conductance to CO2 [mol m^-2 s^-1].
"""
function total_cond_co2(g_bw, g_sw, g_mc)
    g_bc = g_bw / ratio_gb_co2
    g_sc = g_sw / ratio_gs_co2
    return g_bc * g_sc * g_mc / (g_bc * g_sc + g_mc * (g_bc + g_sc))
end

end  # module
