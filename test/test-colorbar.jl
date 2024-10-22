include("main_pkgs.jl")
## 该脚本用于说明，如何设置axis and colorbar properties

t = 0.5:0.5:24
nhour = length(t)
nday = 100

yticks = 0:3:24 |> format_ticks
xticks = 0:20:100 |> format_ticks
ticks = -0.5:0.1:0.5 |> format_ticks

x = 1:nday
y = t
z = rand(nday, nhour, 2)

# 2d array passed
begin
  fig = Figure(; size=(600, 600))
  ax, plt = imagesc!(fig, x, y, z[:, :, 1];
    colorbar=(; ticks, width=30), cgap=5,
    axis=(; xticks, yticks, xlabel="Days", ylabel="Hours"), title="")
  fig
end

## 3d array passed perfectly
z = rand(nhour, nday, 2)
imagesc(x, y, z;
  colorbar=(; ticks, width=30), cgap=5,
  axis=(; xticks, yticks, xlabel="Days", ylabel="Hours"))

## 3d array, 统一colorbar
imagesc(x, y, z;
  colorrange=(0, 1),
  colorbar=(; ticks, width=30), cgap=15,
  axis=(; xticks, yticks, xlabel="Days", ylabel="Hours"))

## 测试xlab and ylab
begin
  fig = imagesc(x, y, z;
    colorrange=(0, 1),
    colorbar=(; ticks, width=30), cgap=15, gap=(10, 10),
    axis=(; xticks, yticks))
  # xlabel = "Days", ylabel = "Hours"
  labs!(fig; xlabel="Days", ylabel="Hours")
  add_title!(fig, "Title"; fontsize=24, height=15)
  # add_xlabel!(fig, "Days")
  # add_ylabel!(fig, "Hours")
  fig
end
