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
- `col_rev`: if `true`, the colormap is reversed.
- `colors`: the colormap. It can be a string or a vector of colors.
- `kw...`: other keyword arguments passed to `heatmap!`
- `kw_axis`: other keyword arguments passed to `Axis`
- `fun_axis` used to tidy axis

# Examples
```julia
imagesc(rand(10, 10))
```
"""
function imagesc!(ax::Axis, x, y, z::Union{R,Observable{R}};
  colorrange=automatic, col_rev=false, colors=:viridis,
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

function imagesc!(fig::Union{Figure,GridPosition},
  x, y, z::Union{R,Observable{R}};
  title="Plot",
  force_show_legend=false,
  colorrange=automatic, kw_axis=(;), kw...) where {R<:AbstractArray{<:Real,2}}

  ax = Axis(fig[1, 1]; title, kw_axis...)
  plt = imagesc!(ax, x, y, z; colorrange, kw...)

  (colorrange == automatic || force_show_legend) && Colorbar(fig[1, 2], plt)
  ax, plt
end

# for 3d array
function imagesc!(fig::Union{Figure,GridPosition},
  x, y, z::Union{R,Observable{R}};
  colorrange=automatic, force_show_legend=false,
  layout=nothing,
  titles=nothing, colors=:viridis, gap=10,
  (fun_axis!)=nothing,
  kw...) where {R<:AbstractArray{<:Real,3}}

  n = size(z, 3)
  if layout === nothing
    ncol = ceil(Int, sqrt(n))
    nrow = ceil(Int, n * 1.0 / ncol)
  else
    nrow, ncol = layout[1:2]
  end

  titles === nothing && (titles = fill("", n))
  k = 0
  ax, plt = nothing, nothing
  for i = 1:nrow, j = 1:ncol
    k += 1
    k > n && break

    title = titles[k]
    if isa(z, Observable)
      _z = @lift $z[:, :, k]
    else
      _z = z[:, :, k]
    end
    ax, plt = imagesc!(fig[i, j], x, y, _z;
      title, colorrange, force_show_legend, colors, kw...)
    (fun_axis!) !== nothing && fun_axis!(ax)
  end

  # unify the legend
  (colorrange != automatic && !force_show_legend) && Colorbar(fig[:, ncol+1], plt)

  rowgap!(fig.layout, gap)
  colgap!(fig.layout, gap)
  fig
end

function imagesc!(fig, z; kw...)
  x = 1:size(z, 1)
  y = 1:size(z, 2)
  imagesc!(fig, x, y, z; kw...)
end

function imagesc(x, args...; kw...)
  fig = Figure()
  imagesc!(fig, x, args...; kw...)
  fig
end
