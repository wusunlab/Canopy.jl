module PhysChem

include("chemkinet.jl")
include("solub.jl")
include("rxn.jl")

# export submodule functions to the current level
using .ChemKinet
using .Solub
using .Rxn

end  # module
