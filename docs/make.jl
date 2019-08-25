using Canopy
using Documenter

makedocs(
    format=Documenter.HTML(prettyurls=false),  # NOTE: prettyurls does not work
    sitename="Canopy.jl documentation",
    pages=[
        "Home" => "index.md",
        "Library" => Any[
            "lib.md",
            "lib/constants.md",
            "lib/water.md",
            "lib/air.md",
            "lib/physchem.md",
            "lib/radtrans.md",
            "lib/transfer.md",
            "lib/leaf.md",
            "lib/watercycle.md",
        ]
    ]
)
