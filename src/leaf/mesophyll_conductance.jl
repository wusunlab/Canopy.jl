"""
Mesophyll conductance models.

* [`mp_cond`](@ref)
"""

module MesophyllConductance

include("../docstring_style.jl")

using Canopy.PhysChem: TempDep, eval_temp_dep

export mp_cond

"""
Calculates mesophyll conductance to CO<sub>2</sub> at a given temperature
(Bernacchi et al., 2002).

# Arguments

* `temp_leaf`: Leaf temperature [K];
* `gmc_temp_dep`: Temperature dependence parameters of mesophyll conductance.
"""
function mp_cond(temp_leaf, gmc_temp_dep::TempDep)
    eval_temp_dep(gmc_temp_dep, temp_leaf)
end

end  # module
