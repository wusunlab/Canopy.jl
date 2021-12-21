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

* [x] Obtain necessary constants from the [2018 CODATA Fundamental Physical
  Constants](https://physics.nist.gov/cuu/Constants/index.html). [2021-07-06]

## 2. Water and water vapor properties (`Canopy.Water`)

* [x] `water_density`: Water density. [2018-08-10]
* [x] `water_dissoc`: Dissociation (a.k.a. self-ionization) coefficient of
  water. [2018-08-10]
* [x] `latent_heat_vap`: Latent heat of vaporization. [2018-08-10]
* [x] `latent_heat_sub`: Latent heat of sublimation. [2018-08-10]
* [x] `e_sat`: Saturation vapor pressure of liquid water. [2018-08-10]
* [x] `e_sat_ice`: Saturation vapor pressure of water ice. [2018-08-10]
* [x] `e_sat_deriv`: Temperature derivative of the saturation vapor pressure of
  liquid water. [2018-08-10]
* [x] `e_sat_ice_deriv`: Temperature derivative of the saturation vapor
  pressure of water ice. [2018-08-10]
* [x] `vapor_deficit`: Water vapor pressure deficit. [2018-08-10]
* [x] `vapor_mole_frac`: Water vapor mole fraction. [2018-08-10]
* [x] `vapor_deficit_mole_frac`: Water vapor deficit in mole fraction.
  [2018-08-10]

## 3. Dry and moist air properties (`Canopy.Air`)

* [x] `air_molar`: Calculate the molar concentration of air [mol m^-3].
  [2018-08-12]
* [x] `air_density`: Calculate air density [kg m^-3]. [2018-08-12]

## 4. Physical chemistry

### 4.1 Chemical kinetics

* [x] `arrhenius`: Arrhenius equation for temperature dependence. [2018-09-20]
* [x] `q10_temp_dep`: *Q*<sub>10</sub> (exponential) type equation for
  temperature dependence. [2018-09-20]
* [x] `enzyme_temp_dep`: Temperature dependence of an enzyme reaction.
  [2018-09-20]
* [x] `enzyme_temp_optimum`: Calculate the temperature optimum of an enzyme
  reaction. [2018-09-20]

### 4.2 Gas solubility

* [ ] `solub_gas`
* [x] `solub_co2`: CO<sub>2</sub> solubility in fresh water or seawater.
  [2018-09-21]
* [x] `solub_cos`: COS solubility in pure water. [2018-09-21]

### 4.3 Reactions

* [x] `hydrolysis_cos` [2018-09-20]

(More to be added)

## 5. Radiative transfer (`Canopy.RadTrans`)

### 5.1 Blackbody radiation

* [x] `ephoton`: Calculate the energy of one photon. [2018-08-23]
* [x] `energy2photon`: Convert energy flux density to photon flux density.
  [2018-08-23]
* [x] `planck`: Planck's law. [2018-08-23]
* [x] `stefan_boltzmann`: Stefan--Boltzmann law. [2018-08-23]
* [x] `blackbody_temp`: Calculate blackbody temperature. [2018-08-23]

### 5.2 Solar radiation and position

* [x] `eccentricity`: Calculate the eccentricity of the earth's orbit.
  [2018-09-20]
* [x] `solar_angle`: Calculate the solar position. [2018-09-20]
* [x] `atmos_refrac`: Calculate atmospheric refraction effect on the solar
  zenith angle. [2018-09-20]

### 5.3 Canopy 1-D radiative transfer

## 6. Transfer coefficients (`Canopy.Transfer`)

### 6.1 Momentum transfer

* [x] `dyn_visc_dryair`: Dynamic viscosity of dry air. [2018-09-24]
* [x] `dyn_visc_vapor`: Dynamic viscosity of water vapor. [2018-09-24]
* [x] `dyn_visc_moistair`: Dynamic viscosity of moist air. [2018-09-24]

### 6.2 Heat transfer

* [x] `therm_cond_dryair`: Thermal conductivity of dry air. [2018-09-24]
* [x] `heat_cap_dryair`: Isobaric heat capacity of dry air. [2018-09-24]
* [x] `therm_cond_vapor`: Thermal conductivity of water vapor. [2018-09-24]
* [x] `heat_cap_vapor`: Isobaric heat capacity of water vapor. [2018-09-24]
* [x] `therm_cond_moistair`: Thermal conductivity of moist air. [2018-09-24]
* [x] `heat_cap_moistair`: Isobaric heat capacity of moist air. [2018-09-24]
* [x] `heat_cap_mass_moistair`: Isobaric heat capacity (per unit mass) of moist
  air. [2018-09-24]
* [x] `therm_diff_moistair`: Thermal diffusivity of moist air. [2018-09-24]
* [x] `prandtl`: Prandtl number of moist air. [2018-09-24]

### 6.3 Mass transfer

* [x] `diffus_air`: Gas diffusivity in air. [2018-09-21]
* [x] `diffus_water`: Gas diffusivity in water. [2018-09-21]
* [x] `diffus_soil_air`: Gas diffusivity in soil air. [2018-09-21]
* [x] `diffus_soil_water`: Gas diffusivity in soil water. [2018-09-21]
* [x] `diffus_soil`: Dual-phase gas diffusivity in soil. [2018-09-21]

## 7. Terrestrial water cycle

* [x] `psychromet`: Calculate the psychrometric constant. [2018-09-25]
* [x] `penman_monteith`: Calculate latent heat flux or evapotranspiration using
  Penman--Monteith equation. [2018-09-25]
* [x] `cond_sfc`: Calculate canopy surface conductance from the inverted
  Penman--Monteith equation. [2018-09-25]

## 8. Leaf and canopy processes

### 8.1 Leaf energy balance

* [ ] `bl_cond_heat`
* [ ] `bl_cond_vapor`
* [ ] `PAR_to_shortwave`
* [ ] `sensible_heat`
* [ ] `leaf_vapor_deficit`
* [ ] `transpiration`
* [ ] `latent_heat`
* [ ] `energy_imbalance`

### 8.2 Photosynthesis

### 8.3 Stomatal conductance

### 8.4 Leaf and xylem water potential

## 9. Soil processes

## 10. Units

* [x] `c2k`: Convert Celsius to Kelvin. [2018-09-21]
* [x] `k2c`: Convert Kelvin to Celsius. [2018-09-21]
