using Test
using Dates
using MakieLayers
using CairoMakie
# using GLMakie


@testset "dateseries" begin
  ## good job, test passed
  t = DateTime(2020):Day(1):DateTime(2020, 1, 7) |> collect
  n = length(t)
  x = 1:n
  y = rand(n)
  data = rand(2, n)

  time = Observable(t)
  year = 2020
  time[] = DateTime(year):Day(1):DateTime(year, 1, 7) |> collect

  fig = Figure()
  ax = Axis(fig[1, 1])
  dateseries!(ax, time, data, labels=["ea", "es"])
  dateseries!(ax, time, y, label="VPD")
  axislegend()
  # x = @lift date2num.($time)
  # series!(ax, t, y .+ 1)
  vspan!(ax, t[2], t[3];)
  vlines!(ax, t[4])
  lines!(ax, t, y)
  @test_nowarn fig
  # time[] = time[] - Day(1)
end

@testset "imagesc" begin
  x = 2:11
  y = 2:11
  @test_nowarn imagesc(rand(10, 10))
  @test_nowarn imagesc(rand(10, 10, 4))
  @test_nowarn imagesc(x, y, rand(10, 10, 4))

  fig = Figure(; size = (800, 800))
  @test_nowarn imagesc!(fig, x, y, rand(10, 10, 4), colorrange=(0, 1), kw_cbar=(;width=45))
  fig
  save("test.png", fig)
end

@testset "imagesc" begin
  x = 2:11
  y = 2:11
  fig = Figure(; size=(800, 800))
  @test_nowarn imagesc!(fig[1:2, 1:2], x, y, rand(10, 10, 4); 
    colorrange=(0, 1), gap=(0, 0, 25))
  fig
end

@testset "ncl" begin
  @test_nowarn ncl_colors
  @test_nowarn ncl_group

  cols = resample_colors(amwg256, 10)
  @test length(cols) == 10
end
