local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local apply_dpi = require('beautiful.xresources').apply_dpi
local gears = require('gears')
local pipe

-- [[ Clock ]] -----------------------------------------------------------------
local clock = wibox.widget({
  widget = wibox.widget.textclock,
  format = '%Y.%m.%d %H:%M',
})

-- [[ earbuds power ]] -------------------------------------------------------
local earbuds = wibox.widget({
  widget       = wibox.widget.progressbar,
  min_value    = 0,
  max_value    = 100,
  forced_width = 70,
  paddings     = 1,
  border_width = 0,
  visible      = false,
  border_color = beautiful.colors.foreground,
})

gears.timer({
  timeout = 10,
  call_now = true,
  autostart = true,
  callback = function()
    local cmd = [[
      upower --enumerate |
        grep headset |
        head -n 1 |
        xargs upower -i |
        grep percentage |
        awk '{ print $2 }' |
        sed 's/%//'
    ]]
    awful.spawn.easy_async_with_shell(cmd, function(out)
      local value = tonumber(out)

      if not value then
        earbuds.visible = false
        return
      end

      earbuds.visible = true
      earbuds.value = value
      if value <= 10 then
        earbuds.color = beautiful.colors.red.dark
      elseif value <= 20 then
        earbuds.color = beautiful.colors.yellow.dark
      else
        earbuds.color = beautiful.colors.background
      end
    end)
  end
})

-- [[ Battery ]] ---------------------------------------------------------------
local battery = wibox.widget({
  widget       = wibox.widget.progressbar,
  min_value    = 0,
  max_value    = 100,
  forced_width = 70,
  paddings     = 1,
  border_width = 0,
  visible      = false,
  border_color = beautiful.colors.foreground,
})

gears.timer({
  timeout = 10,
  call_now = true,
  autostart = true,
  callback = function()
    local cmd = [[
      acpi |
        awk '{ print $3,$4 }' |
        awk -F, '{ print $2 }' |
        tr -d ' %\n'
    ]]
    awful.spawn.easy_async_with_shell(cmd, function(out)
      local value = tonumber(out)

      if not value then
        battery.visible = false
        return
      end

      battery.visible = true
      battery.value = value
      if value <= 10 then
        battery.color = beautiful.colors.red.dark
      elseif value <= 20 then
        battery.color = beautiful.colors.yellow.dark
      else
        battery.color = beautiful.colors.background
      end
    end)
  end
})

return {
  init = function(screen)
    local dpi = function(n) return apply_dpi(n, screen) end

    local taglist = awful.widget.taglist({
      screen = screen,
      filter = function(tag)
        return #tag:clients() > 1 or #tag.screen.tags > 1
      end,
      style  = { spacing = dpi(18) },
      layout = {
        spacing_widget = {
          widget = wibox.widget.separator,
        },
        layout = wibox.layout.fixed.horizontal
      }
    })

    local left = wibox.widget({
      wibox.container.margin(battery, dpi(10), dpi(10), dpi(10), dpi(10), nil, false),
      wibox.container.margin(earbuds, dpi(10), dpi(10), dpi(10), dpi(10), nil, false),
      layout = wibox.layout.fixed.horizontal
    })

    local middle = wibox.widget({
      wibox.container.margin(taglist, dpi(0), dpi(0), dpi(5), dpi(5), nil, false),
      layout = wibox.layout.fixed.horizontal
    })

    local right = wibox.widget({
      wibox.container.margin(clock, dpi(10), dpi(10), dpi(0), dpi(0)),
      layout = wibox.layout.fixed.horizontal
    })

    local barwidget = wibox.widget({
      left,
      middle,
      right,
      layout = wibox.layout.align.horizontal,
      expand = 'none'
    })

    if screen.wibar then screen.wibar:remove() end

    screen.wibar = awful.wibar({
      position = 'top',
      height = dpi(32),
      screen = screen,
      margins = { top = dpi(6), bottom = dpi(-2), left = dpi(6), right = dpi(6) },
      bg = beautiful.colors.background .. "e6",
      widget = barwidget
    })
  end
}
