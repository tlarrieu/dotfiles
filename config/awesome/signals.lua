local awful = require("awful")
local beautiful = require("beautiful")

client.connect_signal("property::position", function(c)
  if awful.rules.match(c, { class = "kitty" }) then
    c.opacity = c.fullscreen and 1 or 0.85
  end
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

local root_tag = {
  name = "",
  config = {
    selected = true,
    layout = awful.layout.suit.fair,
    master_width_factor = 0.75
  },
}

awful.screen.connect_for_each_screen(function(screen)
  local config = awful.util.table.join({ screen = screen }, root_tag.config)
  awful.tag.add(root_tag.name, config)
end)
