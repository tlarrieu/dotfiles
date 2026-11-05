--- Panel counters fed by a GitHub tracker (~/scripts/review-queue,
--- merge-queue): an icon and a count, a tooltip listing what's counted, left
--- click opening rofi-github on it, right click refreshing (and telling how
--- it went). Hidden while there's nothing to count.
--- Panel widget factory: require('widgets.counter').make(options) returns a
--- PanelWidget.

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local records = require('records')

local scripts = os.getenv('HOME') .. '/scripts'

---@class CounterView What a counter shows of its tracker's records
---@field color string #rrggbb
---@field count integer
---@field rows string[] Tooltip lines (markup)
---@field busy? boolean Poll at CounterOptions.poll.busy

---@class CounterOptions
---@field script string The tracker, in ~/scripts (with --cached, it prints its cache)
---@field signal string What the tracker emits once it refreshed
---@field app string Notifications app name
---@field icon string Glyph
---@field icon_size integer Points
---@field filter string rofi-github search picking what's counted
---@field title string Notification title, as in "<title> refreshed"
---@field describe fun(count: integer): string A refresh's notification text
---@field render fun(records: Record[], colors: table): CounterView
---@field poll? { idle: integer, busy?: integer } Seconds between refreshes (none: another counter polls the tracker)
---@field quiet_when_unwatched? boolean Hide rather than show a red ! when the tracker has no repository to watch

local M = {}

---@param options CounterOptions
---@return PanelWidget
M.make = function(options)
  local command = scripts .. '/' .. options.script

  ---@type Widget
  local icon = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
  ---@type Widget
  local count = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
  -- Icon and count in their own textboxes, both centered: sharing one line would
  -- sit the count on the bigger glyph's baseline
  ---@type Widget
  local label = wibox.widget({ icon, count, spacing = 6, layout = wibox.layout.fixed.horizontal })
  ---@type Widget
  local separator = wibox.widget({ widget = wibox.widget.textbox })
  ---@type Widget
  local widget = wibox.widget({
    label,
    { separator, left = 10, right = 10, layout = wibox.container.margin },
    visible = false,
    layout = wibox.layout.fixed.horizontal,
  })
  local tooltip = require('widgets.tooltip').make(label)

  ---@param color string #rrggbb
  ---@param text string
  local paint = function(color, text)
    icon.markup = ('<span font="%s %d" color="%s">%s</span>'):format(
      beautiful.icon_font, options.icon_size, color, options.icon)
    count.markup = ('<span color="%s">%s</span>'):format(color, text)
  end

  -- The tracker's complaint, without its name
  ---@param err string
  ---@return string
  local complaint = function(err)
    local prefix = options.script:gsub('%p', '%%%0') .. ': '
    return (err:gsub('^' .. prefix, ''):gsub('%s+$', ''))
  end

  ---@type Timer?
  local poller

  ---@type SpawnCallback
  local render = function(out, err, _, code)
    local colors = beautiful.colors
    separator.markup = ('<span color="%s">•</span>'):format(colors.fg.dimmer)

    -- No repository to watch (exit 2): say so, rather than look all clear
    if code == 2 then
      widget.visible = not options.quiet_when_unwatched
      paint(colors.red.base, '!')
      tooltip.text = complaint(err)
      return
    end

    local view = options.render(records.parse(out), colors)
    paint(view.color, tostring(view.count))
    tooltip.markup = table.concat(view.rows, '\n')
    widget.visible = view.count > 0

    local poll = options.poll
    if poller and poll and poll.busy then
      local interval = view.busy and poll.busy or poll.idle
      if poller.timeout ~= interval then
        poller.timeout = interval
        poller:again()
      end
    end
  end

  -- Repaint from the cache, without calling GitHub
  ---@type fun()
  local reload = function() awful.spawn.easy_async({ command, '--cached' }, render) end

  -- Tell how a clicked refresh went, so we know GitHub was actually asked
  ---@type SpawnCallback
  local report = function(out, err, _, code)
    local naughty = require('naughty')
    local counted = options.render(records.parse(out), beautiful.colors).count
    if code == 0 then
      naughty.notify({ app_name = options.app, title = options.title .. ' refreshed', text = options.describe(counted) })
    else
      naughty.notify({
        app_name = options.app,
        preset = naughty.config.presets.critical,
        title = options.title .. ' not refreshed',
        text = code == 2 and complaint(err)
            or ('Could not reach GitHub, showing the last known state (%d)'):format(counted),
      })
    end
  end

  label:buttons(gears.table.join(
    awful.button({}, 1, function() awful.spawn({ scripts .. '/rofi-github', options.filter }) end),
    awful.button({}, 3, function() awful.spawn.easy_async({ command }, report) end)
  ))

  -- The tracker signals each refresh, whoever asked for it
  awesome.connect_signal(options.signal, reload)
  if options.poll then
    poller = gears.timer({
      timeout = options.poll.idle,
      autostart = true,
      call_now = true,
      callback = function() awful.spawn.easy_async({ command }, function() end) end,
    })
  end
  gears.timer({ timeout = 60, autostart = true, callback = reload }) -- keep ages (and colors) current

  return { widget = widget, update = reload }
end

return M
