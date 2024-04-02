# heatmap with legend
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

# Examples
```julia
imagesc(rand(10, 10))
```
"""
function imagesc!(f, x, y, z::Union{R,Observable{R}};
  colorrange=automatic, col_rev=false, colors=:viridis,
  title="Plot", fact=nothing, kw...) where {R<:AbstractArray{<:Real,2}}

  col_rev && (colors = reverse(colors))

  ax = Axis(f[1, 1]; title)
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
  Colorbar(f[1, 2], plt)
  ax, plt
end

# for 3d array
function imagesc!(fig, x, y, z::Union{R,Observable{R}};
  colorrange=automatic,
  layout=nothing,
  titles=nothing, colors=:viridis, gap=10, kw...) where {R<:AbstractArray{<:Real,3}}

  n = size(z, 3)
  if layout === nothing
    ncol = ceil(Int, sqrt(n))
    nrow = ceil(Int, n * 1.0 / ncol)
  else
    nrow, ncol = layout[1:2]
  end

  titles === nothing && (titles = fill("", n))
  k = 0
  for i = 1:nrow, j = 1:ncol
    k += 1
    k > n && break

    title = titles[k]
    if isa(z, Observable)
      _z = @lift $z[:, :, k]
    else
      _z = z[:, :, k]
    end
    imagesc!(fig[i, j], x, y, _z;
      title, colorrange, colors, kw...)
  end
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
