local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local apply_dpi = require('beautiful.xresources').apply_dpi
local gears = require('gears')

-- [[ Clock ]] -----------------------------------------------------------------
local clock = wibox.widget({
  widget = wibox.widget.textclock,
  format = '• %b %d • %H:%M',
})
local utcclock = wibox.widget({
  widget = wibox.widget.textclock,
  format = '(󱉊 %H:%M)',
  opacity = 0.5,
  timezone = 'Z',
})

-- [[ Context ]] ---------------------------------------------------------------
local context = wibox.widget({
  markup = 'context',
  align  = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
})

-- [[ Gauges (battery / earbuds power) ]] --------------------------------------
local threshold_color = function(colors, value)
  if value <= 10 then return colors.red.base end
  if value <= 20 then return colors.yellow.base end
  return colors.bg.base
end

local make_gauge = function(icon_markup, shell_cmd)
  local bar = wibox.widget({
    widget       = wibox.widget.progressbar,
    min_value    = 0,
    max_value    = 100,
    forced_width = 80,
    paddings     = 1,
    border_width = 0,
    visible      = false,
  })

  local widget = wibox.widget({
    {
      markup = icon_markup,
      align = 'center',
      valign = 'center',
      widget = wibox.widget.textbox,
    },
    bar,
    layout = wibox.layout.fixed.horizontal,
  })

  local callback = function()
    awful.spawn.easy_async_with_shell(shell_cmd, function(out)
      local value = tonumber(out)

      if not value then
        widget.visible = false
        return
      end

      widget.visible = true
      bar.visible = true
      bar.value = value
      bar.color = threshold_color(beautiful.colors, value)
    end)
  end

  return widget, callback
end

local earbuds_widget, earbuds_callback = make_gauge('<span size="large">󰥈 </span>', [[
      upower --enumerate |
        grep headset |
        head -n 1 |
        xargs upower -i |
        grep percentage |
        awk '{ print $2 }' |
        sed 's/%//'
    ]])
gears.timer({ callback = earbuds_callback, timeout = 10, call_now = true, autostart = true })

local battery_widget, battery_callback = make_gauge(
  '<span size="large">󰁹 </span>',
  [[ acpi | awk -F, '{ print $2 }' | tr -d ' %\n' ]]
)
gears.timer({ callback = battery_callback, timeout = 10, call_now = true, autostart = true })

-- [[ Public interface ]] ------------------------------------------------------
local M = {}

M.init = function(screen)
  battery_callback()
  earbuds_callback()

  local dpi = function(n) return apply_dpi(n, screen) end
  local colors = beautiful.colors

  local taglist = awful.widget.taglist({
    screen = screen,
    filter = function(tag) return #tag:clients() > 1 or #tag.screen.tags > 1 end,
    style = { spacing = dpi(10) },
    layout = {
      spacing_widget = {
        markup = string.format('<span color="%s">•</span>', colors.fg.dim),
        widget = wibox.widget.textbox,
      },
      layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
      {
        {
          {
            id = 'text_role',
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.align.horizontal,
        },
        left = dpi(10),
        right = dpi(5),
        widget = wibox.container.margin
      },
      id = 'background_role',
      widget = wibox.container.background,
    },
  })

  local glyph = require('glyphs').number(screen.index)
  local screennum = wibox.widget({
    markup = string.format('<span size="large">󰍹 %s </span>', glyph),
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  })

  local cmd = "sh -c '. " .. require('context').path .. " && echo $CONTEXT'"
  awful.spawn.easy_async_with_shell(cmd, function(out)
    out = out:gsub("[\n\r]", '')

    local context_color = out == 'work'
        and colors.red.base
        or colors.green.base

    context.markup = string.format('<span color="%s"><b>@%s</b></span>', context_color, out)
  end)

  local left = wibox.widget({
    wibox.container.margin(screennum, dpi(10), dpi(0), dpi(5), dpi(5), nil, false),
    wibox.container.margin(battery_widget, dpi(10), dpi(5), dpi(8), dpi(8), nil, false),
    wibox.container.margin(earbuds_widget, dpi(10), dpi(5), dpi(8), dpi(8), nil, false),
    layout = wibox.layout.fixed.horizontal
  })

  local middle = wibox.widget({
    wibox.container.margin(taglist, dpi(0), dpi(0), dpi(5), dpi(5), nil, false),
    layout = wibox.layout.fixed.horizontal
  })

  local right = wibox.widget({
    wibox.container.margin(context, dpi(10), dpi(0), dpi(0), dpi(0)),
    wibox.container.margin(clock, dpi(10), dpi(0), dpi(0), dpi(0)),
    wibox.container.margin(utcclock, dpi(10), dpi(10), dpi(0), dpi(0)),
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
    margins = { top = dpi(6), bottom = dpi(0), left = dpi(6), right = dpi(6) },
    bg = colors.bg.dim .. 'e6',
    widget = barwidget
  })
end

M.reset = function() for s in screen do M.init(s) end end

return M
