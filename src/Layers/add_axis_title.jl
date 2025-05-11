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

function add_ylabel!(fig, ylabel; width=5, kw...)
  ylabel == "" && return
  Label(fig[:, 0], ylabel;
    rotation=pi / 2, tellwidth=true, tellheight=false, font=:bold, width, kw...)
end

function add_xlabel!(fig, xlabel; height=5, kw...)
  xlabel == "" && return
  Label(fig[end+1, :], xlabel;
    tellwidth=false, tellheight=true, font=:bold, height, kw...)
end

function add_title!(fig, title; height=5, kw...)
  title == "" && return
  Label(fig[0, :], title;
    tellwidth=false, tellheight=true, font=:bold, height, kw...)
end

function labs!(fig; xlabel="", ylabel="", title="", height=5, kw...)
  add_ylabel!(fig, ylabel; width=height, kw...)
  add_xlabel!(fig, xlabel; height, kw...)
  add_title!(fig, title; height, kw...)
end

export add_xlabel!, add_ylabel!, add_title!, labs!
export add_col_labels!, add_row_labels!
