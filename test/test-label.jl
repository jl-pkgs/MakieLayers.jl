using Test, MakieLayers
# using CairoMakie
# using GLMakie

@testset "add_label" begin
  # using GLMakie, MakieLayers
  labels = ["(a)", "(b)", "(c)", "(d)"]

  fig = Figure(; size=(1400, 800))
  axs, plts = imagesc!(fig, rand(10, 10, 4))
  @test_nowarn add_label!(axs, labels; align=(1, 1))
  fig
  # save("Figure.png", fig)
end
