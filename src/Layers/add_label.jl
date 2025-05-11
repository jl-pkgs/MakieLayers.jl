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
  color=:white, align = (:left, :bottom), kw...)

  halign, valign = align
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


export add_label!, grid_position
