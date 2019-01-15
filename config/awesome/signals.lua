local awful = require("awful")
local beautiful = require("beautiful")

client.connect_signal("property::position", function(c)
  if awful.rules.match(c, { class = "kitty" }) then
    c.opacity = c.fullscreen and 1 or 0.85
  end
end)

client.connect_signal("focus", function(c)
  -- find a way to only flash client instead of keeping the border color
  c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)

local tags = {
  {
    name = "",
    config = {
      layout = awful.layout.suit.fair,
      selected = true,
    },
  },
  {
    name = "",
    config = {
      layout = awful.layout.suit.fair,
    }
  },
  {
    name = "",
    config = {
      layout = awful.layout.suit.tile.right,
      master_width_factor = 0.75,
    }
  },
  {
    name = "",
    config = {
      layout = awful.layout.suit.fair.horizontal,
    }
  },
  {
    name = "",
    config = {
      layout = awful.layout.suit.fair,
    }
  },
  {
    name = "",
    config = {
      layout = awful.layout.suit.fair,
    }
  },
}

awful.screen.connect_for_each_screen(function(screen)
  for _, tag in ipairs(tags) do
    local config = awful.util.table.join({ screen = screen }, tag.config)
    awful.tag.add(tag.name, config)
  end
end)
