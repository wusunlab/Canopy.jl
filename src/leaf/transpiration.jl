"""
Leaf transpiration.

* [`leaf_vapor_deficit`](@ref)
* [`total_cond_vapor`](@ref)
* [`transpiration`](@ref)
"""
module Transpiration

include("../docstring_style.jl")

using Canopy.Water: e_sat

export leaf_vapor_deficit, total_cond_vapor, transpiration

"""
Calculate leaf-to-air vapor pressure deficit [Pa].

# Arguments

* `temp`: Air temperature [K];
* `temp_leaf`: Leaf temperature [K];
* `rh`: Relative humidity [0--1].
"""
function leaf_vapor_deficit(temp, temp_leaf, rh)
    e_sat(temp_leaf) - e_sat(temp) * rh
end

"""
Calculate the total conductance to water vapor [mol m^-2 s^-1].

```math
g_\\mathrm{tot,W} = \\frac{1}{g_\\mathrm{b,W}^{-1} + g_\\mathrm{s,W}^{-1}}.
```

where ``g_\\mathrm{b,W}`` and ``g_\\mathrm{s,W}`` are leaf boundary layer and
stomatal conductances to water vapor, respectively.

# Arguments

* `g_bw`: Leaf boundary layer conductance to water vapor [mol m^-2 s^-1];
* `g_sw`: Stomatal conductance to water vapor [mol m^-2 s^-1].

# Examples

```jldoctest
julia> total_cond_vapor(1.0, 0.25)
0.2
```
"""
total_cond_vapor(g_bw, g_sw) = g_bw * g_sw / (g_bw + g_sw)

"""
Calculate leaf transpiration rate [mol m^-2 s^-1].

```math
F_\\mathrm{W} = g_\\mathrm{tot,W}\\cdot\\frac{\\mathrm{VPD_{leaf}}}{p}
```

where

* ``g_\\mathrm{tot,W}`` [mol m^-2 s^-1] is the total conductance to water
  vapor;
* ``\\mathrm{VPD_{leaf}}`` [Pa] is the leaf-to-air vapor pressure deficit;
* ``p`` [Pa] is the ambient pressure.

# Arguments

* `pressure`: Ambient pressure [Pa];
* `vpd_leaf`: Leaf-to-air vapor pressure deficit [Pa];
* `g_bw`: Boundary layer conductance of water vapor [mol m^-2 s^-1];
* `g_sw`: Stomatal conductance of water vapor [mol m^-2 s^-1].

# Examples

```jldoctest
julia> transpiration(1e5, 5e2, 1.0, 0.25)
0.001
```
"""
function transpiration(pressure, vpd_leaf, g_bw, g_sw)
    total_cond_vapor(g_bw, g_sw) * vpd_leaf / pressure
end

end  # module
