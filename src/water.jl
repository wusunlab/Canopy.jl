"""
Water and water vapor properties.

* [`water_density`](@ref)
* [`water_dissoc`](@ref)
* [`latent_heat_vap`](@ref)
* [`latent_heat_sub`](@ref)
* [`e_sat`](@ref)
* [`e_sat_prime`](@ref)
* [`e_sat_ice`](@ref)
* [`e_sat_ice_prime`](@ref)
* [`vapor_pressure_deficit`](@ref)
* [`vapor_mole_frac`](@ref)
* [`mole_frac_vapor_deficit`](@ref)

# References

## Water density

* [WP02] Wagner, W. and Pruß, A. (2002). The IAPWS Formulation 1995 for the
  Thermodynamic Properties of Ordinary Water Substance for General and
  Scientific Use. *J. Phys. Chem. Ref. Data*, 31, 387--535.
  <https://doi.org/10.1063/1.1461829>.

## Water dissociation constant

* [BL06] Bandura, A. V. and Lvov, S. N. (2006). The ionization constant of
  water over wide ranges of temperature and density. *J. Phys. Chem. Ref.
  Data*, 35, 15--30. <https://doi.org/10.1063/1.1928231>.

## Latent heat

* [H84] Henderson-Sellers, B. (1984). A new formula for latent heat of
  vaporization of water as a function of temperature. *Quart. J. Roy. Meteorol.
  Soc.*, 110(466), 1186--1190. <https://doi.org/10.1002/qj.49711046626>.
* [MK05] Murphy, D. M., and Koop, T. (2005). Review of the vapour pressures of
  ice and supercooled water for atmospheric applications. *Quart. J. Roy.
  Meteorol. Soc.*, 131(608), 1539--1565. <https://doi.org/10.1256/qj.04.94>.

## Saturation vapor pressure

* [GG46] Goff, J. A., and Gratch, S. (1946). Low-pressure properties of water
  from -160 to 212 F, in *Transactions of the American Society of Heating and
  Ventilating Engineers*, pp 95--122, presented at the 52nd Annual Meeting of
  the American Society of Heating and Ventilating Engineers, New York, NY, USA.
* [V16] Vömel, Holger. (2016). *Saturation vapor pressure formulations*.
  Earth Observing Laboratory, National Center for Atmospheric Research,
  Boulder, CO, USA. Retrieved from <http://cires1.colorado.edu/~voemel/vp.html>
  on 2017-10-09.
"""
module Water

include("docstring_style.jl")

using Canopy.Constants: M_w

export water_density,
    water_dissoc,
    latent_heat_vap,
    latent_heat_sub,
    e_sat,
    e_sat_prime,
    e_sat_ice,
    e_sat_ice_prime,
    vapor_pressure_deficit,
    vapor_mole_frac,
    mole_frac_vapor_deficit

"""
Calculate water density [kg m^-3] as a function of temperature [K].

# Examples

```jldoctest
julia> water_density(298.15)
996.9993666156083
```
"""
function water_density(temp)
    T_crit = 647.096  # critical temperature
    rho_crit = 322.  # critical density
    theta = 1. - temp / T_crit
    rho_ratio = 1. + 1.99274064 * theta ^ (1. / 3.) +
        1.09965342 * theta ^ (2. / 3.) - 0.510839303 * theta ^ (5. / 3.) -
        1.7549349 * theta ^ (16. / 3.) - 45.5170352 * theta ^ (43. / 3.) -
        6.74694450e5 * theta ^ (110. / 3.)
    return rho_crit * rho_ratio
end

"""
Calculate water dissociation constant (pK_w) as a function of temperature [K].

# Examples

```jldoctest
julia> water_dissoc(298.15)
13.994884354781636
```
"""
function water_dissoc(temp)
    n = 6.
    rho_w = water_density(temp) * 1e-3  # convert to g cm^-3 here
    temp_sq = temp * temp
    Z = rho_w * exp(-0.864671 + 8659.19 / temp -
                    22786.2 / temp_sq * rho_w ^ (2. / 3.))
    pK_w_G = 0.61415 + 48251.33 / temp - 67707.93 / temp_sq +
        10102100. / (temp * temp_sq)
    pK_w = -2. * n * (log10(1. + Z) - Z / (Z + 1.) * rho_w *
                      (0.642044 - 56.8534 / temp - 0.375754 * rho_w)) +
        pK_w_G + 2. * log10(M_w)
    return pK_w
end

"""
Calculate the molar latent heat of vaporization of water [J mol^-1]. Applicable
range: 1 atm, -130 -- 40°C.

# Examples

```jldoctest
julia> latent_heat_vap(273.15)  # 0 C
45053.505423916824

julia> latent_heat_vap(373.15)  # 100 C
41816.390994192036

julia> latent_heat_vap(243.15)  # -30 C, supercooled water
46398.07458086907
```

# Known issues

!!! note

    Temperature at 273.15 K is a discontinuity due to small differences in the
    fitted parameters for normal and supercooled water. However, the difference
    is only 1.4 J mol^-1 and can be neglected in most applications.
"""
latent_heat_vap(temp) =
    if temp < 273.15
        # supercooled water
        L_v_sc = 56579. - 42.212 * temp + exp(0.1149 * (281.6 - temp))
    else
        L_v = 1.91846e6 * (temp / (temp - 33.91))^2 * M_w
    end

"""
Calculate the molar latent heat of sublimation of water ice [J mol^-1].
Applicable range: 1 atm, -240 -- 0°C.

# Examples

```jldoctest
julia> latent_heat_sub(273.15)  # 0 C
51059.029186873086

julia> latent_heat_vap(258.15)  # -15 C
45696.76891208987
```
"""
latent_heat_sub(temp) = 46782.5 + 35.8925 * temp - 0.07414 * temp * temp +
    541.5 * exp(- (temp / 123.75)^2)

"""
Calculate saturation vapor pressure of water [Pa] using Goff--Gratch equation.

# Examples

```jldoctest
julia> e_sat(298.15)  # 25 C
3165.1956333836806

julia> e_sat(273.15)  # 0 C
610.3360999334138
```
"""
function e_sat(temp)
    u = 373.16 / temp
    v = temp / 373.16
    log10_e_sat = -7.90298 * (u - 1.) +
        5.02808 * log10(u) -
        1.3816e-7 * (10^(11.344 * (1. - v)) - 1.) +
        8.1328e-3 * (10^(-3.49149 * (u - 1.)) - 1.) +
        log10(1013.246) + 2.  # add 2 to convert from hPa to Pa
    return 10^log10_e_sat
end

"""
Calculate the temperature derivative of saturation vapor pressure of water [Pa
K^-1].

# Examples

```jldoctest
julia> e_sat_prime(298.15)  # 25 C
188.6862159855073

julia> e_sat_prime(273.15)  # 0 C
44.35218469842299
```
"""
function e_sat_prime(temp)
    log_e_sat_prime = (6790.4984743899386 +
                       exp(12.068003566856145 -
                           3000.0022166762069 / temp)) / (temp * temp) -
        5.02808 / temp +
        exp(8.5004184700093912 - 0.069998191914793798 * temp)
    return e_sat(temp) * log_e_sat_prime
end

"""
Calculate saturation vapor pressure of water ice [Pa] using Goff--Gratch
equation.

# Examples

```jldoctest
julia> e_sat_ice(258.15)  # -15 C
165.0147739235893

julia> e_sat_ice(273.15)  # 0 C
610.2072697609788
```
"""
function e_sat_ice(temp)
    u = 273.16 / temp
    v = temp / 273.16
    log10_e_sat = -9.09718 * (u - 1.) -
        3.56654 * log10(u) + 0.876793 * (1. - v) +
        log10(6.1071) + 2.  # add 2 to convert from hPa to Pa
    return 10^log10_e_sat
end

"""
Calculate the temperature derivative of saturation vapor pressure of water ice
[Pa K^-1].

# Examples

```jldoctest
julia> e_sat_ice_prime(258.15)  # -15 C
15.228515762185872

julia> e_sat_ice_prime(273.15)  # 0 C
50.254185101185534
```
"""
function e_sat_ice_prime(temp)
    log_e_sat_prime = 5721.891003334422 / (temp * temp) +
        3.56654 / temp - 0.007390871618983484
    return e_sat_ice(temp) * log_e_sat_prime
end

"""
Calculate water vapor pressure deficit [Pa] from temperature [K] and relative
humidity [0--1].

# Examples

```jldoctest
julia> vapor_pressure_deficit(298.15, 0.5)
1582.5978166918403

julia> vapor_pressure_deficit(288.15, 0.6)
681.3124028440158
```
"""
vapor_pressure_deficit(temp, RH) = e_sat(temp) * (1. - RH)

"""
Calculate water vapor mole fraction [mol mol^-1] from temperature [K], pressure
[Pa], and relative humidity [0--1].

# Examples

```jldoctest
julia> vapor_mole_frac(298.15, 101325.0, 0.7)
0.021866636500059967

julia> vapor_mole_frac(288.15, 101325.0, 1.0)
0.016810076556723803
```
"""
vapor_mole_frac(temp, pressure, RH) = e_sat(temp) * RH / pressure

"""
Calculate the mole fraction vapor deficit [mol mol^-1] from temperature [K],
pressure [Pa], and relative humidity [0--1].

# Examples

```jldoctest
julia> mole_frac_vapor_deficit(298.15, 101325.0, 0.7)
0.009371415642882845

julia> mole_frac_vapor_deficit(288.15, 5e4, 0.8)
0.006813124028440155
```
"""
mole_frac_vapor_deficit(temp, pressure, RH) =
    vapor_pressure_deficit(temp, RH) / pressure

end  # module
