"""
  map_on_keyboard(fig, stime)
"""
function map_on_keyboard_lr(fig, stime::Slider, Δ::Integer=1)
  on(events(fig).keyboardbutton) do event
    if event.action == Keyboard.press || event.action == Keyboard.repeat
      if event.key == Keyboard.right
        set_close_to!(stime, stime.value[] + Δ)
      elseif event.key == Keyboard.left
        set_close_to!(stime, stime.value[] - Δ)
      end
    end
    return Consume(false)
  end
end

function map_on_keyboard_ud(fig, stime::Slider, Δ::Integer=1)
  on(events(fig).keyboardbutton) do event
    if event.action == Keyboard.press || event.action == Keyboard.repeat
      if event.key == Keyboard.down
        set_close_to!(stime, stime.value[] + Δ)
      elseif event.key == Keyboard.up
        set_close_to!(stime, stime.value[] - Δ)
      end
    end
    return Consume(false)
  end
end

map_on_keyboard = map_on_keyboard_lr

# @show event.key
# if event.key == Keyboard.up
#   slat[] += celly
# elseif event.key == Keyboard.down
#   slat[] -= celly
# elseif event.key == Keyboard.right
#   slon[] += cellx
# elseif event.key == Keyboard.left
#   slon[] -= cellx
# else
# Keyboard.page_up, page_down, _end, home

# function get_plot(ax::Axis, i=1) 
#   plts = ax.scene.plots
#   length(plts) == 0 ? nothing : plts[i]
# end

"""
    map_on_mouse(ax, slon::Observable, slat::Observable; verbose=false, (fun!)=nothing, kw...)
    map_on_mouse(ax, spoint::Observable; verbose=false, (fun!)=nothing, kw...)

# Arguments
- `fun!`: `fun!(slon, slat; kw...)` or `fun!(spoint; kw...)`
"""
function map_on_mouse(ax, slon::Observable, slat::Observable;
  verbose=false, (fun!)=nothing, kw...)

  on(events(ax).mousebutton, priority=2) do event
    if event.button == Mouse.left && event.action == Mouse.press
      # plt, i = pick(ax)
      pos = mouseposition(ax)
      # 如果不在axis范围内
      xlim = ax.xaxis.attributes.limits[]
      ylim = ax.yaxis.attributes.limits[]
      # xlim, ylim = ax.limits[]
      # if !isnothing(xlim) && !isnothing(ylim)

      if !((xlim[1] <= pos[1] <= xlim[2]) && (ylim[1] <= pos[2] <= ylim[2]))
        return Consume(false)
      end
      slon[] = pos[1]
      slat[] = pos[2]

      verbose && @show slon[], slat[]
      if (fun!) !== nothing
        fun!(slon[], slat[]; kw...)
      end
    end
    return Consume(false)
  end
end


function map_on_mouse(ax, spoint::Observable;
  verbose=false, (fun!)=nothing, kw...)

  on(events(ax).mousebutton, priority=2) do event
    if event.button == Mouse.left && event.action == Mouse.press
      pos = mouseposition(ax)
      xlim = ax.xaxis.attributes.limits[]
      ylim = ax.yaxis.attributes.limits[]

      if !((xlim[1] <= pos[1] <= xlim[2]) && (ylim[1] <= pos[2] <= ylim[2]))
        return Consume(false)
      end
      spoint[] = pos[1], pos[2]

      verbose && @show spoint
      if (fun!) !== nothing
        fun!(spoint[]; kw...)
      end
    end
    return Consume(false)
  end
end

export map_on_keyboard_lr, map_on_keyboard_ud, map_on_mouse
