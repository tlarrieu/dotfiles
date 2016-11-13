-- [[ Awesome modules ]] -------------------------------------------------------

awful = require("awful")
require("awful.autofocus")

-- [[ Plugins ]] ---------------------------------------------------------------

require("plugins/batmon")
require("plugins/run_or_raise")

-- [[ Configuration ]] ---------------------------------------------------------

require("beautiful").init(os.getenv("HOME") .. "/.config/awesome/themes/awesome-solarized/light/theme.lua")

local tagsconfig = {
  { name = "www",   layout = awful.layout.suit.max },
  { name = "dev",   layout = awful.layout.suit.fair },
  { name = "term",  layout = awful.layout.suit.fair },
  { name = "misc",  layout = awful.layout.suit.fair },
  { name = "chat",  layout = awful.layout.suit.magnifier },
  { name = "other", layout = awful.layout.suit.max },
}

wallpaper = "/home/tlarrieu/Pictures/wallpapers/wallhaven-148255.png"
layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.magnifier,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.max,
}

tags = {}

local tagnames = {}
local taglayouts = {}
for i, config in ipairs(tagsconfig) do
  tagnames[i] = config.name
  taglayouts[i] = config.layout
end

for s = 1, screen.count() do
  tags[s] = awful.tag(tagnames, s, taglayouts)
end

require "bindings"
require "layout"
require "signals"
require "rules"
