module PhysChem

include("chemkinet.jl")
include("solub.jl")
include("reactions.jl")

# export submodule functions to the current level
using .ChemKinet
using .Solub
using .Reactions

end  # module
