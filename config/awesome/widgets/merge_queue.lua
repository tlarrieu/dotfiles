-- Merge queue (my pull requests in it, see ~/scripts/merge-queue; the others
-- are in widgets/pull_requests.lua)
-- Panel widget, see panel.lua: returns { widget, update }

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local scripts = os.getenv('HOME') .. '/scripts'

-- Refresh fast while something is queued (it moves), slowly otherwise
---@type integer, integer
local busy_interval, idle_interval = 60, 300

---@type Widget
local icon = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
---@type Widget
local count = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
-- Icon and count in their own textboxes, both centered: sharing one line would
-- sit the count on the bigger glyph's baseline
---@type Widget
local label = wibox.widget({ icon, count, spacing = 6, layout = wibox.layout.fixed.horizontal })

---@param color string #rrggbb
---@param text string Markup
local paint = function(color, text)
  icon.markup = ('<span font="CaskaydiaCove Nerd Font Mono 16" color="%s"></span>'):format(color)
  count.markup = ('<span color="%s">%s</span>'):format(color, text)
end

---@type Widget
local separator = wibox.widget({ widget = wibox.widget.textbox })
---@type Widget
local widget = wibox.widget({
  label,
  { separator, left = 10, right = 10, layout = wibox.container.margin },
  visible = false,
  layout = wibox.layout.fixed.horizontal,
})
---@type Tooltip
local tooltip = require('widgets.tooltip').make(label)

-- Time to merge: 4m, 1h26
---@param seconds integer
---@return string
local eta = function(seconds)
  if seconds < 3600 then return math.ceil(seconds / 60) .. 'm' end
  return ('%dh%02d'):format(math.floor(seconds / 3600), math.floor(seconds % 3600 / 60))
end

---@type table<string, string>
local states = {
  QUEUED = 'queued',
  AWAITING_CHECKS = 'checks running',
  MERGEABLE = 'checks passed',
  UNMERGEABLE = 'checks failed',
  LOCKED = 'merging',
}

---@type Timer
local poller

-- Paint the queue printed by merge-queue --cached
-- Lines: <kind> <repo> <number> <position> <state> <eta> <additions> <deletions> <url> <queue url> <title>
---@type SpawnCallback
local render = function(out, err, _, code)
  local colors = beautiful.colors
  separator.markup = ('<span color="%s">•</span>'):format(colors.fg.dimmer)

  -- No repository to watch (exit 2): say so, rather than look all clear
  if code == 2 then
    paint(colors.red.base, '!')
    tooltip.text = (err:gsub('^merge%-queue: ', ''):gsub('%s+$', ''))
    widget.visible = true
    return
  end

  ---@type integer, boolean, string[]
  local queued, testing, rows = 0, false, {}

  for line in out:gmatch('[^\n]+') do
    local kind, repo, number, position, state, seconds, title = line:match(
      '^(%a+)\t([^\t]+)\t(%d+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t[^\t]*\t[^\t]*\t[^\t]*\t[^\t]*\t(.*)$')
    if kind then
      local name = ('%s#%s  %s'):format(
        gears.string.xml_escape((repo:gsub('^.*/', ''))), number, gears.string.xml_escape(title))
      if kind == 'queued' then
        queued = queued + 1
        testing = testing or state == 'AWAITING_CHECKS' or state == 'MERGEABLE'
        local when = tonumber(seconds) and eta(tonumber(seconds) --[[@as integer]]) or '?'
        table.insert(rows, ('<b>%4s</b>  %5s  %s <span fgalpha="60%%">(%s)</span>'):format(
          '#' .. position, when, name, states[state] or state:lower()))
      end
    end
  end

  paint(testing and colors.green.base or colors.fg.dim, tostring(queued))
  tooltip.markup = table.concat(rows, '\n')
  widget.visible = #rows > 0

  local interval = queued > 0 and busy_interval or idle_interval
  if poller and poller.timeout ~= interval then
    poller.timeout = interval
    poller:again()
  end
end

-- Ask GitHub (the script then signals merge-queue::changed, which reloads us)
---@type fun()
local refresh = function() awful.spawn.easy_async({ scripts .. '/merge-queue' }, function() end) end
-- Repaint from the cache, without calling GitHub
---@type fun()
local reload = function() awful.spawn.easy_async({ scripts .. '/merge-queue', '--cached' }, render) end

-- Tell how a clicked refresh went
---@type SpawnCallback
local report = function(out, err, _, code)
  ---@type integer
  local entries = select(2, ('\n' .. out):gsub('\nqueued\t', ''))
  local naughty = require('naughty')
  if code == 0 then
    naughty.notify({
      app_name = 'merge-queue',
      title = 'Merge queue refreshed',
      text = entries == 0 and 'Nothing queued'
          or ('%d pull request%s queued'):format(entries, entries > 1 and 's' or ''),
    })
  else
    naughty.notify({
      app_name = 'merge-queue',
      preset = naughty.config.presets.critical,
      title = 'Merge queue not refreshed',
      text = code == 2 and (err:gsub('^merge%-queue: ', ''):gsub('%s+$', ''))
          or ('Could not reach GitHub, showing the last known queue (%d)'):format(entries),
    })
  end
end

---@type fun()
local refresh_and_report = function() awful.spawn.easy_async({ scripts .. '/merge-queue' }, report) end

label:buttons(gears.table.join(
  awful.button({}, 1, function() awful.spawn({ scripts .. '/rofi-github', ':queued' }) end),
  awful.button({}, 3, refresh_and_report)
))

awesome.connect_signal('merge-queue::changed', reload)
poller = gears.timer({ timeout = idle_interval, autostart = true, call_now = true, callback = refresh })
gears.timer({ timeout = 60, autostart = true, callback = reload }) -- keep the panel in step with the cache

---@type PanelWidget
return { widget = widget, update = reload }
