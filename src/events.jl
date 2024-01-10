"""
    map_on_keyboard(fig, stime)
"""
function map_on_keyboard(fig, stime)
  on(events(fig).keyboardbutton) do event

    if event.action == Keyboard.press || event.action == Keyboard.repeat
      if event.key == Keyboard.right
        stime[] += 1
      elseif event.key == Keyboard.left
        stime[] -= 1
      end
    end
    return Consume(false)
  end
end

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
    map_on_mouse(fig, ax, handle_plot, slon, slat)
"""
function map_on_mouse(fig, ax, handle_plot, slon, slat)
  # handle_plot = get_plot(ax, 1)
  on(events(fig).mousebutton, priority=1) do event
    # @show event.button, event.action
    if event.button == Mouse.left && event.action == Mouse.press
      plt, i = pick(fig)
      # @show plt

      if plt == handle_plot
        pos = mouseposition(ax)
        slon[] = pos[1]
        slat[] = pos[2]
        # point = []
      end
    end
    return Consume(true)
  end
end

