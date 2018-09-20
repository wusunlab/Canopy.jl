module RadTrans

include("blackbody.jl")
include("solar.jl")

# export submodule functions to the current level
using .Blackbody
using .Solar

end  # module
