local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local lain = require("lain")

-- [[ Widgets ]] ---------------------------------------------------------------

local layoutbox = awful.widget.layoutbox(s)
layoutbox:buttons(layoutbuttons)

local clockwidget = awful.widget.textclock()

local battextwidget = wibox.widget.textbox()

baticon = wibox.widget.imagebox(beautiful.bat)
batbar = awful.widget.progressbar()
batbar:set_width(45)
batbar:set_ticks(true)
batbar:set_ticks_size(5)
batbar:set_background_color(beautiful.bg_normal)
batmargin = wibox.layout.margin(batbar, 2, 7)
batmargin:set_top(6)
batmargin:set_bottom(6)

batupd = lain.widgets.bat({
  battery = "BAT1",
  timeout = 15,
  settings = function()
    if bat_now.status == "N/A" then return end

    battextwidget:set_text(bat_now.time .. " ")

    if bat_now.status == "Charging" then
      baticon:set_image(beautiful.ac)
      if bat_now.perc >= 98 then
        batbar:set_color(green)
      elseif bat_now.perc > 50 then
        batbar:set_color(black)
      elseif bat_now.perc > 15 then
        batbar:set_color(orange)
      else
        batbar:set_color(red)
      end
    else
      if bat_now.perc > 98 then
        batbar:set_color(green)
        baticon:set_image(beautiful.bat)
      elseif bat_now.perc > 15 then
        batbar:set_color(orange)
        baticon:set_image(beautiful.bat_low)
      else
        batbar:set_color(red)
        baticon:set_image(beautiful.bat_no)
      end
    end

    batbar:set_value(bat_now.perc / 100)
  end
})
batwidget = wibox.widget.background(batmargin)
batwidget:set_bgimage(beautiful.widget_bg)

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
