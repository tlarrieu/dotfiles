local wibox = require("wibox")
local gears = require("gears")

-- [[ Widgets ]] ---------------------------------------------------------------

local layoutbox = awful.widget.layoutbox(s)
layoutbox:buttons(layoutbuttons)

local clockwidget = awful.widget.textclock()
local batterywidget = wibox.widget.textbox()

local pollBattery = function() batterywidget:set_text(batteryInfo("BAT1")) end
local timer = timer({ timeout = 15 })
timer:connect_signal("timeout", pollBattery)
timer:start()
pollBattery()

for s = 1, screen.count() do
  gears.wallpaper.maximized(wallpaper, s, false)

  awful.tag(tagnames, s, awful.layout.suit.fair)

  local taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, tagbuttons)
  local tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, taskbuttons)

  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(layoutbox)
  left_layout:add(taglist)

  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(batterywidget)
  right_layout:add(clockwidget)

  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(tasklist)
  layout:set_right(right_layout)

  local toppanel = awful.wibox({ position = "top", screen = s })
  toppanel:set_widget(layout)
end
