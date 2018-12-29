local awful = require("awful")

client.connect_signal("manage", function(c)
  -- sloppy focus
  c:connect_signal("mouse::enter", function(c)
    local magnifier = c.screen.layout == awful.layout.suit.magnifier
    if not magnifier and awful.client.focus.filter(c) then
      client.focus = c
    end
  end)
end)

awesome.connect_signal("exit", function(restart)
  if restart then os.execute('xrdb ~/.Xresources') end
end)
