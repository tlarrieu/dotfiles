-- My pull requests not in the merge queue: drafts, blocked, ready to enqueue
-- (see ~/scripts/merge-queue, whose cache it reads; widgets/merge_queue.lua
-- shows the queued ones and owns the polling)
-- Panel widget, see panel.lua: returns { widget, update }

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local scripts = os.getenv('HOME') .. '/scripts'

---@type Widget
local icon = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
---@type Widget
local count = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
-- Icon and count in their own textboxes, both centered: sharing one line would
-- sit the count on the bigger glyph's baseline
---@type Widget
local label = wibox.widget({ icon, count, spacing = 6, layout = wibox.layout.fixed.horizontal })

-- Paint the icon and the count
---@param color string #rrggbb
---@param text string
local paint = function(color, text)
  icon.markup = ('<span font="CaskaydiaCove Nerd Font Mono 16" color="%s">󰓂</span>'):format(color)
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
local tooltip = awful.tooltip({ objects = { label }, mode = 'outside', preferred_alignments = { 'middle' } })

-- Time since the last update: 42m, 3h, 2d
---@param seconds integer
---@return string
local age = function(seconds)
  if seconds < 3600 then return math.floor(seconds / 60) .. 'm' end
  if seconds < 86400 then return math.floor(seconds / 3600) .. 'h' end
  return math.floor(seconds / 86400) .. 'd'
end

---@alias Urgency 'mine'|'ready'|'waiting' Needs me / to enqueue / on others (or a draft)

-- What blocks a pull request, in a word, and whether it's on me
---@type table<string, { label: string, urgency: Urgency }>
local states = {
  CONFLICT = { label = 'conflict', urgency = 'mine' },
  CHECKS_FAILING = { label = 'checks', urgency = 'mine' },
  CHANGES_REQUESTED = { label = 'changes', urgency = 'mine' },
  READY = { label = 'ready', urgency = 'ready' },
  CHECKS_PENDING = { label = 'running', urgency = 'waiting' },
  REVIEW_REQUIRED = { label = 'review', urgency = 'waiting' },
  UNKNOWN = { label = 'unknown', urgency = 'waiting' },
  DRAFT = { label = 'draft', urgency = 'waiting' },
}

-- Paint the non-queued pull requests printed by merge-queue --cached (already
-- in picker order: drafts, blocked, ready)
-- Lines: <kind> <repo> <number> <position> <state> <time> <url> <queue url> <title>
---@type SpawnCallback
local render = function(out, _, _, code)
  local colors = beautiful.colors
  separator.markup = ('<span color="%s">•</span>'):format(colors.fg.dimmer)

  -- No repository to watch: the merge queue widget already says so
  if code == 2 then
    widget.visible = false
    return
  end

  ---@type integer, table<Urgency, boolean>, string[]
  local now, urgencies, rows = os.time(), {}, {}

  for line in out:gmatch('[^\n]+') do
    local kind, repo, number, state, time, title = line:match(
      '^(%a+)\t([^\t]+)\t(%d+)\t[^\t]+\t([^\t]+)\t([^\t]+)\t[^\t]*\t[^\t]*\t(.*)$')
    if kind == 'ready' or kind == 'other' then
      local info = states[state] or { label = state:lower(), urgency = 'waiting' }
      urgencies[info.urgency] = true
      local since = tonumber(time)
      table.insert(rows, ('<b>%8s</b>  %3s  %s#%s  %s'):format(
        info.label, since and age(now - since --[[@as integer]]) or '',
        gears.string.xml_escape((repo:gsub('^.*/', ''))), number, gears.string.xml_escape(title)))
    end
  end

  local color = urgencies.mine and colors.red.base
      or urgencies.ready and colors.yellow.base
      or colors.fg.dim
  paint(color, tostring(#rows))
  tooltip.markup = table.concat(rows, '\n')
  widget.visible = #rows > 0
end

-- Repaint from the cache, without calling GitHub
---@type fun()
local reload = function() awful.spawn.easy_async({ scripts .. '/merge-queue', '--cached' }, render) end

-- Tell how a clicked refresh went
---@type SpawnCallback
local report = function(out, err, _, code)
  ---@type integer
  local entries = select(2, ('\n' .. out):gsub('\n%a+\t', '')) - select(2, ('\n' .. out):gsub('\nqueued\t', ''))
  local naughty = require('naughty')
  if code == 0 then
    naughty.notify({
      app_name = 'merge-queue',
      title = 'Pull requests refreshed',
      text = entries == 0 and 'No open pull request outside the merge queue'
          or ('%d open pull request%s outside the merge queue'):format(entries, entries > 1 and 's' or ''),
    })
  else
    naughty.notify({
      app_name = 'merge-queue',
      preset = naughty.config.presets.critical,
      title = 'Pull requests not refreshed',
      text = code == 2 and (err:gsub('^merge%-queue: ', ''):gsub('%s+$', ''))
          or ('Could not reach GitHub, showing the last known ones (%d)'):format(entries),
    })
  end
end

---@type fun()
local refresh_and_report = function() awful.spawn.easy_async({ scripts .. '/merge-queue' }, report) end

label:buttons(gears.table.join(
  awful.button({}, 1, function() awful.spawn({ scripts .. '/rofi-merge-queue' }) end),
  awful.button({}, 3, refresh_and_report)
))

-- merge-queue signals each refresh (the merge queue widget polls)
awesome.connect_signal('merge-queue::changed', reload)
gears.timer({ timeout = 60, autostart = true, callback = reload }) -- keep ages current

---@type PanelWidget
return { widget = widget, update = reload }
