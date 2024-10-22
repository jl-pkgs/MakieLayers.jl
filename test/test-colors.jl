include("main_pkgs.jl")

## 离散型变量colorbar
z = round.(Int, rand(10, 10) * 10)

colorrange = (0, 10)
nbrk = colorrange[2] - colorrange[1] + 1
# 首尾 + (-0.5, 0.5)，让ticks居中

cols = resample_colors(amwg256, 12)
colors = cgrad(cols, nbrk, categorical=true)

ticks = 0:10 |> format_ticks
imagesc(z; colors, 
  colorbar = (; ticks, width=30), cgap=5, 
  colorrange=colorrange .+ (-0.5, 0.5), force_show_legend=true)
