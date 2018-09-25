"""
Terrestrial water cycle: evapotranspiration, precipitation, and runoff.

* [`psychrometric_constant`](@ref)
* [`penman_monteith`](@ref)
* [`cond_sfc`](@ref)

# References

* [Shu12] Shuttleworth, W. J. (2012). *Terrestrial Hydrometeorology*. John
  Wiley & Sons. ISBN: 978-1119951933. <https://doi.org/10.1002/9781119951933>
* [MB14] Monson, R. and Baldocchi, D. (2014). *Terrestrial
  Biosphere--Atmosphere Fluxes*. Cambridge University Press, Cambridge, UK.
  ISBN: 978-1107040656.
"""
module WaterCycle

include("docstring_style.jl")

using Canopy.Constants: M_w, M_d
using Canopy.Water: latent_heat_vap, e_sat_prime, vapor_pressure_deficit
using Canopy.Air: air_density
using Canopy.Transfer.Heat: heat_cap_mass_moistair

export psychrometric_constant,
    penman_monteith,
    cond_sfc

"""
Calculate the psychrometric constant [Pa K^-1] from temperature [K], pressure
[Pa], and relative humidity [0--1].

# Examples

```jldoctest
julia> psychrometric_constant(298.15, 101325.0, 0.7)
67.91408269550081

julia> psychrometric_constant(283.15, 101325.0, 0.9)
66.5430908894645
```
"""
psychrometric_constant(temp, pressure, RH) =
    heat_cap_mass_moistair(temp, pressure, RH) * pressure *
    M_d / latent_heat_vap(temp)
# note: M_w cancels out because latent_heat_vap returns value in J mol^-1 K^-1

"""
Calculate latent heat flux [W m^-2] or evapotranspiration [mol m^-2 s^-1] from
the Penman--Monteith equation.

```math
LE = \\dfrac
    {\\Delta \\cdot (R_\\mathrm{net} - G) +
     G_\\mathrm{atm} \\rho_\\mathrm{a} c_p D}
    {\\Delta + \\gamma (1 + G_\\mathrm{a} / G_\\mathrm{c})}
```

where \$\\Delta := e_\\mathrm{sat}'(T)\$ and \$\\gamma\$ is the psychrometric
constant.

# Arguments

* `temp`: Temperature [K].
* `pressure`: Ambient pressure [Pa].
* `RH`: Relative humidity [0--1].
* `heat_flux`: Net heat flux [W m^-2] which equals to net radiation
  (\$R_\\mathrm{net}\$) -- heat storage (\$G\$).
* `cond_atm`: Aerodynamic conductance [m s^-1].
* `cond_sfc`: Canopy surface conductance [m s^-1].
* `evap` (*kwarg*): Default is `false`. If `true`, return evapotranspiration
  flux instead of latent heat flux.
"""
function penman_monteith(temp, pressure, RH, heat_flux, cond_atm, cond_sfc;
                         evap::Bool=false)
    Delta = e_sat_prime(temp)
    gamma = psychrometric_constant(temp, pressure, RH)
    rho_a = air_density(temp, pressure, RH)
    c_p = heat_cap_mass_moistair(temp, pressure, RH)
    D = vapor_pressure_deficit(temp, RH)
    LE = (Delta * heat_flux + rho_a * c_p * D * cond_atm) /
        (Delta + gamma * (1. + cond_atm / cond_sfc))
    return evap ? LE / latent_heat_vap(temp) : LE
end

"""
Calculate the canopy surface conductance [m s^-1] from the inverted
Penman--Monteith equation.

```math
G_\\mathrm{c} = \\gamma \\left[
    \\dfrac{G_\\mathrm{a}\\rho_\\mathrm{a} c_p D}{LE} +
    \\Delta \\cdot \\beta - \\gamma \\right]^{-1} G_\\mathrm{a}
```

where \$\\beta := \\dfrac{H}{LE}\$ is the Bowen ratio.

# Arguments

* `temp`: Temperature [K].
* `pressure`: Ambient pressure [Pa].
* `RH`: Relative humidity [0--1].
* `LE`: Latent heat flux [W m^-2].
* `bowen`: Bowen ratio.
* `cond_atm`: Aerodynamic conductance [m s^-1].
"""
function cond_sfc(temp, pressure, RH, LE, bowen, cond_atm)
    Delta = e_sat_prime(temp)
    gamma = psychrometric_constant(temp, pressure, RH)
    rho_a = air_density(temp, pressure, RH)
    c_p = heat_cap_mass_moistair(temp, pressure, RH)
    D = vapor_pressure_deficit(temp, RH)
    return cond_atm * gamma / (cond_atm * rho_a * c_p * D / LE +
                               Delta * bowen - gamma)
end

end  # module
