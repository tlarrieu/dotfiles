-- Reviews (pull requests waiting on me, see ~/scripts/review-queue)
-- Panel widget, see panel.lua: returns { widget, update }

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local scripts = os.getenv('HOME') .. '/scripts'
-- Ages (seconds) from which the oldest request turns the widget yellow, then red
local warn_after, alert_after = 4 * 3600, 24 * 3600

---@type Widget
local icon = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
---@type Widget
local count = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
---@type Widget
local label = wibox.widget({ icon, count, spacing = 6, layout = wibox.layout.fixed.horizontal })

-- Paint the icon and the count (or a ! when misconfigured)
---@param color string #rrggbb
---@param text string|integer
local paint = function(color, text)
  icon.markup = ('<span font="CaskaydiaCove Nerd Font Mono 19" color="%s"></span>'):format(color)
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

-- How long a request has been waiting: 42m, 5h, 1d3h
---@param seconds integer
---@return string
local age = function(seconds)
  if seconds < 3600 then return math.floor(seconds / 60) .. 'm' end
  if seconds < 86400 then return math.floor(seconds / 3600) .. 'h' end
  return ('%dd%dh'):format(math.floor(seconds / 86400), math.floor(seconds % 86400 / 3600))
end

-- Paint the queue printed by review-queue --cached
-- Queue lines: <requested at> <repo> <number> <author> <+> <-> <url> <title>
---@type SpawnCallback
local render = function(out, err, _, code)
  local colors = beautiful.colors
  ---@type integer, integer, string[]
  local now, oldest, rows = os.time(), 0, {}

  separator.markup = ('<span color="%s">•</span>'):format(colors.fg.dimmer)

  -- No repository to watch (exit 2): say so, rather than look all clear
  if code == 2 then
    paint(colors.red.base, '!')
    tooltip.text = (err:gsub('^review%-queue: ', ''):gsub('%s+$', ''))
    widget.visible = true
    return
  end

  for line in out:gmatch('[^\n]+') do
    local at, repo, number, author, title = line:match(
      '^(%d+)\t([^\t]+)\t(%d+)\t([^\t]+)\t[^\t]*\t[^\t]*\t[^\t]*\t(.*)$')
    if at then
      local waited = now - tonumber(at)
      oldest = math.max(oldest, waited)
      table.insert(rows, ('<b>%5s</b>  %s#%s  %s <span fgalpha="60%%">(%s)</span>'):format(
        age(waited), gears.string.xml_escape((repo:gsub('^.*/', ''))), number,
        gears.string.xml_escape(title), gears.string.xml_escape(author)))
    end
  end

  local color = oldest >= alert_after and colors.red.base
      or oldest >= warn_after and colors.yellow.base
      or colors.fg.dim
  paint(color, #rows)
  tooltip.markup = table.concat(rows, '\n')
  widget.visible = #rows > 0
end

-- Ask GitHub (the script then signals reviews::changed, which reloads us)
---@type fun()
local refresh = function() awful.spawn.easy_async({ scripts .. '/review-queue' }, function() end) end
-- Repaint from the cache, without calling GitHub
---@type fun()
local reload = function() awful.spawn.easy_async({ scripts .. '/review-queue', '--cached' }, render) end

-- Clicked refreshes report back, so we know GitHub was actually asked
-- Tell how a clicked refresh went
---@type SpawnCallback
local report = function(out, err, _, code)
  ---@type integer
  local pending = select(2, out:gsub('[^\n]+', ''))
  local naughty = require('naughty')
  if code == 0 then
    naughty.notify({
      app_name = 'reviews',
      title = 'Reviews refreshed',
      text = pending == 0 and 'Nothing waiting on your review'
          or ('%d review%s waiting on you'):format(pending, pending > 1 and 's' or ''),
    })
  else
    naughty.notify({
      app_name = 'reviews',
      preset = naughty.config.presets.critical,
      title = 'Reviews not refreshed',
      text = code == 2 and (err:gsub('^review%-queue: ', ''):gsub('%s+$', ''))
          or ('Could not reach GitHub, showing the last known queue (%d)'):format(pending),
    })
  end
end

---@type fun()
local refresh_and_report = function() awful.spawn.easy_async({ scripts .. '/review-queue' }, report) end

label:buttons(gears.table.join(
  awful.button({}, 1, function() awful.spawn({ scripts .. '/rofi-reviews' }) end),
  awful.button({}, 3, refresh_and_report)
))

awesome.connect_signal('reviews::changed', reload)
gears.timer({ timeout = 300, autostart = true, call_now = true, callback = refresh })
gears.timer({ timeout = 60, autostart = true, callback = reload }) -- keep ages (and colors) current

---@type PanelWidget
return { widget = widget, update = reload }
