-- [[ Awesome modules ]] -------------------------------------------------------

awful = require("awful")
require("awful.autofocus")

-- [[ Plugins ]] ---------------------------------------------------------------

require("plugins/batmon")
require("plugins/run_or_raise")

-- [[ Configuration ]] ---------------------------------------------------------

require("beautiful").init(os.getenv("HOME") .. "/.config/awesome/themes/awesome-solarized/light/theme.lua")

tagnames = { "www", "dev", "misc", "sync", "async" }
wallpaper = "/home/tlarrieu/Pictures/wallpapers/wallhaven-285281.jpg"
layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.magnifier,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal
}

require "bindings"
require "layout"
require "signals"
require "rules"
