# Development Plan (Tentative)

A laundry list of things to implement before version 1.0.

<!-- TOC -->

- [1. Physical constants (`Canopy.Constants`)](#1-physical-constants-canopyconstants)
- [2. Water and water vapor properties (`Canopy.Water`)](#2-water-and-water-vapor-properties-canopywater)
- [3. Dry and moist air properties (`Canopy.Air`)](#3-dry-and-moist-air-properties-canopyair)
- [4. Physical chemistry](#4-physical-chemistry)
    - [4.1. Gas solubility](#41-gas-solubility)
    - [4.2. Temperature dependence of reactions](#42-temperature-dependence-of-reactions)
- [5. Radiative transfer (`Canopy.RadTrans`)](#5-radiative-transfer-canopyradtrans)
    - [5.1 Blackbody radiation](#51-blackbody-radiation)
    - [5.2 Solar radiation and position](#52-solar-radiation-and-position)
    - [5.3 Canopy 1-D radiative transfer](#53-canopy-1-d-radiative-transfer)
- [6. Heat and mass transfer](#6-heat-and-mass-transfer)
- [7. Water transport](#7-water-transport)
- [8. Leaf and canopy processes](#8-leaf-and-canopy-processes)
- [9. Soil processes](#9-soil-processes)

<!-- /TOC -->

## 1. Physical constants (`Canopy.Constants`)

- [X] Obtain necessary constants from [CODATA14 Fundamental Physical
  Constants](https://physics.nist.gov/cuu/Constants/index.html). [2018-08-10]

## 2. Water and water vapor properties (`Canopy.Water`)

- [X] `water_density`: Water density. [2018-08-10]
- [X] `water_dissoc`: Dissociation (a.k.a. self-ionization) coefficient of
  water. [2018-08-10]
- [X] `latent_heat_vap`: Latent heat of vaporization. [2018-08-10]
- [X] `latent_heat_sub`: Latent heat of sublimation. [2018-08-10]
- [X] `e_sat`: Saturation vapor pressure of liquid water. [2018-08-10]
- [X] `e_sat_ice`: Saturation vapor pressure of water ice. [2018-08-10]
- [X] `e_sat_prime`: Temperature derivative of the saturation vapor pressure of
  liquid water. [2018-08-10]
- [X] `e_sat_ice_prime`: Temperature derivative of the saturation vapor
  pressure of water ice. [2018-08-10]
- [X] `vapor_pressure_deficit`: Water vapor pressure deficit. [2018-08-10]
- [X] `vapor_mole_frac`: Water vapor mole fraction. [2018-08-10]
- [X] `mole_frac_vapor_deficit`: Mole-fraction water vapor deficit.
  [2018-08-10]

## 3. Dry and moist air properties (`Canopy.Air`)

- [X] `air_concentration`: Calculate the molar concentration of air [mol m^-3].
  [2018-08-12]
- [X] `air_density`: Calculate air density [kg m^-3]. [2018-08-12]

## 4. Physical chemistry

### 4.1. Gas solubility

### 4.2. Temperature dependence of reactions

## 5. Radiative transfer (`Canopy.RadTrans`)

### 5.1 Blackbody radiation

- [X] `ephoton`: Calculate the energy of one photon. [2018-08-23]
- [X] `energy2photon`: Convert energy flux density to photon flux density.
  [2018-08-23]
- [X] `planck`: Planck's law. [2018-08-23]
- [X] `stefan_boltzmann`: Stefan--Boltzmann law. [2018-08-23]
- [X] `blackbody_temp`: Calculate blackbody temperature. [2018-08-23]

### 5.2 Solar radiation and position

### 5.3 Canopy 1-D radiative transfer

## 6. Heat and mass transfer

Transfer coefficients

- [ ] `dyn_visc_vapor`
- [ ] `therm_cond_vapor`
- [ ] `heat_cap_vapor`
- [ ] `diffusivity_vapor`
- [ ] `dyn_visc_dryair`
- [ ] `therm_cond_dryair`
- [ ] `heat_cap_dryair`
- [ ] `dyn_visc_moistair`
- [ ] `therm_cond_moistair`
- [ ] `heat_cap_moistair`
- [ ] `heat_cap_mass_moistair`
- [ ] `therm_diff_moistair`
- [ ] `prandtl`

## 7. Water transport

## 8. Leaf and canopy processes

## 9. Soil processes
