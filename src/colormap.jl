# function get_color(name="amwg256")
#   cols = R"rcolors::get_color($name)" |> rcopy
#   [parse(Colorant, col) for col in cols]
# end
# colors = get_color("amwg256")

function get_color end

export get_color
