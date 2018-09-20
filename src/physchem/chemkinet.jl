"""
Basic chemical kinetics.

* [`arrhenius`](@ref)
* [`q10_func`](@ref)
* [`enzyme_temp_dependence`](@ref)
* [`enzyme_temp_optimum`](@ref)
"""
module ChemKinet

include("../docstring_style.jl")

using Canopy.Constants: R

export arrhenius,
    q10_func,
    enzyme_temp_dependence,
    enzyme_temp_optimum

"""
Calculate the ratio of reaction rate at a given temperature (`temp`) to that at
a reference temperature (`ref`) using the Arrhenius function. The activation
energy is given in `E_act`.

```math
\\dfrac{k}{k_\\mathrm{ref}} = \\exp\\left[ -\\dfrac{E_\\mathrm{act}}{R} \\cdot
\\left( \\dfrac{1}{T} - \\dfrac{1}{T_\\mathrm{ref}}\\right) \\right]
```

# Examples

```jldoctest
julia> arrhenius(283.15, 298.15, 5e4)
0.3435223011604158
```
"""
arrhenius(temp, ref, E_act) = exp(E_act * (temp - ref) / (R * ref * temp))

"""
Calculate the ratio of reaction rate at a given temperature (`temp`) to that at
a reference temperature (`ref`) using an exponential function defined by a
`q10` value.

```math
\\dfrac{k}{k_\\mathrm{ref}} = \\exp\\left( Q_{10} \\cdot
\\dfrac{T - T_\\mathrm{ref}}{10\\ \\mathrm{K}} \\right)
```

# Examples

```jldoctest
julia> q10_func(283.15, 298.15, 2.)
0.3535533905932738
```
"""
q10_func(temp, ref, q10) = q10 ^ (0.1 * (temp - ref))

"""
A helper function to calculate the enzyme reaction rate at a given temperature
(`temp`) in an *arbitrary unit*.

```math
f(T) = \\frac{\\exp\\left(-\\frac{\\Delta G_\\mathrm{a}}{R T}\\right)}{
    1 + \\exp\\left(
        -\\frac{\\Delta H_\\mathrm{d} - T\\Delta S_\\mathrm{d}}{RT}\\right)}
```

# Arguments

* `temp`: Current temperature [K].
* `Delta_G_a`: The standard Gibbs free energy of activation of the active state
  of the enzyme [J mol^-1].
* `Delta_H_d`: The standard enthalpy change when the enzyme switches from the
  active to the deactivated state [J mol^-1].
* `Delta_S_d`: The standard entropy change when the enzyme switches from the
  active to the deactivated state [J mol^-1 K^-1].

!!! note

    This function is reserved for internal calls. Use
    [`enzyme_temp_dependence`](@ref) for calculation.
"""
f_enzyme_temp_dependence(temp, Delta_G_a, Delta_H_d, Delta_S_d) =
    exp(- Delta_G_a / (R * temp)) /
    (1. + exp((Delta_S_d - Delta_H_d / temp) / R))

"""
Calculate the ratio of reaction rate at a given temperature (`temp`) to that at
a reference temperature (`ref`) for an enzyme reaction with a temperature
optimum.

```math
\\frac{V_\\mathrm{max}(T)}{V_\\mathrm{max}(T_\\mathrm{ref})} =
\\frac{f(T)}{f(T_\\mathrm{ref})} \\text{, where}\\quad f(T) =
\\frac{\\exp\\left(-\\frac{\\Delta G_\\mathrm{a}}{RT}\\right)}{1 + \\exp\\left(
-\\frac{\\Delta H_\\mathrm{d} - T\\Delta S_\\mathrm{d}}{RT}\\right)}
```

# Arguments

* `temp`: Current temperature [K].
* `ref`: Reference temperature [K].
* `Delta_G_a`: The standard Gibbs free energy of activation of the active state
  of the enzyme [J mol^-1].
* `Delta_H_d`: The standard enthalpy change when the enzyme switches from the
  active to the deactivated state [J mol^-1].
* `Delta_S_d`: The standard entropy change when the enzyme switches from the
  active to the deactivated state [J mol^-1 K^-1].

# References

* [JEW42] Johnson, F. H., Eyring, H., and Williams, R. W. (1942). The nature of
  enzyme inhibitions in bacterial luminescence: sulfanilamide, urethane,
  temperature and pressure. *J. Cellul. Comparat. Physiol.*, 20(3), 247--268.
  <https://doi.org/10.1002/jcp.1030200302>.
* [SD77] Sharpe, P. J. H. and DeMichele, D. W. (1977). Reaction kinetics of
  poikilotherm development. *J. Theoret. Biol.*, 64(4), 649--670.
  <https://doi.org/10.1016/0022-5193(77)90265-X>.
* [PED04] Peterson, M. E., Eisenthal, R., Danson, M. J., Spence, A., and
  Daniel, R. M. (2004). A new intrinsic thermal parameter for enzymes reveals
  true temperature optima. *J. Biol. Chem.*, 279(20), 20,717--20,722.
  <https://doi.org/10.1074/jbc.m309143200>.

!!! note

    Interpretations of the thermodynamic parameters in this equation may differ
    in the literature, but the mathematical form remains largely the same.

# Examples

```jldoctest
julia> enzyme_temp_dependence(283.15, 298.15, 4e4, 2e5, 660.)
0.539321882992312
```

# See also

[`enzyme_temp_optimum`](@ref)
"""
enzyme_temp_dependence(temp, ref, Delta_G_a, Delta_H_d, Delta_S_d) =
    f_enzyme_temp_dependence(temp, Delta_G_a, Delta_H_d, Delta_S_d) /
    f_enzyme_temp_dependence(ref, Delta_G_a, Delta_H_d, Delta_S_d)

"""
Calculates the temperature optimum of an enzyme reaction [K].

```math
T_\\mathrm{opt} = \\dfrac{\\Delta H_\\mathrm{d}}{
    \\Delta S_\\mathrm{d} +
    R \\ln \\left(\\Delta H_\\mathrm{d} / \\Delta G_\\mathrm{a} - 1 \\right)}
```

# Arguments

* `Delta_G_a`: The standard Gibbs free energy of activation of the active state
  of the enzyme [J mol^-1].
* `Delta_H_d`: The standard enthalpy change when the enzyme switches from the
  active to the deactivated state [J mol^-1].
* `Delta_S_d`: The standard entropy change when the enzyme switches from the
  active to the deactivated state [J mol^-1 K^-1].

# Examples

```jldoctest
julia> enzyme_temp_optimum(4e4, 2e5, 660.)
297.8289954609335
```

# See also

[`enzyme_temp_dependence`](@ref)
"""
enzyme_temp_optimum(Delta_G_a, Delta_H_d, Delta_S_d) =
    Delta_H_d / (Delta_S_d + R * log(Delta_H_d / Delta_G_a - 1.))

end  # module
