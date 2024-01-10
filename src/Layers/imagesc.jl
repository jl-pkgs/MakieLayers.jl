# heatmap with legend
"""
    imagesc!(f, x, y, z;
        colorrange=nothing, col_rev=false, cols=colors,
        title="Plot", kw...)
    imagesc!(f, z; kw...)

    imagesc(x, y, z; kw...)
    imagesc(z; kw...)

Heatmap with colorbar

# Examples
```julia
imagesc(rand(10, 10))
```
"""
function imagesc!(f, x, args...;
  colorrange=automatic, col_rev=false, cols=:viridis,
  title="Plot", kw...)

  col_rev && (cols = reverse(cols))
  
  ax = Axis(f[1, 1]; title)
  plt = heatmap!(ax, x, args...; colorrange, colormap=cols, kw...)
  Colorbar(f[1, 2], plt)
  ax, plt
end


function imagesc(x, args...; kw...)
  f = Figure()
  ax, plt = imagesc!(f, x, args...; kw...)
  f
end
