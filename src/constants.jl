# Canopy.jl
#
# Copyright (c) 2018--2021 Wu Sun
# License: MIT
"""
A list of physical constants.

# References

## CODATA 2018 constants

* [MNT16a] Mohr, P. J., Newell, D. B., & Taylor, B. N. (2016). CODATA
  recommended values of the fundamental physical constants: 2014.
  _Rev. Mod. Phys._ 88, 035009. <https://doi.org/10.1103/RevModPhys.88.035009>
* [MNT16b] Mohr, P. J., Newell, D. B., and Taylor, B. N. (2016). CODATA
  recommended values of the fundamental physical constants: 2014.
  _J. Phys. Chem. Ref. Data_ 45, 043102. <https://doi.org/10.1063/1.4954402>
* [MNTT18] Mohr, P. J., Newell, D. B., Taylor, B. N., and Tiesinga, E. (2018).
  Data and analysis for the CODATA 2017 special fundamental constants
  adjustment. _Metrologia_ 55, 125–146.
  <https://doi.org/10.1088/1681-7575/aa99bc>

## Molar masses

* [HBCP] Rumble, J. (eds.) (2017). _CRC Handbook of Chemistry and Physics_
  (98th ed.). CRC Press, Boca Raton, FL, USA. ISBN: 9781498784542.
  Retrieved from <http://hbcponline.com/faces/contents/ContentsSearch.xhtml>
  on 2018-06-12.
"""
module Constants

# Notes
#
# 1. Use lowercase variable names, except when there is already a commonly used
#    notation otherwise.
# 2. Keep the long names self-explanatory.

export c,
    h,
    N_A,
    k_B,
    sigma_SB,
    c_1,
    c_1L,
    c_2,
    R,
    g,
    atm,
    T_0,
    kappa,
    M_w,
    M_c,
    M_d,
    cp_d

"""Speed of light in the vacuum [m s^-1]."""
const c = 2.997_924_58e8

"""Planck's constant [J s]."""
const h = 6.626_070_15e-34

"""First radiation constant \$2\\pi hc^2\$ [W m^2]."""
const c_1 = 3.741_771_852e-16

"""First radiation constant for spectral radiance \$2hc^2\$ [W m^-2 sr^-1]."""
const c_1L = 1.191_042_972e-16

"""Second radiation constant \$ hc / k\$ [m K]."""
const c_2 = 1.438_776_877e-2

"""Stefan--Boltzmann constant [W m^-2 K^-4]."""
const sigma_SB = 5.670_374_419e-8

"""Boltzmann constant [J K^-1]."""
const k_B = 1.380_649e-23

"""Avogadro constant [mol^-1]."""
const N_A = 6.022_140_76e23

"""Molar gas constant [J mol^-1 K^-1]."""
const R = 8.314_462_618

"""Standard atmospheric pressure [Pa]."""
const atm = 1.013_25e5

"""Standard acceleration of gravity [m s^-2]."""
const g = 9.806_65

"""Zero Celsius [K]."""
const T_0 = 273.15

"""Von Kármán's constant [-]."""
const kappa = 0.40

"""Molar mass of water [kg mol^-1]."""
const M_w = 18.015_28e-3

"""Molar mass of CO2 [kg mol^-1]."""
const M_c = 44.010e-3

"""Molar mass of dry air [kg mol^-1]."""
const M_d = 28.9645e-3

"""Molar isobaric specific heat capacity of dry air [J K^-1 mol^-1]."""
const cp_d = 1.004e3 * M_d
# Note: using a constant value has less than 2% error between -40 and 60°C

"""A dictionary of physical constants."""
const constants = Dict{String, Float64}(
    "speed of light" => c,
    "Planck constant" => h,
    "Avogadro constant" => N_A,
    "Boltzmann constant" => k_B,
    "Stefan-Boltzmann constant" => sigma_SB,
    "first radiation constant" => c_1,
    "first radiation constant for spectral radiance" => c_1L,
    "second radiation constant" => c_2,
    "molar gas constant" => R,
    "standard acceleration of gravity" => g,
    "standard atmosphere" => atm,
    "zero Celsius" => T_0,
    "von Karman constant" => kappa,
    "molar mass of water" => M_w,
    "molar mass of CO2" => M_c,
    "molar mass of dry air" => M_d,
    "molar isobaric specific heat capacity of dry air" => cp_d)

end  # module
