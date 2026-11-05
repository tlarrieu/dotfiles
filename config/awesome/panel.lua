local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local glyphs = require('glyphs')
local context = require('context')

local agents = require('widgets.agents')
local reviews = require('widgets.reviews')

-- [[ Clock ]] -----------------------------------------------------------------

local date = wibox.widget({ format = '%b %d', widget = wibox.widget.textclock })
local time = wibox.widget({ format = '%H:%M', widget = wibox.widget.textclock, })
local utcclock = wibox.widget({ format = '(󱉊 %H:%M)', opacity = 0.5, timezone = 'Z', widget = wibox.widget.textclock })

-- [[ Gauges (battery / earbuds power) ]] --------------------------------------

local make_gauge = function(icon, device_pattern)
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
    {
      { markup = ('<span size="large">%s</span>'):format(icon), widget = wibox.widget.textbox },
      { bar, top = 10, bottom = 10, layout = wibox.container.margin },
      layout = wibox.layout.fixed.horizontal,
    },
    left = 6,
    right = 6,
    layout = wibox.container.margin
  })

  local shell_cmd = ([[
    upower --enumerate |
      grep %s -m 1 |
      xargs upower -i |
      awk '/percentage/ { print $2 }' |
      tr -d %%
  ]]):format(device_pattern)

  local update = function()
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
      bar.background_color = value <= 10 and colors.red.base
          or (value <= 20 and colors.yellow.base)
          or colors.fg.base
    end)
  end

  return { widget = widget, update = update }
end

local battery = make_gauge('󰁹 ', 'battery_')
local earbuds = make_gauge('󰥈 ', 'headset_')

local upower_monitor_pid = awful.spawn.with_line_callback('upower --monitor', {
  stdout = function(line)
    if line:find('battery_') then battery.update() end
    if line:find('headset_') then earbuds.update() end
  end,
})

awesome.connect_signal('exit', function()
  if type(upower_monitor_pid) == 'number' then awesome.kill(upower_monitor_pid, awesome.unix_signal.SIGTERM) end
end)

-- [[ Public interface ]] ------------------------------------------------------

local M = {}

M.init = function(screen)
  battery.update()
  earbuds.update()
  agents.update()
  reviews.update()

  local colors = beautiful.colors

  local highlight_current_tag = function(self, tag, _, _)
    self:get_children_by_id('highlight')[1].bg =
        tag.selected
        and colors.accent.base .. 'aa'
        or nil
  end

  local taglist = awful.widget.taglist({
    screen = screen,
    filter = function(tag) return #tag:clients() > 1 or #screen.tags > 1 end,
    widget_template = {
      {
        {
          { id = 'text_role', widget = wibox.widget.textbox },
          top = 5,
          left = 10,
          right = 6,
          forced_height = 28,
          layout = wibox.container.margin,
        },
        { id = 'highlight', widget = wibox.container.background },
        widget = wibox.layout.align.vertical,
      },
      id = 'background_role',
      create_callback = highlight_current_tag,
      update_callback = highlight_current_tag,
      widget = wibox.container.background,
    },
  })

  local screen_number = {
    markup = ('<span size="large">󰍹 %s </span>'):format(glyphs.number(screen.index)),
    widget = wibox.widget.textbox
  }

  local ctx = context.get()
  local current_context = {
    markup = ('<span color="%s">%s </span>'):format(
      ctx == 'work' and colors.red.base or colors.green.base,
      ctx == 'work' and '󰡢' or ''
    ),
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
    bg = colors.bg.base .. 'e4',
    widget = {
      {
        { screen_number, left = 10, layout = wibox.container.margin },
        battery.widget,
        earbuds.widget,
        layout = wibox.layout.fixed.horizontal
      },
      taglist,
      {
        reviews.widget,
        agents.widget,
        { current_context, layout = wibox.container.margin },
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
