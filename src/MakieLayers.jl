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

end # module MakieLayers
