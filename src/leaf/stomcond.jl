module StomCond

include("../docstring_style.jl")

"""
Calculate the total leaf conductance of water vapor [mol m^-2 s^-1].

# Arguments

* `g_bw`: Leaf boundary layer conductance of water vapor [mol m^-2 s^-1].
* `g_sw`: Stomatal conductance of water vapor [mol m^-2 s^-1].

# See also

[`total_cond_co2`](@ref) and [`total_cond_cos`](@ref)
"""
total_cond_h2o(g_bw, g_sw) = g_bw * g_sw / (g_bw + g_sw)

end  # module
