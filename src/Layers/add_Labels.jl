function add_row_labels!(fig, labels; fontsize=14, gap=5, kw...)
  _kw = (; tellwidth=false, tellheight=true, fontsize, font=:bold)
  plts = map(i -> Label(fig[0, i], labels[i]; _kw...), eachindex(labels))
  rowgap!(fig.layout, 1, gap)
  plts
end

function add_col_labels!(fig, labels; fontsize=14, gap=5, kw...)
  _kw = (; tellwidth=true, tellheight=false, fontsize, font=:bold, rotation=pi/2, kw...)
  plts = map(i -> Label(fig[i, 0], labels[i]; _kw...), eachindex(labels))
  colgap!(fig.layout, 1, gap)
  plts
end


export add_col_labels!, add_row_labels!
