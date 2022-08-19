# Development Plan (Tentative)

A laundry list of things to implement before version 1.0.

- [Development Plan (Tentative)](#development-plan-tentative)
  - [Physical constants (`Canopy.Constants`)](#physical-constants-canopyconstants)
  - [Water and water vapor properties (`Canopy.Water`)](#water-and-water-vapor-properties-canopywater)
  - [Dry and moist air properties (`Canopy.Air`)](#dry-and-moist-air-properties-canopyair)
  - [Physical chemistry](#physical-chemistry)
    - [Chemical kinetics](#chemical-kinetics)
    - [Gas solubility](#gas-solubility)
    - [Reactions](#reactions)
  - [Radiative transfer (`Canopy.RadTrans`)](#radiative-transfer-canopyradtrans)
    - [Blackbody radiation](#blackbody-radiation)
    - [Solar radiation and position](#solar-radiation-and-position)
    - [Canopy 1-D radiative transfer](#canopy-1-d-radiative-transfer)
  - [Transfer coefficients (`Canopy.Transfer`)](#transfer-coefficients-canopytransfer)
    - [Momentum transfer](#momentum-transfer)
    - [Heat transfer](#heat-transfer)
    - [Mass transfer](#mass-transfer)
  - [Water cycle](#water-cycle)
  - [Leaf processes](#leaf-processes)
    - [Leaf physical properties](#leaf-physical-properties)
    - [Leaf energy balance](#leaf-energy-balance)
    - [Transpiration](#transpiration)
    - [Photosynthetic light harvesting and electron transport](#photosynthetic-light-harvesting-and-electron-transport)
    - [Photosynthetic carbon assimilation](#photosynthetic-carbon-assimilation)
      - [C<sub>3</sub> photosynthesis](#csub3sub-photosynthesis)
      - [C<sub>4</sub> photosynthesis](#csub4sub-photosynthesis)
      - [CAM photosynthesis](#cam-photosynthesis)
      - [C<sub>2</sub> and intermediate-type photosynthesis](#csub2sub-and-intermediate-type-photosynthesis)
    - [Leaf respiration](#leaf-respiration)
      - [Photorespiration](#photorespiration)
      - [Mitochondrial respiration](#mitochondrial-respiration)
    - [Stomatal conductance](#stomatal-conductance)
      - [Empirical stomatal conductance models](#empirical-stomatal-conductance-models)
      - [Optimization-based stomatal conductance models](#optimization-based-stomatal-conductance-models)
    - [Mesophyll conductance](#mesophyll-conductance)
      - [Leaf hydraulics](#leaf-hydraulics)
    - [Leaf optics](#leaf-optics)
    - [Chlorophyll fluorescence](#chlorophyll-fluorescence)
    - [Leaf exchange of trace gases and isotope tracers](#leaf-exchange-of-trace-gases-and-isotope-tracers)
      - [Carbonyl sulfide](#carbonyl-sulfide)
      - [Ozone](#ozone)
      - [Ammonia](#ammonia)
      - [Biogenic volatile organic compounds](#biogenic-volatile-organic-compounds)
      - [Carbon and oxygen stable isotopes](#carbon-and-oxygen-stable-isotopes)
  - [Canopy processes](#canopy-processes)
  - [Soil processes](#soil-processes)
  - [Units](#units)

## Physical constants (`Canopy.Constants`)

* [x] Obtain necessary constants from the [2018 CODATA Fundamental Physical
  Constants](https://physics.nist.gov/cuu/Constants/index.html). [2021-07-06]

## Water and water vapor properties (`Canopy.Water`)

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

## Dry and moist air properties (`Canopy.Air`)

* [x] `air_molar`: Calculate the molar concentration of air [mol m^-3].
  [2018-08-12]
* [x] `air_density`: Calculate air density [kg m^-3]. [2018-08-12]

## Physical chemistry

### Chemical kinetics

* [x] `arrhenius`: Arrhenius equation for temperature dependence. [2018-09-20]
* [x] `q10_temp_dep`: *Q*<sub>10</sub> (exponential) type equation for
  temperature dependence. [2018-09-20]
* [x] `enzyme_temp_dep`: Temperature dependence of an enzyme reaction.
  [2018-09-20]
* [x] `enzyme_temp_optimum`: Calculate the temperature optimum of an enzyme
  reaction. [2018-09-20]

### Gas solubility

* [ ] `solub_gas`
* [x] `solub_co2`: CO<sub>2</sub> solubility in fresh water or seawater.
  [2018-09-21]
* [x] `solub_cos`: COS solubility in pure water. [2018-09-21]

### Reactions

* [x] `hydrolysis_cos` [2018-09-20]

(More to be added)

## Radiative transfer (`Canopy.RadTrans`)

### Blackbody radiation

* [x] `ephoton`: Calculate the energy of one photon. [2018-08-23]
* [x] `energy2photon`: Convert energy flux density to photon flux density.
  [2018-08-23]
* [x] `planck`: Planck's law. [2018-08-23]
* [x] `stefan_boltzmann`: Stefan--Boltzmann law. [2018-08-23]
* [x] `blackbody_temp`: Calculate blackbody temperature. [2018-08-23]

### Solar radiation and position

* [x] `eccentricity`: Calculate the eccentricity of the earth's orbit.
  [2018-09-20]
* [x] `solar_angle`: Calculate the solar position. [2018-09-20]
* [x] `atmos_refrac`: Calculate atmospheric refraction effect on the solar
  zenith angle. [2018-09-20]

### Canopy 1-D radiative transfer

## Transfer coefficients (`Canopy.Transfer`)

### Momentum transfer

* [x] `dyn_visc_dryair`: Dynamic viscosity of dry air. [2018-09-24]
* [x] `dyn_visc_vapor`: Dynamic viscosity of water vapor. [2018-09-24]
* [x] `dyn_visc_moistair`: Dynamic viscosity of moist air. [2018-09-24]

### Heat transfer

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

### Mass transfer

* [x] `diffus_air`: Gas diffusivity in air. [2018-09-21]
* [x] `diffus_water`: Gas diffusivity in water. [2018-09-21]
* [x] `diffus_soil_air`: Gas diffusivity in soil air. [2018-09-21]
* [x] `diffus_soil_water`: Gas diffusivity in soil water. [2018-09-21]
* [x] `diffus_soil`: Dual-phase gas diffusivity in soil. [2018-09-21]

## Water cycle

* [x] `psychromet`: Calculate the psychrometric constant. [2018-09-25]
* [x] `penman_monteith`: Calculate latent heat flux or evapotranspiration using
  Penman--Monteith equation. [2018-09-25]
* [x] `cond_sfc`: Calculate canopy surface conductance from the inverted
  Penman--Monteith equation. [2018-09-25]

## Leaf processes

### Leaf physical properties

### Leaf energy balance

* [ ] `bl_cond_heat`
* [ ] `bl_cond_vapor`
* [ ] `PAR_to_shortwave`
* [ ] `sensible_heat`
* [ ] `leaf_vapor_deficit`
* [ ] `transpiration`
* [ ] `latent_heat`
* [ ] `energy_imbalance`

### Transpiration

### Photosynthetic light harvesting and electron transport

### Photosynthetic carbon assimilation

#### C<sub>3</sub> photosynthesis

#### C<sub>4</sub> photosynthesis

#### CAM photosynthesis

#### C<sub>2</sub> and intermediate-type photosynthesis

### Leaf respiration

#### Photorespiration

#### Mitochondrial respiration

### Stomatal conductance

#### Empirical stomatal conductance models

#### Optimization-based stomatal conductance models

### Mesophyll conductance

#### Leaf hydraulics

### Leaf optics

### Chlorophyll fluorescence

### Leaf exchange of trace gases and isotope tracers

#### Carbonyl sulfide

#### Ozone

#### Ammonia

#### Biogenic volatile organic compounds

#### Carbon and oxygen stable isotopes

## Canopy processes

## Soil processes

## Units

* [x] `c2k`: Convert Celsius to Kelvin. [2018-09-21]
* [x] `k2c`: Convert Kelvin to Celsius. [2018-09-21]

<style type="text/css">
  body {
    margin: auto;
    max-width: 44em;
    font-family: Calibri, sans-serif;
    font-size: 18pt;
  }

  /* automatic heading numbering */
  h1 { counter-reset: h2counter; }
  h2 { counter-reset: h3counter; }
  h3 { counter-reset: h4counter; }
  h4 { counter-reset: h5counter; }
  h5 { counter-reset: h6counter; }
  h6 { }
  h2:before {
    counter-increment: h2counter;
    content: counter(h2counter) ".\0000a0\0000a0";
  }
  h3:before {
    counter-increment: h3counter;
    content: counter(h2counter) "."
             counter(h3counter) ".\0000a0\0000a0";
  }
  h4:before {
    counter-increment: h4counter;
    content: counter(h2counter) "."
             counter(h3counter) "."
             counter(h4counter) ".\0000a0\0000a0";
  }
  h5:before {
    counter-increment: h5counter;
    content: counter(h2counter) "."
             counter(h3counter) "."
             counter(h4counter) "."
             counter(h5counter) ".\0000a0\0000a0";
  }
  h6:before {
    counter-increment: h6counter;
    content: counter(h2counter) "."
             counter(h3counter) "."
             counter(h4counter) "."
             counter(h5counter) "."
             counter(h6counter) ".\0000a0\0000a0";
  }
</style>
