using GLMakie, MakieLayers, Dates

t = DateTime(2019):Day(1):DateTime(2019, 1, 10)
n = length(t)
y = rand(n)


begin
  fig = Figure(; size=(800, 500))
  ax = Axis(fig[1, 1])
  lines!(ax, t, y)
  vlines!(ax, t[5]; color=:red)
  vlines!.(ax, t[5:7]; color=:red)
  vspan!(ax, t[5], t[7]; color=:green)
  # lines!(ax, t, y) # error
  fig
end
