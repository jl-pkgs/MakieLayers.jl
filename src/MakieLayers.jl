module MakieLayers


export automatic
export my_theme!
export date2num, get_date_ticks, vlines_date!, vspan_date!


using Makie
import Makie: automatic


## 日期的处理
using Dates
using PlotUtils: optimize_ticks
# const TypeDate = Union{DateTime,Date}

function date2num(x::T) where {T<:Union{DateTime,Date}}
  Makie.date_to_number(T, x)
end

function get_date_ticks(dates, args...; fmt="mm/dd", kw...)
  dateticks = optimize_ticks(dates[1], dates[end], args...; kw...)[1]
  (date2num.(dateticks), Dates.format.(dateticks, fmt))
end

vlines_date!(ax, pos, args...; kw...) = vlines!(ax, date2num.(pos), args...; kw...)
vspan_date!(ax, low, high, args...; kw...) = vspan!(ax, low, date2num.(high), args...; kw...)


include("Layers/Layers.jl")
include("events.jl")
include("colormap.jl")
include("theme.jl")
# include("Shapefile.jl")
# function read_sf end
# function plot_poly! end
# export read_sf, plot_poly!

end # module MakieLayers
