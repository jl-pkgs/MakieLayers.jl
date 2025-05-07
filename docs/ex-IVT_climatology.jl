## 绘制
using GLMakie, MakieLayers
using Ipaper, Ipaper.sf, NetCDFTools, Dates
using Shapefile

include("main_agg.jl")
include("main_makie.jl")
# shp = Shapefile.Table("data/shp/GlobalLand_360.shp")
shp = Shapefile.Table("z:/ne_10m_land/arc_Land_main_360lon.shp")


fout = "IVT_ERA5_G010_2000-2024_Origin.nc"
lon, lat = st_dims(fout)
# lon2 = fix_360lon(lon)

DIV = nc_read(fout, "DIV")
IVT_u = nc_read(fout, "IVT_u")
IVT_v = nc_read(fout, "IVT_v")

begin
  normalize = false
  _DIV = agg_6y(DIV; normalize) #|> fix_360lon
  _IVT_u = agg_6y(IVT_u; normalize) #|> fix_360lon
  _IVT_v = agg_6y(IVT_v; normalize) #|> fix_360lon
end

begin
  n = 24
  mid = round(Int, n / 2)
  cols = resample_colors(amwg256, n)
  grey = colorant"grey90"
  cols[mid:mid+1] .= grey

  titles = [
    "(A) 2000-2004",
    "(B) 2005-2009",
    "(C) 2010-2014",
    "(D) 2015-2019",
    "(E) 2020-2022",
    "(F) 2023-2024"
  ]
  fig = Figure(; size=(1821, 683))
  axis = (; limits=((0, 360), (-60, 90)))

  ticks = -1.2:0.4:1.2 |> format_ticks

  axs, plts, bar = imagesc!(fig, lon, lat, _DIV .* 1e4;
    # colorrange=(-1, 1) .* 1, 
    colorrange=(-1, 1) .* 1.0, # anorm
    colors=cols,
    colorbar=(; width=30, ticklabelsize=18, labelfont=:bold, ticks),
    axis,
    byrow=true,
    fun_axis=add_basemap, gap=10)

  lengthscale = 0.04
  for i in eachindex(axs)
    step = 20
    x = lon[1:step:end]
    y = lat[1:step:end]
    u = _IVT_u[1:step:end, 1:step:end, i]
    v = _IVT_v[1:step:end, 1:step:end, i]
    arrows!(axs[i], x, y, u, v;
      linewidth=0.6,
      arrowsize=4, lengthscale, linecolor=colorant"grey40", label="IVT")
  end

  # add_texts!(axs, titles, 0.55, 0.05; align=(0.5, 0))
  arrow_legend!(axs[1], 400;
    b=bbox(-180 + 180, 75, -110 + 180, 90), unit="kg m⁻¹ s⁻¹", lengthscale)
  add_label!(axs, titles; fontsize=24, font=:bold, padding=(0.5, 0.5, 0.5, 0.5) .* 10)
  save("Figure1_IVT_climatology.png", fig)
  fig
end
