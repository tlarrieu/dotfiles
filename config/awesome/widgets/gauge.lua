--- Power gauges (battery, earbuds…), fed by upower
--- Panel widget factory: require('widgets.gauge').make(icon, device_pattern)
--- returns a PanelWidget. A single `upower --monitor` serves all the gauges.

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')

---@class Gauge: PanelWidget
---@field pattern string upower device path fragment (battery_, headset_…)

---@type Gauge[]
local gauges = {}

---@type integer|string? Pid of the shared monitor (an error string if it failed)
local monitor_pid = nil

-- Repaint the gauges whose device upower reports a change for
local start_monitor = function()
  monitor_pid = awful.spawn.with_line_callback('upower --monitor', {
    ---@param line string
    stdout = function(line)
      for _, gauge in ipairs(gauges) do
        if line:find(gauge.pattern, 1, true) then gauge.update() end
      end
    end,
  })

  awesome.connect_signal('exit', function()
    if type(monitor_pid) == 'number' then awesome.kill(monitor_pid, awesome.unix_signal.SIGTERM) end
  end)
end

local M = {}

-- A gauge for the first upower device matching `device_pattern`, hidden when
-- there's none (or it reports no percentage)
---@param icon string Markup shown before the bar
---@param device_pattern string upower device path fragment (battery_, headset_…)
---@return Gauge
M.make = function(icon, device_pattern)
  ---@type ProgressBar
  local bar = wibox.widget({
    min_value    = 0,
    max_value    = 100,
    forced_width = 80,
    paddings     = 1,
    border_width = 0,
    visible      = false,
    widget       = wibox.widget.progressbar,
  })

  ---@type Widget
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

  ---@type SpawnCallback
  local paint = function(out)
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
  end

  ---@type Gauge
  local gauge = {
    widget = widget,
    update = function() awful.spawn.easy_async_with_shell(shell_cmd, paint) end,
    pattern = device_pattern,
  }

  table.insert(gauges, gauge)
  if not monitor_pid then start_monitor() end

  return gauge
end

return M
