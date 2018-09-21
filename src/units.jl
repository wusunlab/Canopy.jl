"""
Unit conversion functions.

* [`c2k`](@ref)
* [`k2c`](@ref)
"""
module Units

include("docstring_style.jl")

using Canopy.Constants: T_0

"""Convert temperature in Celsius to Kelvin."""
c2k(temp) = temp + T_0

"""Convert temperature in Kelvin to Celsius."""
k2c(temp) = temp - T_0

end  # module
