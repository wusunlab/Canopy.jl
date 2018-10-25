"""
Gas solubility.

* [`solub_co2`](@ref)
* [`solub_cos`](@ref)
"""
module Solub

include("../docstring_style.jl")

using Canopy.Constants: atm
using Canopy.Air: air_molar

export solub_co2,
    solub_cos

"""
Calculate CO2 solubility in natural water from temperature [K] and salinity [g
kg^-1 seawater].

If the keyword argument `bunsen` is true (default), return the dimensionless
Bunsen solubility coefficient, otherwise return the Henry solubility
coefficient defined via concentration and partial pressure [mol L^-1 atm^-1].

# References

* [MR71] Murray, C. N. and Riley, J. P. (1971). The solubility of gases
  in distilled water and seawater--IV. Carbon dioxide. *Deep-Sea Res.*, 18,
  533--541. <https://doi.org/10.1016/0011-7471(71)90077-5>.
* [W74] Weiss, R. F. (1974). Carbon dioxide in water and seawater: the
  solubility of a non-ideal gas. *Mar. Chem.*, 2, 203--215.
  <https://doi.org/10.1016/0304-4203(74)90015-2>.

# Examples

```jldoctest
julia> solub_co2(298.15)
0.831005
```
"""
function solub_co2(temp, salinity=0.; bunsen::Bool=true)
    t = temp * 1e-2  # a transferred scale
    # Henry solubility [mol L^-1 atm^-1]
    kcp_co2 = exp(-58.0931 + 90.5069 / t + 22.2940 * log(t) +
                  salinity * (0.027766 - 0.025888 * t + 0.0050578 * t * t))
    return bunsen ? kcp_co2 * 1e3 / air_molar(temp, atm) : kcp_co2
end

"""
Calculate COS solubility in pure water at a given temperature [K].

If the keyword argument `bunsen` is true (default), return the dimensionless
Bunsen solubility coefficient, otherwise return the Henry solubility
coefficient defined via concentration and partial pressure [mol L^-1 atm^-1].

# References

* [E89] Elliott, S., Lu, E., and Rowland, F. S. (1989). Rates and
  mechanisms for the hydrolysis of carbonyl sulfide in natural waters.
  *Environ. Sci. Tech*. 23(4), 458--461. <https://doi.org/10.1021/es00181a011>
* [S15] Sun, W., Maseyk, K., Lett, C., and Seibt, U. (2015). A soil
  diffusion--reaction model for surface COS flux: COSSM v1, *Geosci. Model
  Dev.*, 8, 3055--3070. <https://doi.org/10.5194/gmd-8-3055-2015>

# Examples

```jldoctest
julia> solub_cos(298.15)
0.48759826544380036

julia> solub_cos(298.15; bunsen=false)
0.019930119966601368
```
"""
function solub_cos(temp; bunsen::Bool=true)
    # Bunsen solubility [dimensionless]
    k_cos = temp * exp(4050.32 / temp - 20.0007)
    return bunsen ? k_cos : k_cos * air_molar(temp, atm) * 1e-3
end

solub_gas(temp) = error("Not implemented!")

end  # module
