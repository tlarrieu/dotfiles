local wibox = require("wibox")
local gears = require("gears")

for s = 1, screen.count() do
  gears.wallpaper.maximized(wallpaper, s, false)

  -- HACK to make room for lemonbuddy (transparent wibox that takes the
  -- necessary screen estate)
  local panel = awful.wibox({ position = "top", screen = s, bg = "#FFFFFF00" })
end
