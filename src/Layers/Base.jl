export gap!
export bind_text!, bind_z!, add_labels!, text_rel!
export rm_ticks!, non_label_ticks


function Base.size(fig::Figure)
  m, n = collect(fig.scene.viewport[].widths)
  println("size=($m, $n)")
  # m, n
end

Base.size(x::Observable) = size(x[])
Base.size(x::Observable, i) = size(x[], i)

function gap!(fig, gap=0)
  rowgap!(fig.layout, gap)
  colgap!(fig.layout, gap)
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
