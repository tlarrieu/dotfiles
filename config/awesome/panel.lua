local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
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

-- [[ Gauges (battery / earbuds power) ]] --------------------------------------

local make_gauge = function(icon, shell_cmd)
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
      markup = ('<span size="large">%s</span>'):format(icon),
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

      local colors = beautiful.colors
      widget.visible = true
      bar.visible = true
      bar.value = value
      bar.color = value <= 10 and colors.red.base
          or (value <= 20 and colors.yellow)
          or colors.bg.base
    end)
  end

  gears.timer({ callback = callback, timeout = 10, call_now = true, autostart = true })

  return widget, callback
end

local earbuds_widget, earbuds_callback = make_gauge('󰥈 ', [[
  upower --enumerate |
    grep headset -m 1 |
    xargs upower -i |
    awk '/percentage/ { print $2 }' |
    tr -d %
]])
local battery_widget, battery_callback = make_gauge('󰁹 ', [[ acpi | awk -F, '{ print $2 }' | tr -d ' %\n' ]])

-- [[ Public interface ]] ------------------------------------------------------
local M = {}

M.init = function(screen)
  battery_callback()
  earbuds_callback()

  local colors = beautiful.colors

  local highlight_id = 'highlight'
  local highlight_current_tag = function(self, tag, _, _)
    self:get_children_by_id(highlight_id)[1].bg =
        tag.selected
        and colors.accent.base
        or colors.bg.base
  end

  local taglist = awful.widget.taglist({
    screen = screen,
    filter = function(tag) return #tag:clients() > 1 or #tag.screen.tags > 1 end,
    widget_template = {
      {
        {
          {
            id = 'text_role',
            widget = wibox.widget.textbox,
          },
          top = 8,
          bottom = 3,
          left = 8,
          right = 3,
          layout = wibox.container.margin,
        },
        {
          id = highlight_id,
          widget = wibox.container.background,
        },
        widget = wibox.layout.align.vertical,
      },
      id = 'background_role',
      widget = wibox.container.background,
      create_callback = highlight_current_tag,
      update_callback = highlight_current_tag,
    },
  })

  local glyph = require('glyphs').number(screen.index)
  local screennum = wibox.widget({
    markup = string.format('<span size="large">󰍹 %s </span>', glyph),
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  })


  local ctx = require('context').get()
  local ctx_color = ctx == 'work' and colors.red.base or colors.green.base
  local context = wibox.widget({
    markup = string.format('<span color="%s"><b>@%s</b></span>', ctx_color, ctx),
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  })

  local left = wibox.widget({
    wibox.container.margin(screennum, 10, 0, 5, 5, nil, false),
    wibox.container.margin(battery_widget, 10, 5, 8, 8, nil, false),
    wibox.container.margin(earbuds_widget, 10, 5, 8, 8, nil, false),
    layout = wibox.layout.fixed.horizontal
  })

  local middle = wibox.widget({
    wibox.container.margin(taglist, 0, 0, 0, 0, nil, false),
    layout = wibox.layout.fixed.horizontal
  })

  local right = wibox.widget({
    wibox.container.margin(context, 10, 0, 0, 0),
    wibox.container.margin(clock, 10, 0, 0, 0),
    wibox.container.margin(utcclock, 10, 10, 0, 0),
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
    height = 32,
    screen = screen,
    margins = { top = 6, bottom = 0, left = 6, right = 6 },
    bg = colors.bg.base,
    widget = barwidget
  })
end

M.reset = function() for s in screen do M.init(s) end end

return M
