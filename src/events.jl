"""
  event_keyboard_lr(fig, stime)
"""
function event_keyboard_lr(fig, stime::Slider, Δ::Integer=1)
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

function event_keyboard_ud(fig, stime::Slider, Δ::Integer=1)
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

map_on_keyboard = event_keyboard_lr

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
    event_click_point(ax, spoint::Observable; verbose=false, (fun!)=nothing, kw...)

# Arguments
- `fun!`: `fun!(slon, slat; kw...)` or `fun!(spoint; kw...)`
"""
function event_click_point(ax, spoint::Observable; verbose=false, (fun!)=nothing, kw...)
  on(events(ax).mousebutton, priority=1) do event
    if event.button == Mouse.left && event.action == Mouse.press
      pos = mouseposition(ax)
      lims = ax.finallimits[]
      xmin, ymin = lims.origin
      xmax, ymax = xmin + lims.widths[1], ymin + lims.widths[2]
      if !((xmin <= pos[1] <= xmax) && (ymin <= pos[2] <= ymax))
        return Consume(false)
      end
      spoint[] = pos[1], pos[2]

      verbose && @show spoint[]
      if (fun!) !== nothing
        fun!(spoint; kw...) # 传递ref, 以便fun!修改spoint
      end
    end
    return Consume(false)
  end
end

map_on_mouse = event_click_point # old name, to avoid breaking existing code


export map_on_mouse, map_on_keyboard
export event_keyboard_lr, event_keyboard_ud, event_click_point
