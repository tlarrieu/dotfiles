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

local tags = {
  {
    name = "",
    config = {
      layout = awful.layout.suit.max,
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
    name = "",
    config = {
      layout = awful.layout.suit.tile.right,
      master_width_factor = 0.75,
    }
  },
  {
    name = "",
    config = {
      layout = awful.layout.suit.fair,
    }
  },
  {
    name = "",
    config = {
      layout = awful.layout.suit.magnifier,
      master_width_factor = 0.85,
    }
  },
  {
    name = "",
    config = {
      layout = awful.layout.suit.max,
    }
  },
}

awful.screen.connect_for_each_screen(function(screen)
  for _, tag in ipairs(tags) do
    local config = awful.util.table.join({ screen = screen }, tag.config)
    awful.tag.add(tag.name, config)
  end
end)
