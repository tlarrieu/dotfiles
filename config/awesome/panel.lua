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

-- [[ Context ]] -----------------------------------------------------------------
local context = wibox.widget({
  markup = 'context',
  align  = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
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

local buds_widget = wibox.widget({
  { markup = '<span size="small">󱡏 </span>', align = 'center', valign = 'center', widget = wibox.widget.textbox },
  earbuds,
  layout = wibox.layout.stack,
})

local earbuds_callback = function()
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
      buds_widget.visible = false
      return
    end

    earbuds.border_color = beautiful.colors.foreground

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

gears.timer({ callback = earbuds_callback, timeout = 10, call_now = true, autostart = true })

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

local bat_widget = wibox.widget({
  { markup = '<span size="medium">󱊣 </span>', align = 'center', valign = 'center', widget = wibox.widget.textbox },
  battery,
  layout = wibox.layout.fixed.horizontal,
})

local battery_callback = function()
  local cmd = [[ acpi | awk -F, '{ print $2 }' | tr -d ' %\n' ]]
  awful.spawn.easy_async_with_shell(cmd, function(out)
    local value = tonumber(out)

    if not value then
      bat_widget.visible = false
      return
    end

    battery.border_color = beautiful.colors.foreground

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

gears.timer({ callback = battery_callback, timeout = 10, call_now = true, autostart = true })

local init = function(screen)
  battery_callback()
  earbuds_callback()

  local dpi = function(n) return apply_dpi(n, screen) end

  local taglist = awful.widget.taglist({
    screen = screen,
    filter = function(tag) return #tag:clients() > 1 or #tag.screen.tags > 1 end,
    style = { spacing = dpi(10) },
    layout = { spacing_widget = wibox.widget.textbox('•'), layout = wibox.layout.fixed.horizontal },
    widget_template = {
      {
        {
          { id = 'text_role', widget = wibox.widget.textbox },
          layout = wibox.layout.fixed.horizontal,
        },
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin
      },
      id = 'background_role',
      widget = wibox.container.background,
    },
  })

  local color = beautiful.colors.foreground
  local glyph = require('glyphs').number(screen.index)
  local markup = '<span color="' .. color .. '" size="large">󰍹 ' .. glyph .. ' </span>'
  local screennum = wibox.widget({
    markup = markup,
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  })

  local cmd = "sh -c '. " .. require('context').path .. " && echo $CONTEXT'"
  awful.spawn.easy_async_with_shell(cmd, function(out)
    out = out:gsub("[\n\r]", '')

    local context_color = out == 'work'
        and beautiful.colors.red.dark
        or beautiful.colors.green.dark

    context.markup = '<span color="' .. context_color .. '"><b>@' .. out .. '</b></span>'
  end)

  local left = wibox.widget({
    wibox.container.margin(screennum, dpi(10), dpi(0), dpi(5), dpi(5), nil, false),
    wibox.container.margin(bat_widget, dpi(10), dpi(5), dpi(8), dpi(8), nil, false),
    wibox.container.margin(buds_widget, dpi(10), dpi(5), dpi(8), dpi(8), nil, false),
    layout = wibox.layout.fixed.horizontal
  })

  local middle = wibox.widget({
    wibox.container.margin(taglist, dpi(0), dpi(0), dpi(5), dpi(5), nil, false),
    layout = wibox.layout.fixed.horizontal
  })

  local right = wibox.widget({
    wibox.container.margin(context, dpi(10), dpi(0), dpi(0), dpi(0)),
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
    margins = { top = dpi(6), bottom = dpi(0), left = dpi(6), right = dpi(6) },
    bg = beautiful.colors.background .. "e6",
    widget = barwidget
  })
end

local reset = function() for s in screen do init(s) end end

return {
  reset = reset,
  init = init
}
