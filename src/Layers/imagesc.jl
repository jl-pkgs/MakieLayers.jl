export set_colgap
# TODO: add base maps foreach axis

"""
    imagesc!(f, x, args...;
        colorrange=automatic, col_rev=false, colors=:viridis,
        title="Plot", fact=nothing, kw...)
    imagesc!(f, z; kw...)

    imagesc(x, y, z; kw...)
    imagesc(z; kw...)

Heatmap with colorbar

# Arguments
- `fact`: this is used to reduce the number of points to be plotted. If `fact`
  is `nothing`, all points are plotted. If `fact=n`, only every `n`th point
  is plotted.
- `colorrange`: the range of the colorbar. If `colorrange` is `automatic`, the
  range is determined by the minimum and maximum values of `z`. If `colorrange`
  is a tuple `(vmin, vmax)`, the range is set to `[vmin, vmax]`.
- `force_show_legend`: if `true`, the colorbar is always shown.
- `col_rev`  : if `true`, the colormap is reversed.
- `colors`   : the colormap. It can be a string or a vector of colors.
- `kw...`    : other keyword arguments passed to `heatmap!`
- `kw_axis`  : other keyword arguments passed to `Axis`
- `fun_axis` : used to tidy axis
- `cgap`     : the gap between the colorbar and the plot (default is 5)
- `gap`      : the gap between subplots (default is [10, 10])

# Examples
```julia
imagesc(rand(10, 10))
```
"""
function _imagesc(ax::Axis, x, y, z::Union{R,Observable{R}};
  colorrange=automatic, col_rev=false, colors=amwg256,
  fact=nothing, kw...) where {R<:AbstractArray{<:Real,2}}

  col_rev && (colors = reverse(colors))

  if fact === nothing
    plt = heatmap!(ax, x, y, z; colorrange, colormap=colors, kw...)
  else
    if isa(z, Observable)
      _z = @lift $z[1:fact:end, 1:fact:end]
    else
      _z = @view z[1:fact:end, 1:fact:end]
    end

    plt = heatmap!(ax, x[1:fact:end], y[1:fact:end], _z;
      colorrange, colormap=colors, kw...)
  end
  plt
end

function imagesc!(fig::Union{Figure,GridPosition,GridSubposition},
  x, y, z::Union{R,Observable{R}};
  title="",
  force_show_legend=false,
  colorrange=automatic,
  axis=(;),
  fun_axis=nothing,
  colorbar=(; width=20),
  cgap=5,
  kw...) where {R<:AbstractArray{<:Real,2}}

  ax = Axis(fig[1, 1]; title, axis...)
  plt = _imagesc(ax, x, y, z; colorrange, kw...)

  if (colorrange == automatic || force_show_legend)
    Colorbar(fig[1, 2], plt; colorbar...)
    !isnothing(cgap) && set_colgap(fig, 1, cgap)
  end
  !isnothing(fun_axis) && (fun_axis(ax))

  ax, plt
end

# for 3d array
function imagesc!(fig::Union{Figure,GridPosition,GridSubposition},
  x, y, z::Union{R,Observable{R}};
  colorrange=automatic, force_show_legend=false,
  layout=nothing,
  titles=nothing, colors=amwg256,
  xlabel=nothing, ylabel=nothing, title=nothing,
  gap=10, cgap=5,
  axis=(;), colorbar=(; width=15),
  fun_axis=nothing,
  byrow=false,
  kw...) where {R<:AbstractArray{<:Real,3}}

  length(gap) == 1 && (gap = (gap, gap))
  n = size(z, 3)
  if layout === nothing
    ncol = ceil(Int, sqrt(n))
    nrow = ceil(Int, n * 1.0 / ncol)
  else
    nrow, ncol = layout[1:2]
  end

  titles === nothing && (titles = fill("", n))
  axs = []
  plts = []

  k = 0
  inds = byrow ? CartesianIndices((1:ncol, 1:nrow)) : CartesianIndices((1:nrow, 1:ncol))

  for I in inds[1:n]
    if byrow
      i, j = I[2], I[1]
    else
      i, j = I[1], I[2]
    end
    k += 1

    title = titles[k]
    if isa(z, Observable)
      _z = z[][:, :, k]
    else
      _z = z[:, :, k]
    end
    ax, plt = imagesc!(fig[i, j], x, y, _z;
      title, colorrange, force_show_legend, colors,
      axis, fun_axis, colorbar, cgap, kw...)
    # fun_axis !== nothing && fun_axis(ax)
    push!(axs, ax)
    push!(plts, plt)
  end

  linkaxes!(axs...)
  bind_z!(plts, z)

  rowgap!(fig.layout, gap[1])
  colgap!(fig.layout, gap[2])

  cbar = nothing
  # unify the legend
  if colorrange != automatic && !force_show_legend
    cbar = Colorbar(fig[1:nrow, ncol+1], plts[1]; colorbar...)
    set_colgap(fig, ncol, cgap)
  end
  axs, plts, cbar
end

function set_colgap(fig::GridSubposition, j, gap)
  # contents = fig.parent.layout.content
  # _content = contents[end].content
  # colgap!(_content, j, gap)
end

set_colgap(fig::Figure, j, gap) = colgap!(fig.layout, j, gap)

function set_colgap(fig::GridPosition, j, gap)
  contents = fig.layout.content
  # for i in 1:length(contents)
  _content = contents[end].content
  colgap!(_content, j, gap)
  # end
  # layout = fig.layout.content[1].content
  # colgap!(layout, j, gap)
end

function imagesc!(fig, z; kw...)
  x = 1:size(z, 1)
  y = 1:size(z, 2)
  imagesc!(fig, x, y, z; kw...)
end

function imagesc(x, args...; kw...)
  fig = Figure()
  R = imagesc!(fig, x, args...; kw...)
  fig
end
