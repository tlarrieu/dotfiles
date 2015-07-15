client.connect_signal("manage", function (c, startup)
  -- Enable sloppy focus
  c:connect_signal("mouse::enter", function(c)
    magnifier = awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    if magnifier and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)

  if not startup then
    -- Put windows in a smart way, only if they does not set an initial
    -- position.
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)

function bcolor(color)
  return function (c) c.border_color = color end
end

client.connect_signal("focus"  , bcolor(beautiful.border_focus))
client.connect_signal("unfocus", bcolor(beautiful.border_normal))
