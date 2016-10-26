local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local lain = require("lain")

local layoutbox = awful.widget.layoutbox(s)
layoutbox:buttons(layoutbuttons)

local clockwidget = awful.widget.textclock(
  lain.util.markup(beautiful.colors.base1, " %Y.%m.%d %H:%M")
)

local battextwidget = wibox.widget.textbox()
battextwidget:set_font("Inconsolata-g For Powerline 10")
local baticon = wibox.widget.imagebox(beautiful.bat)
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

  if bat_now.time == "00:00" then
    legend = "100%"
  else
    legend = bat_now.time
  end

  if bat_now.status == "Charging" then
    icon = beautiful.ac

    if bat_now.perc >= 98 then
      color = beautiful.colors.green
    elseif bat_now.perc > 50 then
      color = beautiful.fg_normal
    elseif bat_now.perc > 15 then
      color = beautiful.colors.yellow
    else
      color = beautiful.colors.red
    end
  else
    if bat_now.perc > 50 then
      color = beautiful.colors.green
      icon = beautiful.bat
    elseif bat_now.perc > 15 then
      color = beautiful.colors.yellow
      icon = beautiful.bat_low
    else
      color = beautiful.colors.red
      icon = beautiful.bat_no
    end
  end

  baticon:set_image(icon)
  battextwidget:set_markup(lain.util.markup(color, legend))
  batbar:set_color(color)
  batbar:set_value(bat_now.perc / 100)
end

lain.widgets.bat({ battery = "BAT1", timeout = 15, settings = batcallback })

for s = 1, screen.count() do
  gears.wallpaper.maximized(wallpaper, s, false)

  local taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, tagbuttons)
  local tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, taskbuttons)

  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(layoutbox)
  left_layout:add(taglist)

  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(clockwidget)
  right_layout:add(baticon)
  right_layout:add(battextwidget)
  right_layout:add(batwidget)

  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(tasklist)
  layout:set_right(right_layout)

  local toppanel = awful.wibox({ position = "top", screen = s })
  toppanel:set_widget(layout)
end
