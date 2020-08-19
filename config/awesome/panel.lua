local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local apply_dpi = require('beautiful.xresources').apply_dpi

local lain = require("lain")

local font = "Fira Code 11"
local tagsfont = "Inconsolata Regular Nerd Font 20"
local clockfont = "Fira Code 11"

local colorize = function(widget, value)
  local color

  if value > 80 then
    color = beautiful.colors.red.dark
  elseif value > 40 then
    color = beautiful.colors.yellow.dark
  else
    color = beautiful.colors.green.dark
  end

  widget:set_values({ value })
  widget:set_colors({ color })
end

local arcprogress = function(label)
  local text = wibox.widget({
    valign = "center",
    align = "center",
    widget = wibox.widget.textbox,
    font = font
  })
  local arcchart = wibox.container({
    text,
    widget = wibox.container.arcchart,
    min_value = 0,
    max_value = 100,
    bg = "#FF000000",
    thickness = apply_dpi(3),
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
  settings = function(cpu_now) colorize(cpu, cpu_now.usage) end
})

-- [[ MEM ]] -------------------------------------------------------------------
local mem = arcprogress("M")
lain.widgets.mem({
  timeout = 2,
  settings = function(mem_now) colorize(mem, mem_now.perc) end
})

-- [[ Clock ]] -----------------------------------------------------------------
local clock = wibox.widget({
  widget = wibox.widget.textclock,
  format = "%Y.%m.%d %H:%M",
  font = clockfont,
})

-- [[ Battery ]] ---------------------------------------------------------------
local battery

local pipe = io.popen(
  'ls /sys/class/power_supply | grep BAT | head -n 1 | tr -d "\n"'
)
local batteryname = pipe:read('*a')
pipe:close()

local batterytext = wibox.widget({
  widget = wibox.widget.textbox,
  font = font
})

if batteryname then
  battery = wibox.widget({
    batterytext,
    layout = wibox.layout.fixed.horizontal,
  })

  local batteryicons = {
    charging = {
      { level = 10, icon = "" },
      { level = 20, icon = "" },
      { level = 30, icon = "" },
      { level = 40, icon = "" },
      { level = 60, icon = "" },
      { level = 80, icon = "" },
      { level = 90, icon = "" },
      { level = 100, icon = "" },
    },
    discharging = {
      { level = 10, icon = "" },
      { level = 20, icon = "" },
      { level = 30, icon = "" },
      { level = 40, icon = "" },
      { level = 50, icon = "" },
      { level = 60, icon = "" },
      { level = 70, icon = "" },
      { level = 80, icon = "" },
      { level = 90, icon = "" },
      { level = 100, icon = "" },
    },
  }

  local battery_update = function(bat_now)
    if bat_now.status == "N/A" then return end

    local color, legend, icon

    local arrow = bat_now.status == "Discharging"
      and ""
      or ""

    -- legend
    legend = bat_now.time == "00:00" and "100%" or (arrow .. " " .. bat_now.time)

    -- color
    if bat_now.perc >= 98 then
      color = beautiful.colors.green.dark
    elseif bat_now.perc > 15 then
      color = beautiful.colors.yellow.dark
    else
      color = beautiful.colors.red.dark
    end

    local iconset = batteryicons.discharging

    for _, config in ipairs(iconset) do
      if bat_now.perc <= config.level then
        icon = config.icon
        break
      end
    end

    local markup = lain.util.markup(color, icon .. " " .. legend)
    batterytext:set_markup(markup)
  end

  lain.widgets.bat({
    battery = batteryname,
    timeout = 15,
    settings = battery_update,
    notifications = {
      low = {
        fg = beautiful.colors.red.dark,
        bg = beautiful.colors.background
      },
      critical = {
        fg = beautiful.colors.foreground,
        bg = beautiful.colors.red.dark
      }
    }
  })
end

-- [[ Screen initialization ]] -------------------------------------------------
local init_screen = function(screen)
  local dpi = function(n) return apply_dpi(n, screen) end

  local taglist = awful.widget.taglist({
    screen = screen,
    filter = function(tag) return #tag.screen.tags > 1 end,
    style = { spacing = dpi(6), font = tagsfont },
  })

  local left = wibox.widget({
    wibox.container.margin(battery, dpi(10), dpi(10), dpi(2), dpi(2)),
    wibox.container.margin(cpu, dpi(0), dpi(5), dpi(2), dpi(2)),
    wibox.container.margin(mem, dpi(0), dpi(10), dpi(2), dpi(2)),
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
