module MakieLayers

using Makie
import Makie: automatic

using Dates
const TypeDate = Union{DateTime,Date}

export automatic
export map_on_keyboard, map_on_mouse
export my_theme!

include("convert_arguments.jl")
include("Layers/Layers.jl")
include("events.jl")
include("colormap.jl")
include("theme.jl")
# include("Shapefile.jl")
# function read_sf end
# function plot_poly! end
# export read_sf, plot_poly!

end # module MakieLayers
