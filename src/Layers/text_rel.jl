"""
  add relative labels to the axis
"""
function text_rel!(ax::Axis, label, x=0, y=1; align=(0, 1), kw...)
  xlim = ax.xaxis.attributes.limits
  ylim = ax.yaxis.attributes.limits

  x2 = @lift ($xlim[2] - $xlim[1]) * x + $xlim[1]
  y2 = @lift ($ylim[2] - $ylim[1]) * y + $ylim[1]

  # @show x2, y2, label, xlim, ylim, x, y
  text!(ax, x2, y2; text=label, align, kw...)
end


function text_rel!(axs::Vector, labels, args...; kw...)
  for (i, ax) in enumerate(axs)
    label = labels[i]
    !isa(label, Observable) && (label = "$label")
    text_rel!(ax, label, args...; kw...)
  end
end
