local awful = require("awful")

client.connect_signal("manage", function (c, startup)
  -- sloppy focus
  c:connect_signal("mouse::enter", function(c)
    local magnifier = c.screen.layout == awful.layout.suit.magnifier
    if not magnifier and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)
end)
