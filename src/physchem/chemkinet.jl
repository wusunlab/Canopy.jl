"""
Basic chemical kinetics.

* [`arrhenius`](@ref)
* [`q10_temp_dep`](@ref)
* [`enzyme_temp_dep`](@ref)
* [`enzyme_temp_optimum`](@ref)
"""
module ChemKinet

include("../docstring_style.jl")

using Canopy.Constants: R

export arrhenius, q10_temp_dep, enzyme_temp_dep, enzyme_temp_optimum

"""
Calculate the ratio of reaction rate at a given temperature (`temp`) to that at
a reference temperature (`temp_ref`) using the Arrhenius function. The
activation energy is given by `E_act`.

```math
\\dfrac{k}{k_\\mathrm{ref}} = \\exp\\left[ -\\dfrac{E_\\mathrm{act}}{R} \\cdot
\\left( \\dfrac{1}{T} - \\dfrac{1}{T_\\mathrm{ref}}\\right) \\right]
```

# Examples

```jldoctest
julia> arrhenius(5e4, 298.15, 283.15)
0.3435223011604158
```
"""
function arrhenius(E_act, temp_ref, temp)
    exp(E_act * (temp - temp_ref) / (R * temp_ref * temp))
end

"""
Calculate the ratio of reaction rate at a given temperature (`temp`) to that at
a reference temperature (`temp_ref`) using an exponential function defined by a
`q10` value.

```math
\\dfrac{k}{k_\\mathrm{ref}} = \\exp\\left( Q_{10} \\cdot
\\dfrac{T - T_\\mathrm{ref}}{10\\ \\mathrm{K}} \\right)
```

# Examples

```jldoctest
julia> q10_temp_dep(2.0, 298.15, 283.15)
0.3535533905932738
```
"""
function q10_temp_dep(q10, temp_ref, temp)
    q10^(0.1 * (temp - temp_ref))
end

"""
A helper function to calculate the enzyme reaction rate at a given temperature
(`temp`) in an _arbitrary unit_.

```math
f(T) = \\dfrac{\\exp\\left(-\\dfrac{\\Delta G_\\mathrm{a}}{R T}\\right)}{
    1 + \\exp\\left(
        -\\dfrac{\\Delta H_\\mathrm{d} - T\\Delta S_\\mathrm{d}}{RT}\\right)}
```

# Arguments

* `Delta_G_a`: The standard Gibbs free energy of activation of the active state
  of the enzyme [J mol^-1].
* `Delta_H_d`: The standard enthalpy change when the enzyme switches from the
  active to the deactivated state [J mol^-1].
* `Delta_S_d`: The standard entropy change when the enzyme switches from the
  active to the deactivated state [J mol^-1 K^-1].
* `temp`: Current temperature [K].

!!! note

    This function is reserved for internal calls. Use
    [`enzyme_temp_dep`](@ref) for calculation.
"""
function f_enzyme_temp_dep(Delta_G_a, Delta_H_d, Delta_S_d, temp)
    exp(-Delta_G_a / (R * temp)) /
    (1.0 + exp((Delta_S_d - Delta_H_d / temp) / R))
end

"""
Calculate the ratio of reaction rate at a given temperature (`temp`) to that at
a reference temperature (`temp_ref`) for an enzyme reaction with a temperature
optimum.

```math
\\dfrac{V_\\mathrm{max}(T)}{V_\\mathrm{max}(T_\\mathrm{ref})} =
\\dfrac{f(T)}{f(T_\\mathrm{ref})} \\text{, where}\\quad f(T) =
\\dfrac{\\exp\\left(-\\dfrac{\\Delta G_\\mathrm{a}}{RT}\\right)}{1 + \\exp
\\left(-\\dfrac{\\Delta H_\\mathrm{d} - T\\Delta S_\\mathrm{d}}{RT}\\right)}
```

# Arguments

* `Delta_G_a`: The standard Gibbs free energy of activation of the active state
  of the enzyme [J mol^-1].
* `Delta_H_d`: The standard enthalpy change when the enzyme switches from the
  active to the deactivated state [J mol^-1].
* `Delta_S_d`: The standard entropy change when the enzyme switches from the
  active to the deactivated state [J mol^-1 K^-1].
* `temp_ref`: Reference temperature [K].
* `temp`: Current temperature [K].

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
julia> enzyme_temp_dep(4e4, 2e5, 660.0, 298.15, 283.15)
0.539321882992312
```

# See also

[`enzyme_temp_optimum`](@ref)
"""
function enzyme_temp_dep(Delta_G_a, Delta_H_d, Delta_S_d, temp_ref, temp)
    f_enzyme_temp_dep(temp, Delta_G_a, Delta_H_d, Delta_S_d) /
    f_enzyme_temp_dep(temp_ref, Delta_G_a, Delta_H_d, Delta_S_d)
end

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
julia> enzyme_temp_optimum(4e4, 2e5, 660.0)
297.8289954609335
```

# See also

[`enzyme_temp_dep`](@ref)
"""
function enzyme_temp_optimum(Delta_G_a, Delta_H_d, Delta_S_d)
    Delta_H_d / (Delta_S_d + R * log(Delta_H_d / Delta_G_a - 1.0))
end

end  # module
