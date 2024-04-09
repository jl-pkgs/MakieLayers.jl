begin
  z = Observable(rand(4, 4, 4))

  fig = Figure()
  imagesc!(fig, z)
  fig
end

z[] = rand(4, 4, 4)
# if z changed, fig will update
