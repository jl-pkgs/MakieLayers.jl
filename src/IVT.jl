function arrow_legend!(ax, len;
  b::bbox=bbox(-180, 75, -100, 90), unit="kg m⁻² s⁻¹", lengthscale=0.6)

  (; xmin, xmax, ymin, ymax) = b
  rect = Point2f[(xmin, ymin), (xmax, ymin), (xmax, ymax), (xmin, ymax)]
  poly!(ax, rect, color=:white, strokewidth=0.1)

  _x = xmin + (xmax - xmin) * 0.3
  _x2 = xmin + (xmax - xmin) * 0.5

  _y = ymin + (ymax - ymin) * 0.75
  _y2 = ymin + (ymax - ymin) * 0.35
  arrows!(ax, [_x], [_y], [len], [0]; lengthscale)
  text!(ax, _x2, _y2, text="$len $unit"; align=(0.5, 0.5))
end
