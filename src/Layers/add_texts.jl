function bind_text!(plts::Vector, labels::Observable{Vector{String}})
  on(labels) do labels
    for i in eachindex(plts)
      plts[i].text[] = labels[i]
    end
  end
end


"""
- space: `:relative` or `:data`
"""
function add_texts!(axs::Vector, labels::Observable, x = 0, y = 1;
  fontsize=30, align=(-0.1, 1.1), space = :relative, kw...)
  plts = []
  for i in eachindex(axs)
    label = labels[][i]
    plt = text!(axs[i], x, y, text=label; fontsize, align, space, kw...)
    push!(plts, plt)
  end
  bind_text!(plts, labels)
end

# add_texts!(axs, labels, 0, 1; )
function add_texts!(axs::Vector, labels::Vector, x = 0, y = 1; kw...)
  add_texts!(axs, Observable(labels), x, y; kw...)
end


export add_texts!
