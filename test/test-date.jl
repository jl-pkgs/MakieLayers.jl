# using MakieLayers, Test
# using GLMakie, Dates
# import Makie

@testset "date" begin
  t = DateTime(2020):Day(1):DateTime(2020, 1, 7) |> collect
  n = length(t)
  x = 1:n
  y = rand(n)
  data = rand(2, n)

  time = Observable(t)
  year = 2020
  time[] = DateTime(year):Day(1):DateTime(year, 1, 7) |> collect

  fig = Figure()
  ax = Axis(fig[1, 1]) # 也可以提前设置ticks
  series!(ax, t, data, labels=["ea", "es"])
  lines!(ax, t, y, label="VPD")
  axislegend()

  vlines_date!(ax, t[4])
  hlines!(ax, y[4])

  vspan_date!(ax, t[2], t[3]; alpha=0.2)
  # hspan!(ax, y[2], y[3]; alpha=0.2) # error: wait Makie 0.25

  @test_nowarn fig
  # fig
  # time[] = time[] - Day(1)
end
