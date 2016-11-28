local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local lain = require("lain")

local layoutbox = awful.widget.layoutbox()
layoutbox:buttons(layoutbuttons)

local cpuwidget = wibox.widget.textbox()
lain.widgets.cpu({ timeout = 2, settings = function()
  local color = nil

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
  local color = nil

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

local clockwidget = awful.widget.textclock(
  lain.util.markup(beautiful.fg_normal, " %Y.%m.%d %H:%M")
)

local battextwidget = wibox.widget.textbox()
battextwidget:set_font("Inconsolata-g For Powerline 10")
local batbar = awful.widget.progressbar()
batbar:set_width(45)
batbar:set_ticks(false)
batbar:set_ticks_size(5)
batbar:set_background_color(beautiful.bg_normal)
local batmargin = wibox.layout.margin(batbar, 2, 7)
batmargin:set_top(8)
batmargin:set_left(7)
batmargin:set_bottom(8)
local batwidget = wibox.widget.background(batmargin)
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
  if bat_now.status == "Charging" then
    if bat_now.perc == 100 then
      icon = ""
    else
      icon = "↑ "
    end
  else
    icon = "↓ "
  end

  battextwidget:set_markup(lain.util.markup(color, icon .. legend))
  batbar:set_color(color)
  batbar:set_value(bat_now.perc / 100)
end

lain.widgets.bat({ battery = "BAT1", timeout = 15, settings = batcallback })

for s = 1, screen.count() do
  gears.wallpaper.maximized(wallpaper, s, false)

  local taglist = awful.widget.taglist(
    s,
    awful.widget.taglist.filter.all,
    tagbuttons
  )
  -- local tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, taskbuttons)

  local left = wibox.layout.fixed.horizontal()
  left:add(layoutbox)
  left:add(taglist)
  left:add(wibox.layout.margin(cpuwidget, 5, 0, 0, 0))
  left:add(wibox.layout.margin(memwidget, 10, 0, 0, 0))

  local middle = wibox.layout.fixed.horizontal()
  -- Hack to make the clock widget look like it is centered
  middle:add(wibox.layout.margin(clockwidget, 0, 320, 0, 0))

  local right = wibox.layout.fixed.horizontal()
  right:add(battextwidget)
  right:add(batwidget)

  local layout = wibox.layout.align.horizontal()
  layout:set_left(left)
  layout:set_middle(middle)
  layout:set_right(right)

  local panel = awful.wibox({ position = "top", screen = s })
  panel:set_widget(layout)
end
