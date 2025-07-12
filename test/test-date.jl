using MakieLayers, Test
# using GLMakie, Dates

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
  series!(ax, t, y .+ 1)
  # vlines!(ax, t[4])
  lines!(ax, t, y)
  vspan!(ax, t[2], t[3]; alpha=0.2) # major error
  # @test_nowarn fig
  fig
  # time[] = time[] - Day(1)
end
