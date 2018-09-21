module PhysChem

include("chemkinet.jl")
include("rxn.jl")

# export submodule functions to the current level
using .ChemKinet
using .Rxn

end  # module
