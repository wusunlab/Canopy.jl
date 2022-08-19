# Style guide

## General styles

* Use four spaces for indentation.
* Maximum line length is 79 characters except URL.
* Variable and function names shall start with a lowercase letter and follow
  the `snake_case`.
* Module and type names shall start with an uppercase letter and follow the
  `UpperCamelCase`.
* Write idiomatic Julia.
* Every file is a module. This is intended to avoid the complication that a
  file may contain multiple modules and a module may be scattered in multiple
  files, because Julia imposes little on a module.
* Avoid premature optimization, but do pay attention to the
  [performance tips](https://docs.julialang.org/en/v1/manual/performance-tips/).

## Variable naming

Standard names for arguments

| variable name | meaning |
| ------------- | ------- |
| `pressure`    | ambient pressure [Pa] |
| `temp`        | temperature [K] |
| `temp_ref`    | reference temperature [K] |
| `rh`          | relative humidity [-], 0 to 1 |
| `vpd`         | vapor pressure deficit [Pa] |
| `wl`          | wavelength [m] |

Other common abbreviations

* `dep`: dependence
* `opt`: optimal, optimum, optimize, optimization, etc.
* `p` or `params`: parameters or a set of parametric arguments to be unpacked
