"""
    my_theme!(; fontsize=14)

# Examples
```julia
my_theme!(;fontsize=14)
```
"""
function my_theme!(; fontsize=14)
  kw_axes = (xticklabelsize=fontsize, yticklabelsize=fontsize,
    titlesize=fontsize + 4,
    # titlefontsize=40,
    xlabelsize=fontsize, ylabelsize=fontsize,
    xlabelfont=:bold, ylabelfont=:bold)
  mytheme = Theme(fontsize=14, Axis=kw_axes)
  set_theme!(mytheme)
end
