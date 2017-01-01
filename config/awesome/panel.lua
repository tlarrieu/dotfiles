local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local lain = require("lain")

local cpu = wibox.widget.textbox()
lain.widgets.cpu({ timeout = 2, settings = function()
  local color

  if cpu_now.usage > 80 then
    color = beautiful.colors.red
  elseif cpu_now.usage > 70 then
    color = beautiful.colors.orange
  elseif cpu_now.usage > 50 then
    color = beautiful.colors.yellow
  else
    color = beautiful.colors.green
  end

  cpu:set_markup(lain.util.markup(color, "cpu: " .. cpu_now.usage .. "%"))
end})

local ram = wibox.widget.textbox()
lain.widgets.mem({ timeout = 2, settings = function()
  local color

  if mem_now.perc > 80 then
    color = beautiful.colors.red
  elseif mem_now.perc > 70 then
    color = beautiful.colors.orange
  elseif mem_now.perc > 50 then
    color = beautiful.colors.yellow
  else
    color = beautiful.colors.green
  end

  ram:set_markup(lain.util.markup(color, "ram: " .. mem_now.perc .. "%"))
end})

local clock = wibox.widget({
  widget = wibox.widget.textclock,
  format = "%Y.%m.%d %H:%M",
})

local batterytext = wibox.widget({
  widget = wibox.widget.textbox,
})
local batterybar = wibox.widget({
  widget = wibox.widget.progressbar,
  background_color = beautiful.colors.base2,
  bar_shape = gears.shape.rounded_rect,
  forced_width = 45,
  shape = gears.shape.rounded_rect,
  ticks = false,
})
local battery = wibox.widget({
  batterytext,
  wibox.container.margin(batterybar, 5, 0, 8, 8),
  layout = wibox.layout.fixed.horizontal
})

lain.widgets.bat({ battery = "BAT1", timeout = 15, settings = function()
  if bat_now.status == "N/A" then return end

  local color = nil
  local legend = nil
  local icon = nil

  -- legend
  if bat_now.time == "00:00" then
    legend = "100%"
  else
    legend = bat_now.time
  end

  -- color
  if bat_now.perc >= 98 then
    color = beautiful.colors.green
  elseif bat_now.perc > 50 then
    color = beautiful.colors.yellow
  elseif bat_now.perc > 15 then
    color = beautiful.colors.orange
  else
    color = beautiful.colors.red
  end

  -- icon
  if bat_now.perc == 100 then
    icon = "⚡ "
  else
    if bat_now.status == "Charging" then
      icon = "↑ "
    else
      icon = "↓ "
    end
  end

  batterytext:set_markup(lain.util.markup(color, icon .. legend))
  batterybar:set_color(color)
  batterybar:set_value(bat_now.perc / 100)
end})

awful.screen.connect_for_each_screen(function(screen)
  local taglist = awful.widget.taglist(
    screen,
    awful.widget.taglist.filter.all,
    { awful.button({}, 1, function(tag) tag:view_only() end) },
    { spacing = 1 }
  )

  local left = wibox.widget({
    taglist,
    layout = wibox.layout.fixed.horizontal
  })

  local middle = wibox.widget({
    clock,
    layout = wibox.layout.fixed.horizontal,
  })

  local right = wibox.widget({
    wibox.container.margin(cpu, 0, 10, 0, 0),
    wibox.container.margin(ram, 0, 10, 0, 0),
    battery,
    layout = wibox.layout.fixed.horizontal
  })
  right = wibox.container.margin(right, 5, 5, 0, 0)

  local barwidget = wibox.widget({
    left,
    middle,
    right,
    layout = wibox.layout.align.horizontal,
    expand = "none"
  })
  awful.wibar({
    position = "top",
    height = 30,
    screen = screen,
    widget = wibox.container.margin(barwidget, 2, 2, 2, 2)
  })
end)
