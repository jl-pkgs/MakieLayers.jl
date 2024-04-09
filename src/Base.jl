Base.size(x::Observable) = size(x[])
Base.size(x::Observable, i) = size(x[], i)

function gap!(fig, gap=0)
  rowgap!(fig.layout, gap)
  colgap!(fig.layout, gap)
end

export gap!
