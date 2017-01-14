-- [[ Awesome modules ]] -------------------------------------------------------

local awful = require("awful")
require("awful.autofocus")
local gears = require("gears")

-- [[ Plugins ]] ---------------------------------------------------------------

require("plugins/batmon")
require("plugins/run_or_raise")

-- [[ Configuration ]] ---------------------------------------------------------

require("beautiful").init(os.getenv("HOME") .. "/.config/awesome/themes/awesome-solarized/light/theme.lua")

local wallpaper = "/home/tlarrieu/Pictures/wallpapers/wallhaven-459868.jpg"

local tags = {
  {
    name = "www",
    config = { layout = awful.layout.suit.max }
  },
  {
    name = "dev",
    config = { layout = awful.layout.suit.fair }
  },
  {
    name = "term",
    config = { layout = awful.layout.suit.fair }
  },
  {
    name = "misc",
    config = { layout = awful.layout.suit.fair }
  },
  {
    name = "chat",
    config = {
      layout = awful.layout.suit.magnifier,
      master_width_factor = 0.85,
    }
  },
  {
    name = "other",
    config = { layout = awful.layout.suit.max }
  },
}

awful.screen.connect_for_each_screen(function(screen)
  gears.wallpaper.maximized(wallpaper, screen, false)

  for _, tag in ipairs(tags) do
    awful.tag.add(
      tag.name,
      awful.util.table.join({ screen = screen }, tag.config)
    )
  end

  awful.tag.find_by_name(screen, "www"):view_only()
end)

require("bindings")
-- require("panel")
require("panel-experimental")
require("signals")
require("rules")
