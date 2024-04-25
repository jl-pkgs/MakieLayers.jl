export gap!
export bind_text!, bind_z!, add_labels!, text_rel!
export rm_ticks!, non_label_ticks

Base.size(x::Observable) = size(x[])
Base.size(x::Observable, i) = size(x[], i)

function gap!(fig, gap=0)
  rowgap!(fig.layout, gap)
  colgap!(fig.layout, gap)
end


function bind_text!(plts::Vector, labels::Observable{Vector{String}})
  on(labels) do labels
    for i in eachindex(plts)
      plts[i].text[] = labels[i]
    end
  end
end

# for not Observable
bind_z!(plts, z) = nothing

function bind_z!(plts::Vector, z::Observable{<:AbstractArray{<:Real,3}})
  on(z) do z
    for i in eachindex(plts)
      plts[i][3] = z[:, :, i]
    end
  end
end

function Base.size(fig::Figure)
  m, n = collect(fig.scene.viewport[].widths)
  println("size=($m, $n)")
  # m, n
end

non_label_ticks(ticks) = (ticks, ["" for i in ticks])

function rm_ticks!(ax;)
  # if !isnothing(xticks)
  # xticks = non_label_ticks(-180:60:180)
  ax.xticks = [], []
  ax.yticks = [], []

  # if !isnothing(yticks)
  # yticks = non_label_ticks(-60:30:90)
  # hidexdecorations!(ax, ticklabels=false, ticks=false, label=false)
  ticksize = 0
  ax.xticksize = ticksize
  ax.yticksize = ticksize
  
  # # ax.limits = ((70, 140), (15, 55))
  # ax.xgridstyle = :dash
  # ax.xgridwidth = 0.6
  # ax.ygridstyle = :dash
  # ax.ygridwidth = 0.6
  # add_basemap!(ax)
end


function add_labels!(axs::Vector, labels::Observable, x, y;
  fontsize=30, align=(:left, :top), offset=(10, -5))
  plts = []
  for i in eachindex(axs)
    label = labels[][i]
    plt = text!(axs[i], x, y, text=label; fontsize, align, offset)
    push!(plts, plt)
  end
  bind_text!(plts, labels)
end

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
