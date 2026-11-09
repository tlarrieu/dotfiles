local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local glyphs = require('glyphs')
local context = require('context')

local agents = require('widgets.agents')
local reviews = require('widgets.reviews')
local merge_queue = require('widgets.merge_queue')
local pull_requests = require('widgets.pull_requests')
local deploys = require('widgets.deploys')

-- [[ Clock ]] -----------------------------------------------------------------

local date = wibox.widget({ format = '%b %d', widget = wibox.widget.textclock })
local time = wibox.widget({ format = '%H:%M', widget = wibox.widget.textclock, })
local utcclock = wibox.widget({ format = '(󱉊 %H:%M)', opacity = 0.5, timezone = 'Z', widget = wibox.widget.textclock })

-- [[ Gauges (battery / earbuds power) ]] --------------------------------------

local battery = require('widgets.gauge').make('󰁹', 'battery_')
local earbuds = require('widgets.gauge').make('󰥈', 'headset_')

-- [[ Public interface ]] ------------------------------------------------------

local M = {}

M.init = function(screen)
  battery.update()
  earbuds.update()
  agents.update()
  reviews.update()
  merge_queue.update()
  pull_requests.update()
  deploys.update()

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
        pull_requests.widget,
        merge_queue.widget,
        deploys.widget,
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
