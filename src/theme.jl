"""
    my_theme!(; fontsize=14)

# Examples
```julia
my_theme!(;fontsize=14)
```
"""
function my_theme!(; fontsize=14, titlesize=20)
  kw_axes = (xticklabelsize=fontsize, yticklabelsize=fontsize,
    titlesize=titlesize,
    # titlefontsize=40,
    xlabelsize=fontsize, ylabelsize=fontsize,
    xlabelfont=:bold, ylabelfont=:bold)
  mytheme = Theme(;fontsize, Axis=kw_axes)
  set_theme!(mytheme)
end
