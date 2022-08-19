# Canopy.jl: A model for plant canopy exchange of energy, water, carbon, and trace gases [WIP]

![Build status](https://github.com/wusunlab/Canopy.jl/actions/workflows/ci.yml/badge.svg)

Wu Sun (wsun@carnegiescience.edu)

A Julia package that provides functions used in biometeorology and land
biosphere--atmosphere interactions.

**WARNING: Under construction! Features not complete.**
You may check the [Development Plan](./dev-plan.md) for the current progress.

## Features (in planning)

**Canopy.jl** will cover functions that are necessary for process-based
simulations of water, energy, and photosynthesis fluxes in forest and crop
canopies. It will consist of modules of 1-D radiative transfer, leaf energy
balance, stomatal conductance, photosynthesis, chlorophyll fluorescence, trace
gas fluxes, and in-canopy eddy transport, etc.

## Dependencies

* Julia >= 1.0
* DocStringExtensions

## Installation

This package is not yet registered. You may install the development version
with `Pkg`:

```julia
using Pkg
Pkg.clone("https://github.com/wusunlab/Canopy.jl")
Pkg.build("Canopy")
```

## License

**Canopy.jl** is released under the [MIT License](./LICENSE).

## Documentation

[TO BE ADDED]

## Contributing

Contributions are welcome!

[`contributing.md` TO BE ADDED]
