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
    ratio_gs_co2,
    ratio_gb_ocs,
    ratio_gs_ocs,
    stom_cond_ball_berry,
    stom_cond_leuning,
    stom_cond_medlyn,
    total_cond_co2

"""Ratio of boundary layer conductance of CO<sub>2</sub> and H<sub>2</sub>O."""
const ratio_gb_co2 = 1.37

"""Ratio of stomatal conductance of CO<sub>2</sub> and H<sub>2</sub>O."""
const ratio_gs_co2 = 1.60

"""Ratio of boundary layer conductance of COS and H<sub>2</sub>O."""
const ratio_gb_ocs = 1.56

"""Ratio of stomatal conductance of COS and H<sub>2</sub>O."""
const ratio_gs_ocs = 1.94

"""
Ball--Berry equation of stomatal conductance [mol m^-2 s^-1].

Calculates stomatal conductance from CO<sub>2</sub> assimilation rate and
environmental conditions (Ball, 1988; Collatz et al., 1991).

```math
g_\\mathrm{s,W}
= \\max\\left\\{m\\frac{A_\\mathrm{n} h_\\mathrm{s}}{c_\\mathrm{s}},0\\right\\}
+ g_\\mathrm{s,W,min}
```

# Arguments

* `assim`: CO<sub>2</sub> assimilation rate [µmol m^-2 s^-1];
* `co2_s`: Leaf surface CO<sub>2</sub> mixing ratio [µmol mol^-1];
* `h_s`: Leaf surface relative humidity [0--1];
* `slope`: Ball--Berry slope [dimensionless];
* `g_sw_min`: Minimum stomatal conductance [mol m^-2 s^-1].

# See also

* [`stom_cond_leuning`](@ref)
* [`stom_cond_medlyn`](@ref)
"""
function stom_cond_ball_berry(assim, co2_s, h_s, slope, g_sw_min)
    g_sw = slope * assim * h_s / co2_s + g_sw_min
    max(g_sw, g_sw_min)
end

"""
Leuning equation of stomatal conductance [mol m^-2 s^-1].

Calculates stomatal conductance from CO<sub>2</sub> assimilation rate and
environmental conditions (Leuning, 1995). The Leuning equation replaces
relative humidity dependence in the Ball--Berry equation with dependence on
vapor pressure deficit.

```math
g_\\mathrm{s,W}
= \\max\\left\\{m \\frac{A_\\mathrm{n}}{c_\\mathrm{s}}
  \\left(1 + \\frac{D}{D_0} \\right)^{-1}\\right\\}
+ g_\\mathrm{s,W,min}
```

# Arguments

* `assim`: CO<sub>2</sub> assimilation rate [µmol m^-2 s^-1];
* `co2_s`: Leaf surface CO<sub>2</sub> mixing ratio [µmol mol^-1];
* `vpd_leaf`: Leaf-to-air vapor pressure deficit [Pa];
* `vpd_0`: A parameter for vapor pressure deficit dependence [Pa];
* `slope`: Leuning slope [dimensionless];
* `g_sw_min`: Minimum stomatal conductance [mol m^-2 s^-1].

# See also

* [`stom_cond_ball_berry`](@ref)
* [`stom_cond_medlyn`](@ref)
"""
function stom_cond_leuning(assim, co2_s, vpd_leaf, vpd_0, slope, g_sw_min)
    g_sw = slope * assim / co2_s / (1.0 + vpd_leaf / vpd_0) + g_sw_min
    max(g_sw, g_sw_min)
end

"""
Medlyn equation of stomatal conductance [mol m^-2 s^-1].

# Arguments

* `assim`: CO<sub>2</sub> assimilation rate [µmol m^-2 s^-1];
* `co2_s`: Leaf surface CO<sub>2</sub> mixing ratio [µmol mol^-1];
* `vpd_leaf`: Leaf-to-air vapor pressure deficit [Pa];
* `slope`: Medlyn slope [Pa^0.5];
* `g_sw_min`: Minimum stomatal conductance [mol m^-2 s^-1].

# See also

* [`stom_cond_ball_berry`](@ref)
* [`stom_cond_leuning`](@ref)
"""
function stom_cond_medlyn(assim, co2_s, vpd_leaf, slope, g_sw_min)
    g_sw =
        (ratio_gs_co2 * (1.0 + (slope / sqrt(vpd_leaf))) * assim / co2_s) +
        g_sw_min
    max(g_sw, g_sw_min)
end

"""
Calculate the total conductance to CO<sub>2</sub> [mol m^-2 s^-1].

# Arguments

* `g_bw`: Leaf boundary layer conductance to water vapor [mol m^-2 s^-1];
* `g_sw`: Stomatal conductance to water vapor [mol m^-2 s^-1];
* `g_mc`: Mesophyll conductance to CO<sub>2</sub> [mol m^-2 s^-1].
"""
function total_cond_co2(g_bw, g_sw, g_mc)
    g_bc = g_bw / ratio_gb_co2
    g_sc = g_sw / ratio_gs_co2
    return g_bc * g_sc * g_mc / (g_bc * g_sc + g_mc * (g_bc + g_sc))
end

end  # module
