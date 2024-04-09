export ncl_colors, ncl_group, amwg256
export nan_color
export resample_colors


using Serialization: serialize, deserialize
using Colors
using ColorSchemes

nan_color = RGBA(1.0, 1.0, 1.0, 0.0)

project_path(f...) = normpath(joinpath(@__DIR__, "..", f...))
load(f) = deserialize(project_path(f))
# export parse_color
# parse_color(cols::AbstractVector{String}) = [parse(Colorant, col) for col in cols]

ncl_colors = load("data/ncl_colors")
ncl_group = load("data/ncl_colors_group")

amwg256 = ncl_colors.amwg256


"""
    resample_colors(colors, n=10)

# Examples
```julia
cols = resample_colors(amwg256, 10)
```
"""
function resample_colors(colors::AbstractVector{<:RGB}, n=10)
  cs = ColorScheme(colors)
  get(cs, range(0, 1, n))
end

## also need a function to display colors

function Base.show(io::IO, x::typeof(ncl_colors))
  display(keys(x))
end

function Base.show(io::IO, x::typeof(ncl_group))
  println(keys(x))
end
