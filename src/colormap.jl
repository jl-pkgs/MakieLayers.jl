export ncl_colors, ncl_group


using Serialization: serialize, deserialize
using Colors

project_path(f...) = normpath(joinpath(@__DIR__, "..", f...))
load(f) = deserialize(project_path(f))
# export parse_color
# parse_color(cols::AbstractVector{String}) = [parse(Colorant, col) for col in cols]

ncl_colors = load("data/ncl_colors")
ncl_group = load("data/ncl_colors_group")


function Base.show(io::IO, x::typeof(ncl_colors))
  display(keys(x))
end

function Base.show(io::IO, x::typeof(ncl_group))
  println(keys(x))
end
