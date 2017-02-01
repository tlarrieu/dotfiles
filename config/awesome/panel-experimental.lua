local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local lain = require("lain")

local function colorize(widget, value)
  local color

  if value > 80 then
    color = beautiful.colors.red
  elseif value > 70 then
    color = beautiful.colors.orange
  elseif value > 40 then
    color = beautiful.colors.yellow
  else
    color = beautiful.colors.green
  end

  widget:set_values({ value })
  widget:set_colors({ color })
end

local function arcprogress(label)
  local text = wibox.widget({
    valign = "center",
    align = "center",
    widget = wibox.widget.textbox,
  })
  local arcchart = wibox.container({
    text,
    widget = wibox.container.arcchart,
    min_value = 0,
    max_value = 100,
    bg = beautiful.colors.base2,
    thickness = 3,
  })
  arcchart:connect_signal("widget::redraw_needed", function(widget)
    if widget:get_colors() == nil then return end

    local markup = lain.util.markup(widget:get_colors()[1], label)

    text:set_markup(lain.util.markup.small(markup))
  end)

  return arcchart
end

-- [[ CPU ]] -------------------------------------------------------------------
local cpu = arcprogress("C")
lain.widgets.cpu({
  timeout = 2,
  settings = function() colorize(cpu, cpu_now.usage) end
})

-- [[ MEM ]] -------------------------------------------------------------------
local mem = arcprogress("M")
lain.widgets.mem({
  timeout = 2,
  settings = function() colorize(mem, mem_now.perc) end
})

-- [[ Clock ]] -----------------------------------------------------------------
local clock = wibox.widget({
  widget = wibox.widget.textclock,
  format = "%Y.%m.%d %H:%M",
})

-- [[ Battery ]] ---------------------------------------------------------------
local batterytext = wibox.widget.textbox()
local batterybar = wibox.widget({
  widget = wibox.widget.progressbar,
  background_color = beautiful.colors.base2,
  bar_shape = gears.shape.rounded_rect,
  forced_width = 90,
  shape = gears.shape.rounded_rect,
})
local battery = wibox.widget({
  batterytext,
  wibox.container.margin(batterybar, 5, 0, 8, 8),
  layout = wibox.layout.fixed.horizontal
})
local function battery_update()
  if bat_now.status == "N/A" then return end

  local color, legend, icon

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
      icon = " "
    else
      icon = " "
    end
  end

  batterytext:set_markup(lain.util.markup(color, icon .. legend))
  batterybar:set_color(color)
  batterybar:set_value(bat_now.perc / 100)
end
lain.widgets.bat({ battery = "BAT1", timeout = 15, settings = battery_update })

-- [[ Screen initialization ]] -------------------------------------------------
local function init_screen(screen)
  tagbuttons = awful.util.table.join(
    awful.button({}, 1, function(tag) tag:view_only() end)
  )
  local taglist = awful.widget.taglist(
    screen,
    awful.widget.taglist.filter.all,
    tagbuttons,
    { spacing = 6, font = "InconsolataForPowerline Nerd Font 24" }
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
    wibox.container.margin(cpu, 0, 5, 0, 0),
    wibox.container.margin(mem, 0, 10, 0, 0),
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
end
awful.screen.connect_for_each_screen(init_screen)
