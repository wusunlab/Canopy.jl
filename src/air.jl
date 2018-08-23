"""
Air properties.

* [`air_concentration`](@ref)
* [`air_density`](@ref)
"""
module Air

include("docstring_style.jl")

using Canopy.Constants
using Canopy.Water: vapor_mole_frac

export air_concentration,
    air_density

"""
Calculate the molar concentration [mol m^-3] of air from temperature [K] and
pressure [Pa].

# Examples

```jldoctest
julia> air_concentration(298.15, 101325.0)
40.87405837767172
```
"""
air_concentration(temp, pressure) = pressure / (Constants.R * temp)

"""
Calculate the air density [kg m^-3] from temperature [K], pressure [Pa], and
relative humidity [0--1].

# Examples

```jldoctest
julia> air_density(273.15, 101325.0, 0.0)
1.2922525730764916

julia> air_density(298.15, 101325.0, 1.0)
1.1699164154668222
```
"""
function air_density(temp, pressure, RH)
    chi_w = vapor_mole_frac(temp, pressure, RH)
    # molar mass of moist air [kg mol^-1]
    M_a = (1. - chi_w) * Constants.M_d + chi_w * Constants.M_w
    return M_a * air_concentration(temp, pressure)
end

end  # module
