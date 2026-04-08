import Makie: plot, plot!, @recipe, xlims!
using PlotUtils: optimize_ticks

function get_date_ticks(dates; fmt="mm/dd")
  dateticks = optimize_ticks(dates[1], dates[end])[1]
  (date2num.(dateticks), Dates.format.(dateticks, fmt))
end

function set_date_ticks!(ax, t::AbstractVector{<:TypeDate};
  date_format="yy/mm/dd")
  # xlims = date2num.(extrema(t))
  # xlims!(ax, xlims)
  # Don't call xlims! — let Makie auto-compute limits from all plots on the axis
  ax.xticks[] = get_date_ticks(t; fmt=date_format)
end

## layer: dateseries! ----------------------------------------------------------
@recipe DateSeries (curves::AbstractVector{<:AbstractVector{<:Point2}},) begin
  filtered_attributes(Series)...
end

Makie.convert_arguments(::Type{<:DateSeries}, args...) = convert_arguments(Series, args...)

function Makie.plot!(p::DateSeries)
  curves = p[1]
  series!(p, curves)
end

# `get_plots`用于生成legend
function Makie.get_plots(plot::DateSeries)
  plot.plots[1].plots
end


function dateseries!(ax, t::Observable{<:AbstractVector{<:TypeDate}}, y;
  date_format="yy/mm/dd", kw...)

  x = @lift date2num.($t)
  r = dateseries!(ax, x, y; kw...)
  
  onany(t; update=true) do t
    set_date_ticks!(ax, t; date_format)
  end
  r
end

function dateseries!(ax, t::AbstractVector{<:TypeDate}, y;
  date_format="yy/mm/dd", kw...)
  
  set_date_ticks!(ax, t; date_format)
  dateseries!(ax, date2num.(t), y; kw...)
end
