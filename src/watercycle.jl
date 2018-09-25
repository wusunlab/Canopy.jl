"""
Terrestrial water cycle: evapotranspiration, precipitation, and runoff.

* [`psychrometric_constant`](@ref)

# References
* [Shu12] Shuttleworth, W. J. (2012). *Terrestrial Hydrometeorology*. John
  Wiley & Sons. ISBN: 978-1119951933. <https://doi.org/10.1002/9781119951933>
"""
module WaterCycle

using Canopy.Constants: M_w, M_d
using Canopy.Water: latent_heat_vap, e_sat_prime, vapor_pressure_deficit
using Canopy.Air: air_density
using Canopy.Transfer.Heat: heat_cap_mass_moistair

export psychrometric_constant,
    penman_monteith

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
    {\\Delta (R_\\mathrm{net} - G) + G_\\mathrm{atm} \\rho_\\mathrm{a} c_p D}
    {\\Delta + \\gamma (1 + G_\\mathrm{atm} / G_\\mathrm{sfc})}
```

where \$\\Delta := e_\\mathrm{sat}'(T)\$ and \$\\gamma\$ is the psychrometric
constant.

# Arguments

* `temp`: Temperature [K].
* `pressure`: Ambient pressure [Pa].
* `RH`: Relative humidity [0--1].
* `heat_flux`: Net heat flux [W m^-2] which equals to net radiation
  (\$R_\\mathrm{net}\$) - heat storage (\$G\$).
* `cond_atm`: Atmospheric conductance [m s^-1].
* `cond_sfc`: Surface conductance [m s^-1].
* `evap` (*kwarg*): If `true`, return evapotranspiration flux instead of latent
  heat flux (default).
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

end  # module
