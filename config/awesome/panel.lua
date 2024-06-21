local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local apply_dpi = require("beautiful.xresources").apply_dpi

-- [[ Clock ]] -----------------------------------------------------------------
local clock = wibox.widget({
  widget = wibox.widget.textclock,
  format = "%Y.%m.%d %H:%M",
})

-- [[ Battery ]] ---------------------------------------------------------------
local pipe = assert(io.popen('ls /sys/class/power_supply | grep BAT | head -n 1 | tr -d "\n"'))
local batteryname = pipe:read('*all')
pipe:close()
local battery
if #batteryname > 0 then
  battery = require('widgets.battery')({
    adapter = batteryname,
    listen = false,
    ac_prefix = ' ',
    battery_prefix = '󰁹 ',
    limits = {
      { 25,  beautiful.colors.red.dark },
      { 50,  beautiful.colors.yellow.dark },
      { 100, beautiful.colors.green.dark }
    },
  }).widget
end

-- [[ Screen initialization ]] -------------------------------------------------
local init_screen = function(screen)
  local dpi = function(n) return apply_dpi(n, screen) end

  local taglist = awful.widget.taglist({
    screen = screen,
    filter = function(tag)
      return #tag:clients() > 1 or #tag.screen.tags > 1
    end,
    style = { spacing = dpi(6) },
  })

  local left = wibox.widget({
    wibox.container.margin(battery, dpi(10), dpi(10), dpi(2), dpi(2)),
    layout = wibox.layout.fixed.horizontal
  })

  local middle = wibox.widget({
    wibox.container.margin(taglist, dpi(1), dpi(1), dpi(2), dpi(2)),
    layout = wibox.layout.fixed.horizontal,
  })

  local right = wibox.widget({
    clock,
    layout = wibox.layout.fixed.horizontal
  })
  right = wibox.container.margin(right, dpi(5), dpi(5), dpi(0), dpi(0))

  local barwidget = wibox.widget({
    left,
    middle,
    right,
    layout = wibox.layout.align.horizontal,
    expand = "none"
  })

  awful.wibar({
    position = "top",
    height = dpi(32),
    screen = screen,
    widget = wibox.container.margin(barwidget, dpi(2), dpi(2), dpi(2), dpi(2))
  })
end
awful.screen.connect_for_each_screen(init_screen)
