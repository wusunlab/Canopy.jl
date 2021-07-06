"""
Blackbody radiation.

* [`ephoton`](@ref)
* [`energy2photon`](@ref)
* [`planck`](@ref)
* [`stefan_boltzmann`](@ref)
* [`blackbody_temp`](@ref)
"""
module Blackbody

include("../docstring_style.jl")

using Canopy.Constants: c, h, N_A, c_1L, c_2, sigma_SB

export ephoton,
    energy2photon,
    planck,
    stefan_boltzmann,
    blackbody_temp

"""
Calculate the energy carried by a photon [J] from its wavelength [m].

# Examples

```jldoctest
julia> ephoton(0.5e-6)
3.972891714297857e-19
```
"""
function ephoton(wl)
    return h * c / wl
end

"""
Convert the energy flux density `flux` [W m^-2] at the wavelength `wl` [m] to
photon flux density [mol m^-2 s^-1].

# Examples

```jldoctest
julia> energy2photon(300., 0.5e-6)
0.0012539020843667665
```
"""
function energy2photon(flux, wl)
    return flux * wl / (N_A * h * c)
end

"""
Calculate the spectral radiance [W sr^-1 m^-3] from wavelength `wl` [m] and
blackbody temperature `temp` [K] accroding to Planck's law.

# Examples

```jldoctest
julia> planck(0.5e-6, 6000)
3.175690669942503e13

julia> planck(10e-6, 288)
8.114245536536237e6
```
"""
function planck(wl, temp)
    return c_1L * wl^(-5.) / (exp(c_2 / (wl * temp)) - 1.)
end

"""
Calculate the energy flux density [W m^-2] of a blackbody of temperature `temp`
[K] from the Stefan--Boltzmann law.

# Examples

```jldoctest
julia> stefan_boltzmann(298.15)
448.0752867066491
```
"""
function stefan_boltzmann(temp)
    temp_sq = temp * temp
    return sigma_SB * temp_sq * temp_sq
end

"""
Calculate the blackbody temperature [K] from energy flux density [W m^-2].

# Examples

```jldoctest
julia> blackbody_temp(240.)
255.06441705528474
```
"""
function blackbody_temp(flux)
    return (flux / sigma_SB)^0.25
end

end  # module
