using RCall
using UnPack
using Colors

parse_color(cols::AbstractVector{String}) = [parse(Colorant, col) for col in cols]

function tidy_colors(colors)
  vals = map(parse_color, values(colors))
  Dict(keys(colors) .=> vals) |> NamedTuple
end

function map_dict(fun::Function, xs, args...; kw...)
  r = Dict()
  for (key, val) in xs
    r[key] = tidy_colors(val, args...; kw...)
  end
  r
end

# 305 colors

R"library(rcolors)"

_colors = R"rcolors" |> rcopy
_colors_group = R"colors_group" |> rcopy
