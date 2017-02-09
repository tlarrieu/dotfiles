-- [[ Awesome modules ]] -------------------------------------------------------

local awful = require("awful")
require("awful.autofocus")
local gears = require("gears")

-- [[ Plugins ]] ---------------------------------------------------------------

require("plugins/run_or_raise")

-- [[ Configuration ]] ---------------------------------------------------------

require("beautiful").init(os.getenv("HOME") .. "/.config/awesome/themes/awesome-solarized/light/theme.lua")

local wallpaper = os.getenv("HOME") .. "/Pictures/wallpaper"

local tags = {
  {
    name = "",
    config = { layout = awful.layout.suit.max }
  },
  {
    name = "",
    config = { layout = awful.layout.suit.fair }
  },
  {
    name = "",
    config = { layout = awful.layout.suit.fair }
  },
  {
    name = "",
    config = { layout = awful.layout.suit.fair }
  },
  {
    name = "",
    config = {
      layout = awful.layout.suit.magnifier,
      master_width_factor = 0.85,
    }
  },
  {
    name = "",
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

  awful.tag.find_by_name(screen, ""):view_only()
end)

require("bindings")
require("panel")
require("signals")
require("rules")
