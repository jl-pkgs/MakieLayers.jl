import Makie: plot!, plot, @recipe, @extract, xlims!
import Makie: Series

using PlotUtils: optimize_ticks, optimize_datetime_ticks
date2num = datetime2unix

# datetime2julian, datetime2rata, datetime2unix
function guess_date_ticks(dates; fmt="mm/dd")
  dateticks = optimize_ticks(dates[1], dates[end])[1]
  (date2num.(dateticks), Dates.format.(dateticks, fmt))
end

## How to update ticks for Dates
function get_ticks(t::AbstractVector{DateTime}, any_scale, ::Automatic, vmin, vmax; kw...)
  guess_date_ticks(t; kw...)
end


## layer: dateseries! ----------------------------------------------------------
@recipe(DateSeries, curves) do scene
  attrs = default_theme(scene, Series)
  return Attributes(;attrs...)
end

Makie.convert_arguments(::Type{<:DateSeries}, args...) = convert_arguments(Series, args...)

function plot!(p::DateSeries)
  curves = p[1]
  series!(p, curves; p.attributes...)
end

# `get_plots`用于生成legend
function Makie.get_plots(plot::DateSeries)
  plot.plots[1].plots
end


function dateseries!(ax, t::Observable{<:AbstractVector{<:TypeDate}}, y;
  date_format = "mm/dd", kw...)

  x = @lift date2num.($t)
  r = dateseries!(ax, x, y; kw...)
  
  # 横坐标变化时，更新
  onany(x, t; update=true) do x, t
    xlims = extrema(x)
    xlims!(ax, xlims)

    ## update ticks and xticklabels
    xticks = guess_date_ticks(t; fmt=date_format)
    ax.xticks[] = xticks
  end
  r
end
