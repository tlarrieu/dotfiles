local naughty = require("naughty")

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
      awful.placement.centered(c)
    end
  end
end)

tag.connect_signal("property::selected", function(t)
  local tags = awful.tag.gettags(awful.tag.getscreen(t))

  local text = ""
  for id, tag in ipairs(tags) do
    if id ~= 1 then
      text = text .. "│"
    end

    if tag.name == t.name then
      text = text ..
        " <span color='" .. theme.colors.green .. "'>" .. tag.name .. "</span> "
    else
      text = text .. " " .. tag.name .. " "
    end
  end

  tag_notification_id = naughty.notify(
    { text = text
    , timeout = 0.5
    , position = "bottom_right"
    , font = "Inconsolata-g for Powerline 20"
    , replaces_id = tag_notification_id }
  ).id
end)

-- client.connect_signal("focus", function(c) c.opacity = 1 end)
-- client.connect_signal("unfocus", function(c) c.opacity = 0.7 end)
