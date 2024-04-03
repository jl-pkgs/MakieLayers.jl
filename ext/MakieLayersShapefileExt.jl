export MakieLayersShapefileExt
module MakieLayersShapefileExt

using Shapefile
import Makie
import Makie: Axis, Point2f0, Point2f, Polygon, Poly, poly!, convert_arguments

# using MakieLayers
import MakieLayers: read_sf, plot_poly!

read_sf(f) = Shapefile.Table(f) #|> DataFrame

# https://discourse.julialang.org/t/best-way-of-handling-shapefiles-in-makie/71028/9
function Makie.convert_arguments(::Type{<:Poly}, p::Shapefile.Polygon)
  # this is inefficient because it creates an array for each point
  polys = Shapefile.GeoInterface.coordinates(p)
  ps = map(polys) do pol
    Polygon(
      Point2f0.(pol[1]), # interior
      map(x -> Point2f.(x), pol[2:end]))
  end
  (ps,)
end

"""
    plot_poly!(ax::Axis, shp::Shapefile.Table;
        color=nan_color, strokewidth=0.7, strokecolor=:black, kw...)
"""
function plot_poly!(ax::Axis, shp::Shapefile.Table;
  color=nan_color, strokewidth=0.7, strokecolor=:black, kw...)

  foreach(shp.geometry) do geo
    ismissing(geo) && return
    poly!(ax, geo; color, strokewidth, strokecolor, kw...)
  end
end


end
