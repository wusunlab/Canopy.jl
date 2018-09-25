# Development Plan (Tentative)

A laundry list of things to implement before version 1.0.

<!-- TOC -->

- [1. Physical constants (`Canopy.Constants`)](#1-physical-constants-canopyconstants)
- [2. Water and water vapor properties (`Canopy.Water`)](#2-water-and-water-vapor-properties-canopywater)
- [3. Dry and moist air properties (`Canopy.Air`)](#3-dry-and-moist-air-properties-canopyair)
- [4. Physical chemistry](#4-physical-chemistry)
    - [4.1 Chemical kinetics](#41-chemical-kinetics)
    - [4.2 Gas solubility](#42-gas-solubility)
    - [4.3 Reactions](#43-reactions)
- [5. Radiative transfer (`Canopy.RadTrans`)](#5-radiative-transfer-canopyradtrans)
    - [5.1 Blackbody radiation](#51-blackbody-radiation)
    - [5.2 Solar radiation and position](#52-solar-radiation-and-position)
    - [5.3 Canopy 1-D radiative transfer](#53-canopy-1-d-radiative-transfer)
- [6. Transfer coefficients (`Canopy.Transfer`)](#6-transfer-coefficients-canopytransfer)
    - [6.1 Momentum transfer](#61-momentum-transfer)
    - [6.2 Heat transfer](#62-heat-transfer)
    - [6.3 Mass transfer](#63-mass-transfer)
- [7. Terrestrial water cycle](#7-terrestrial-water-cycle)
- [8. Leaf and canopy processes](#8-leaf-and-canopy-processes)
    - [8.1 Leaf energy balance](#81-leaf-energy-balance)
    - [8.2 Photosynthesis](#82-photosynthesis)
    - [8.3 Stomatal conductance](#83-stomatal-conductance)
    - [8.4 Leaf and xylem water potential](#84-leaf-and-xylem-water-potential)
- [9. Soil processes](#9-soil-processes)
- [10. Units](#10-units)

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

### 4.1 Chemical kinetics

- [X] `arrhenius`: Arrhenius equation for temperature dependence. [2018-09-20]
- [X] `q10_func`: Q<sub>10</sub> (exponential) type equation for temperature
  dependence. [2018-09-20]
- [X] `enzyme_temperature_dependence`: Temperature dependence of an enzyme
  reaction. [2018-09-20]
- [X] `enzyme_temperature_optimum`: Calculate the temperature optimum of an
  enzyme reaction. [2018-09-20]

### 4.2 Gas solubility

- [ ] `solub_gas`
- [X] `solub_co2`: CO2 solubility in fresh water or seawater. [2018-09-21]
- [X] `solub_cos`: COS solubility in pure water. [2018-09-21]

### 4.3 Reactions

- [X] `hydrolysis_cos` [2018-09-20]

(More to be added)

## 5. Radiative transfer (`Canopy.RadTrans`)

### 5.1 Blackbody radiation

- [X] `ephoton`: Calculate the energy of one photon. [2018-08-23]
- [X] `energy2photon`: Convert energy flux density to photon flux density.
  [2018-08-23]
- [X] `planck`: Planck's law. [2018-08-23]
- [X] `stefan_boltzmann`: Stefan--Boltzmann law. [2018-08-23]
- [X] `blackbody_temp`: Calculate blackbody temperature. [2018-08-23]

### 5.2 Solar radiation and position

- [X] `eccentricity`: Calculate the eccentricity of the earth's orbit.
  [2018-09-20]
- [X] `solar_angle`: Calculate the solar position. [2018-09-20]
- [X] `atmospheric_refraction`: Calculate atmospheric refraction effect on
  solar zenith angle. [2018-09-20]

### 5.3 Canopy 1-D radiative transfer

## 6. Transfer coefficients (`Canopy.Transfer`)

### 6.1 Momentum transfer

- [X] `dyn_visc_dryair`: Dynamic viscosity of dry air. [2018-09-24]
- [X] `dyn_visc_vapor`: Dynamic viscosity of water vapor. [2018-09-24]
- [X] `dyn_visc_moistair`: Dynamic viscosity of moist air. [2018-09-24]

### 6.2 Heat transfer

- [X] `therm_cond_dryair`: Thermal conductivity of dry air. [2018-09-24]
- [X] `heat_cap_dryair`: Isobaric heat capacity of dry air. [2018-09-24]
- [X] `therm_cond_vapor`: Thermal conductivity of water vapor. [2018-09-24]
- [X] `heat_cap_vapor`: Isobaric heat capacity of water vapor. [2018-09-24]
- [X] `therm_cond_moistair`: Thermal conductivity of moist air. [2018-09-24]
- [X] `heat_cap_moistair`: Isobaric heat capacity of moist air. [2018-09-24]
- [X] `heat_cap_mass_moistair`: Isobaric heat capacity (per unit mass) of moist
  air. [2018-09-24]
- [X] `therm_diff_moistair`: Thermal diffusivity of moist air. [2018-09-24]
- [X] `prandtl`: Prandtl number of moist air. [2018-09-24]

### 6.3 Mass transfer

- [X] `diffus_air`: Gas diffusivity in air. [2018-09-21]
- [X] `diffus_water`: Gas diffusivity in water. [2018-09-21]
- [X] `diffus_soil_air`: Gas diffusivity in soil air. [2018-09-21]
- [X] `diffus_soil_water`: Gas diffusivity in soil water. [2018-09-21]
- [X] `diffus_soil`: Dual-phase gas diffusivity in soil. [2018-09-21]

## 7. Terrestrial water cycle

- [X] `psychrometric_constant`: Calculate the psychrometric constant.
  [2018-09-25]
- [X] `penman_monteith`: Calculate latent heat flux or evapotranspiration using
  Penman--Monteith equation. [2018-09-25]

## 8. Leaf and canopy processes

### 8.1 Leaf energy balance

- [ ] `bl_cond_heat`
- [ ] `bl_cond_vapor`
- [ ] `PAR_to_shortwave`
- [ ] `sensible_heat`
- [ ] `leaf_vapor_pressure_deficit`
- [ ] `transpiration`
- [ ] `latent_heat`
- [ ] `energy_imbalance`

### 8.2 Photosynthesis

### 8.3 Stomatal conductance

### 8.4 Leaf and xylem water potential

## 9. Soil processes

## 10. Units

- [X] `c2k`: Convert Celsius to Kelvin. [2018-09-21]
- [X] `k2c`: Convert Kelvin to Celsius. [2018-09-21]
