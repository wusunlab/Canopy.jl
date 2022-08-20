"""
Photosynthesis.

# Electron transport

* [`electron_transport_empirical`](@ref)

# Carbon assimilation

* [`internal_co2`](@ref)
* [`assimilation_c3`](@ref)
"""
module Photosynthesis

include("../docstring_style.jl")

using Canopy.Constants: atm
using Canopy.PhysChem: TempDep, eval_temp_dep

export PhotosynPathway,
    PhotosynParams, electron_transport_empirical, internal_co2, assimilation_c3

@enum PhotosynPathway C3 C4 CAM C2

struct PhotosynParams
    vcmax_temp_dep::TempDep
    kc_temp_dep::TempDep
    ko_temp_dep::TempDep
    gamma_temp_dep::TempDep
    rd_temp_dep::TempDep
    jmax_temp_dep::TempDep
    f_abs::Number
    f_spec::Number
    theta::Number
    tp_temp_dep::TempDep
    alpha::Number
    temp_ref::Number
    pathway::PhotosynPathway
    flag_substrate_limitation::Bool
end  # struct

"""
Calculate the potential linear electron transport rate [µmol m^-2 s^-1].

# Arguments

* `ppfd`: Photosynthetic photon flux density [µmol m^-2 s^-1];
* `temp_leaf`: Leaf temperature [K];
* `params`: A struct of photosynthetic parameters.
"""
function electron_transport_empirical(ppfd, temp_leaf, params::PhotosynParams)
    # light harvesting at the photosystem II [mumol m^-2 s^-1]
    i_psii = ppfd * params.f_abs * (1.0 - params.f_spec) * 0.5
    # maximum electron transport rate [mumol m^-2 s^-1]
    j_max = eval_temp_dep(params.jmax_temp_dep, temp_leaf)
    x = i_psii + j_max  # an intermediate variable

    if params.theta < 1e-6
        i_psii * j_max / x
    else
        (x - sqrt(x * x - 4.0 * params.theta * i_psii * j_max)) /
        (2.0 * params.theta)
    end
end

"""
Calculate the CO<sub>2</sub> concentration at the Rubisco site [µmol mol^-1].

# Arguments

* `co2`: CO<sub>2</sub> concentration in the ambient air or the canopy layer
  [µmol mol^-1].
* `assim`: Net CO<sub>2</sub> assimilation rate [µmol m^-2 s^-1];
* `g_bw`: Leaf boundary layer conductance to water vapor [mol m^-2 s^-1];
* `g_sw`: Stomatal conductance to water vapor [mol m^-2 s^-1];
* `g_m`: Mesophyll conductance to CO<sub>2</sub> [mol m^-2 s^-1];
"""
function internal_co2(co2, assim, g_bw, g_sw, g_m)
    co2 - assim / total_cond_co2(g_bw, g_sw, g_m)
end

"""
Calculate the net CO<sub>2</sub> assimilation rate of C<sub>3</sub>
photosynthesis [µmol m^-2 s^-1].

# Arguments

* `pressure`: Ambient pressure [Pa];
* `ppfd`: Photosynthetic photon flux density [µmol m^-2 s^-1];
* `temp_leaf`: Leaf temperature [K];
* `co2_c`: CO<sub>2</sub> concentration at the Rubisco site [µmol mol^-1];
* `o2`: Ambient O<sub>2</sub> concentration [µmol mol^-1];
* `params`: A struct of photosynthetic parameters.
"""
function assimilation_c3(
    pressure,
    ppfd,
    temp_leaf,
    o2,
    co2_c,
    params::PhotosynParams,
)
    # evaluate biochemical parameters at the current leaf temperature
    v_cmax = eval_temp_dep(params.vcmax_temp_dep, temp_leaf)
    k_c = eval_temp_dep(params.kc_temp_dep, temp_leaf)
    k_o = eval_temp_dep(params.ko_temp_dep, temp_leaf)
    gamma = eval_temp_dep(params.gamma_temp_dep, temp_leaf)
    r_d = eval_temp_dep(params.rd_temp_dep, temp_leaf)

    # pressure correction: this is needed because the Michaelis constants used
    # here (k_c and k_o) are converted to equivalent mixing ratios:
    #
    # [mol L^-1] -> [Pa] -> [µmol mol^-1]
    #
    # Therefore, they must be pressure-dependent.
    k_c *= (atm / pressure)
    k_o *= (atm / pressure)

    # note: CO2 compensation point, if expressed in [ppm] or [µmol mol^-1], is
    # pressure independent because it can be expressed as a function of oxygen
    # mixing ratio [µmol mol^-1] at the leaf surface. Thus, no pressure
    # correction is needed for `gamma`.

    # electron-transport limited rate of assimilation [µmol m^-2 s^-1]
    assim_j =
        (co2_c - gamma) / (4.0 * co2_c + 8.0 * gamma) *
        electron_transport_empirical(ppfd, temp_leaf, params)
    # RuBP limited rate of assimilation [µmol m^-2 s^-1]
    assim_c = (co2_c - gamma) * v_cmax / (co2_c + k_c * (1.0 + o2 / k_o))
    # the actual gross assimilation rate is the minimum of them
    assim_g = min(assim_j, assim_c)

    # if the evaluation of substrate (triose phosphate utilization)-limited
    # rate is enabled
    if params.flag_substrate_limitation
        t_p = eval_temp_dep(params.tp_temp_dep, temp_leaf)
        # substrate-limited rate of assimilation [µmol m^-2 s^-1]
        assim_p =
            3.0 * t_p * (co2_c - gamma) /
            (co2_c - (1.0 + 1.5 * params.alpha) * gamma)
        assim_g = min(assim_g, assim_p)
    end

    # subtract respiration to get the net assimilation rate [µmol m^-2 s^-1]
    assim_g - r_d
end

end  # module
