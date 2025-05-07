import Makie
using Makie.GridLayoutBase

function grid_position(ax::Axis)
  sp = GridLayoutBase.gridcontent(ax).span
  si = GridLayoutBase.gridcontent(ax).side
  gl = Makie.GridLayoutBase.gridcontent(ax).parent
  return GridPosition(gl, sp, si)
end

function add_label!(ax::Axis, label::String;
  padding=(1, 1, 1, 1) .* 10,
  color=:white, halign=:left, valign=:bottom, kw...)

  gp = grid_position(ax)
  gl = GridLayout(gp; tellwidth=false, tellheight=false, halign, valign)
  Box(gl[1, 1]; color, strokecolor=nan_color, strokewidth=0)
  Label(gl[1, 1], label; padding, kw...)
end


function add_label!(axs::Vector, labels::Vector; kw...)
  for i in eachindex(axs)
    add_label!(axs[i], labels[i]; kw...)
  end
end

function arrow_legend!(ax, len;
  b::bbox=bbox(-180, 75, -100, 90), unit="kg m⁻² s⁻¹", lengthscale=0.6)

  (; xmin, xmax, ymin, ymax) = b
  rect = Point2f[(xmin, ymin), (xmax, ymin), (xmax, ymax), (xmin, ymax)]
  poly!(ax, rect, color=:white, strokewidth=0.1)

  _x = xmin + (xmax - xmin) * 0.3
  _x2 = xmin + (xmax - xmin) * 0.5

  _y = ymin + (ymax - ymin) * 0.75
  _y2 = ymin + (ymax - ymin) * 0.35
  arrows!(ax, [_x], [_y], [len], [0]; lengthscale)
  text!(ax, _x2, _y2, text="$len $unit"; align=(0.5, 0.5))
end
