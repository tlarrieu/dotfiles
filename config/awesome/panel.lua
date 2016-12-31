local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local lain = require("lain")

local cpuwidget = wibox.widget.textbox()
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

  cpuwidget:set_markup(lain.util.markup(color, "cpu: " .. cpu_now.usage .. "%"))
end})

local memwidget = wibox.widget.textbox()
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

  memwidget:set_markup(lain.util.markup(color, "ram: " .. mem_now.perc .. "%"))
end})

local clockwidget = wibox.widget.textclock(
  lain.util.markup(beautiful.fg_normal, " %Y.%m.%d %H:%M")
)

local battextwidget = wibox.widget.textbox()
battextwidget:set_font("Inconsolata-g For Powerline 10")
local batbar = wibox.widget.progressbar()
batbar.forced_width = 45
batbar:set_ticks(false)
batbar:set_ticks_size(5)
batbar:set_background_color(beautiful.bg_normal)
local batmargin = wibox.container.margin(batbar, 2, 7)
batmargin:set_top(8)
batmargin:set_left(7)
batmargin:set_bottom(8)
local batwidget = wibox.container.background(batmargin)
batwidget:set_bgimage(beautiful.widget_bg)

local batcallback = function()
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

  battextwidget:set_markup(lain.util.markup(color, icon .. legend))
  batbar:set_color(color)
  batbar:set_value(bat_now.perc / 100)
end

lain.widgets.bat({ battery = "BAT1", timeout = 15, settings = batcallback })

awful.screen.connect_for_each_screen(function(screen)
  local taglist = awful.widget.taglist(
    screen,
    awful.widget.taglist.filter.all,
    awful.util.table.join(
      awful.button({}, 1, function(tag) tag:view_only() end)
    )
  )

  local left = wibox.widget {
    wibox.container.margin(taglist, 5, 0, 0, 0),
    layout = wibox.layout.fixed.horizontal
  }

  local middle = wibox.widget {
    clockwidget,
    layout = wibox.layout.fixed.horizontal,
  }

  local right = wibox.widget {
    wibox.container.margin(cpuwidget, 0, 10, 0, 0),
    wibox.container.margin(memwidget, 0, 10, 0, 0),
    battextwidget,
    batwidget,
    layout = wibox.layout.fixed.horizontal
  }

  awful.wibar({
    position = "top",
    screen = screen,
    widget = wibox.widget {
      left,
      middle,
      right,
      layout = wibox.layout.align.horizontal,
      expand = "none"
    },
  })
end)
