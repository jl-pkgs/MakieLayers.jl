include("main_pkgs.jl")

include("test-label.jl")
include("test-colorbar.jl")
include("test-colors.jl")
# include("test-date.jl")

@testset "imagesc" begin
  x = 2:11
  y = 2:11
  @test_nowarn imagesc(rand(10, 10))
  @test_nowarn imagesc(rand(10, 10, 4))
  @test_nowarn imagesc(x, y, rand(10, 10, 4))

  fig = Figure(; size = (800, 800))
  @test_nowarn imagesc!(fig, x, y, rand(10, 10, 4), colorrange=(0, 1), colorbar=(;width=45))
  add_row_labels!(fig, ["(a)", "(b)"])
  add_col_labels!(fig, ["1", "2"])
  fig
  save("test.png", fig)
end

@testset "imagesc extra" begin
  x = 2:11
  y = 2:11
  fig = Figure(; size=(800, 800))
  @test_nowarn imagesc!(fig[1:2, 1:2], x, y, rand(10, 10, 4);
    colorrange=(0, 1), gap=(0, 0, 25))
  fig
  
  @test_nowarn imagesc(rand(4, 4, 12), layout=(4, 3), byrow=true)
end

@testset "ncl" begin
  @test_nowarn ncl_colors
  @test_nowarn ncl_group

  cols = resample_colors(amwg256, 10)
  @test length(cols) == 10
end
