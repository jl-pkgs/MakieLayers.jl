export gap!
export bind_text!, bind_z!, add_labels!

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

function Base.size(fig::Figure)
  m, n = collect(fig.scene.viewport[].widths)
  println("size=($m, $n)")
  # m, n
end
