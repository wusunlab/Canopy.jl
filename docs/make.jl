using Canopy
using Documenter

makedocs(
    format=:html,
    sitename="Canopy.jl documentation",
    pages=[
        "Home" => "index.md",
        "Library" => Any[
            "lib.md",
            "lib/constants.md",
            "lib/air.md",
            "lib/water.md",
            "lib/radtrans.md",
        ]
    ]
)
