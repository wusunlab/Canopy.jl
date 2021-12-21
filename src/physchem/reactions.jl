"""
Chemical reactions.

* [`hydrolysis_ocs`](@ref)
"""
module Reactions

include("../docstring_style.jl")

using Canopy.Water: water_dissoc

export hydrolysis_ocs

"""
Calcualte the rate constant of carbonyl sulfide (OCS) abiotic hydrolysis [s^-1]
in natural water from temperature [K] and pH. Applicable range: temperature
5--30 °C and pH 4--10.

# Arguments

* `temp`: Temperature [K].
* `pH` (_optional_): pH value. Default is 7.
* `seawater` (_kwarg_): If `true`, calculate the OCS hydrolysis rate in the
  seawater (Radford-Knoery & Cutter, 1993). If `false` (default), calculate the
  OCS hydrolysis rate in the fresh water (Elliott et al., 1989).

# References

* Elliott, S., Lu, E., & Rowland, F. S. (1989). Rates and mechanisms for the
  hydrolysis of carbonyl sulfide in natural waters. _Environmental Science &
  Technology_, _23_(4), 458--461. <https://doi.org/10.1021/es00181a011>
* Radford-Knoery, J., & Cutter, G. A. (1993). Determination of carbonyl sulfide
  and hydrogen sulfide species in natural waters using specialized collection
  procedures and gas chromatography with flame photometric detection.
  _Analytical Chemistry_, _65_(8), 976--982.
  <https://doi.org/10.1021/ac00056a005>

# Examples

```jldoctest
julia> hydrolysis_ocs(288.15)
6.6018369330935074e-6

julia> hydrolysis_ocs(288.15, 9.)
3.648990496059149e-5

julia> hydrolysis_ocs(288.15, 8.2, seawater=true)
1.4069474819575507e-5
```
"""
function hydrolysis_ocs(temp, pH = 7.0; seawater::Bool = false)
    temp_ref = 298.15
    c_OH = 10.0^(pH - water_dissoc(temp))
    t_diff = 1.0 / temp - 1.0 / temp_ref

    # note: the parameter values used here differ from those in the original
    # publications due to a small correction for water pK_w
    if seawater
        # RC93 equation
        return 1.63838819502e-5 * exp(-6444.02904777 * t_diff) +
               11.7115101829 * exp(-2427.27401921 * t_diff) * c_OH
    else
        # E89 equation
        return 2.11834513803e-5 * exp(-10418.3722377 * t_diff) +
               14.16881179 * exp(-6469.11889197 * t_diff) * c_OH
    end
end

end  # module
