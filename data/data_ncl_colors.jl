# using JLD2
# jldsave("data/ncl_colors.jld2", true; _colors) # , colors_group
# jldsave("data/ncl_colors_rgb.jld2", true; colors) # , colors_group

include("main_colors.jl")

colors = tidy_colors(_colors)
colors_group = map_dict(tidy_colors, _colors_group) |> NamedTuple

serialize("data/ncl_colors", colors)
serialize("data/ncl_colors_group", colors_group)

# function get_color(name="amwg256")
#   cols = R"rcolors::get_color($name)" |> rcopy
#   [parse(Colorant, col) for col in cols]
# end
# colors = get_color("amwg256")
