local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

-- [[ Clock ]] -----------------------------------------------------------------

local date = wibox.widget({ format = '%b %d', widget = wibox.widget.textclock })
local time = wibox.widget({ format = '%H:%M', widget = wibox.widget.textclock, })
local utcclock = wibox.widget({ format = '(󱉊 %H:%M)', opacity = 0.5, timezone = 'Z', widget = wibox.widget.textclock })

-- [[ Gauges (battery / earbuds power) ]] --------------------------------------

local make_gauge = function(icon, shell_cmd)
  local bar = wibox.widget({
    min_value    = 0,
    max_value    = 100,
    forced_width = 80,
    paddings     = 1,
    border_width = 0,
    visible      = false,
    widget       = wibox.widget.progressbar,
  })

  local widget = wibox.widget({
    { markup = ('<span size="large">%s</span>'):format(icon), widget = wibox.widget.textbox },
    { bar, top = 10, bottom = 10, layout = wibox.container.margin },
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
          or (value <= 20 and colors.yellow.base)
          or colors.bg.base
    end)
  end

  gears.timer({ callback = callback, timeout = 10, call_now = true, autostart = true })

  return widget, callback
end

local battery_widget, battery_callback = make_gauge('󰁹 ', [[ acpi | awk -F, '{ print $2 }' | tr -d ' %\n' ]])
local earbuds_widget, earbuds_callback = make_gauge('󰥈 ', [[
  upower --enumerate |
    grep headset -m 1 |
    xargs upower -i |
    awk '/percentage/ { print $2 }' |
    tr -d %
]])

-- [[ Public interface ]] ------------------------------------------------------

local M = {}

M.init = function(screen)
  battery_callback()
  earbuds_callback()

  local colors = beautiful.colors

  local highlight_current_tag = function(self, tag, _, _)
    self:get_children_by_id('highlight')[1].bg =
        tag.selected
        and colors.accent.base
        or colors.bg.base
  end

  local taglist = awful.widget.taglist({
    screen = screen,
    filter = function(tag) return #tag:clients() > 1 or #tag.screen.tags > 1 end,
    widget_template = {
      {
        { id = 'highlight', forced_height = 3, widget = wibox.container.background },
        {
          { id = 'text_role', widget = wibox.widget.textbox },
          bottom = 3,
          left = 10,
          right = 6,
          layout = wibox.container.margin,
        },
        widget = wibox.layout.align.vertical,
      },
      id = 'background_role',
      create_callback = highlight_current_tag,
      update_callback = highlight_current_tag,
      widget = wibox.container.background,
    },
  })

  local glyph = require('glyphs').number(screen.index)
  local screennum = {
    markup = ('<span size="large">󰍹 %s </span>'):format(glyph),
    widget = wibox.widget.textbox
  }


  local ctx = require('context').get()
  local context = {
    markup = ('<span color="%s"><b>@%s</b></span>'):format(ctx == 'work' and colors.red.base or colors.green.base, ctx),
    widget = wibox.widget.textbox
  }

  if screen.wibar then screen.wibar:remove() end

  local spacer = wibox.widget({
    markup = ('<span color="%s">•</span>'):format(beautiful.colors.fg.dimmer),
    widget = wibox.widget.textbox,
  })

  screen.wibar = awful.wibar({
    position = 'top',
    height = 32,
    screen = screen,
    margins = { top = 6, bottom = 0, left = 6, right = 6 },
    bg = colors.bg.base,
    widget = {
      {
        { screennum, left = 10, layout = wibox.container.margin },
        { battery_widget, left = 6, right = 6, layout = wibox.container.margin },
        { earbuds_widget, left = 6, right = 6, layout = wibox.container.margin },
        layout = wibox.layout.fixed.horizontal
      },
      taglist,
      {
        { context, layout = wibox.container.margin },
        { spacer, left = 10, right = 10, layout = wibox.container.margin },
        { date, layout = wibox.container.margin },
        { spacer, left = 10, right = 10, layout = wibox.container.margin },
        { time, layout = wibox.container.margin },
        { utcclock, left = 10, right = 10, layout = wibox.container.margin },
        layout = wibox.layout.fixed.horizontal
      },
      expand = 'none',
      layout = wibox.layout.align.horizontal,
    }
  })
end

M.reset = function() for s in screen do M.init(s) end end

return M
