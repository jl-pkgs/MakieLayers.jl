module MakieLayers

using Makie
import Makie: automatic

export map_on_keyboard, map_on_mouse

include("convert_arguments.jl")
include("Layers/Layers.jl")
include("events.jl")
include("colormap.jl")

end # module MakieLayers
