local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local GLib = require('lgi').GLib
local glyphs = require('glyphs')
local context = require('context')

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

-- [[ Claude agents (fed by ~/scripts/claude-agent-state hooks) ]] -------------

local agents = (function()
  local list = wibox.widget({ spacing = 16, layout = wibox.layout.fixed.horizontal })
  -- Trailing separator lives here so it hides along with the agents
  local separator = wibox.widget({ widget = wibox.widget.textbox })
  local widget = wibox.widget({
    list,
    { separator, left = 10, right = 10, layout = wibox.container.margin },
    visible = false,
    layout = wibox.layout.fixed.horizontal,
  })

  local scripts = os.getenv('HOME') .. '/scripts'

  -- Turn duration, compact enough for the panel: 42s, 4m, 1h05
  local elapsed = function(since)
    local seconds = math.max(0, os.time() - since)
    if seconds < 60 then return seconds .. 's' end
    if seconds < 3600 then return math.floor(seconds / 60) .. 'm' end
    return ('%dh%02d'):format(math.floor(seconds / 3600), math.floor(seconds % 3600 / 60))
  end

  -- Poll while an agent is not idle, since neither interrupts nor kitty tab
  -- switches signal us
  local poll = gears.timer({ timeout = 3 })

  -- Running agents pulse between blue and grey, eased with a cosine
  local period = 1.2  -- seconds for a full grey → blue → grey cycle
  local blink = gears.timer({ timeout = 1 / 20 })
  local blinking = {} -- paint functions of the running agents

  local mix = function(from, to, ratio)
    local channel = function(i)
      local a, b = tonumber(from:sub(i, i + 1), 16), tonumber(to:sub(i, i + 1), 16)
      return math.floor(a + (b - a) * ratio + 0.5)
    end
    return ('#%02x%02x%02x'):format(channel(2), channel(4), channel(6))
  end

  -- Phase follows the monotonic clock, so rebuilding the widgets doesn't reset it
  local pulse = function()
    local colors = beautiful.colors
    local seconds = GLib.get_monotonic_time() / 1e6
    local ratio = (1 - math.cos(2 * math.pi * seconds / period)) / 2
    return mix(colors.fg.dim, colors.blue.base, ratio)
  end

  blink:connect_signal('timeout', function()
    local color = pulse()
    for _, paint in ipairs(blinking) do paint(color) end
  end)

  local update = function()
    awful.spawn.easy_async({ scripts .. '/claude-agent-list' }, function(out)
      local colors = beautiful.colors
      local palette = {
        running = pulse(),
        done = colors.green.base,
        idle = colors.fg.dim,
        attention = colors.yellow.base,
      }
      local faces = { running = '󱚣', done = '󱜙', idle = '󱜙', attention = '󱚟', fallback = '󰚩' }
      local entries = {}
      local busy = false
      blinking = {}

      for state, since, _, project in out:gmatch('%d+ (%S+) (%S+) (%S+) (%S+)') do
        busy = busy or state ~= 'idle'

        local face = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
        local label = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
        local glyph = faces[state] or faces.fallback
        local name = gears.string.xml_escape(project)

        since = tonumber(since)

        local paint = function(color)
          -- Mono variant keeps the glyph within a single cell
          face.markup = ('<span font="CaskaydiaCove Nerd Font Mono 20" color="%s">%s</span>'):format(color, glyph)
          local text = name
          if state == 'running' and since then
            text = ('%s <span fgalpha="60%%">%s</span>'):format(name, elapsed(since))
          end
          label.markup = ('<span color="%s">%s</span>'):format(color, text)
        end

        paint(palette[state] or colors.fg.dimmer)
        if state == 'running' then table.insert(blinking, paint) end

        table.insert(entries, wibox.widget({ face, label, spacing = 6, layout = wibox.layout.fixed.horizontal }))
      end

      widget.visible = #entries > 0
      list:set_children(entries)
      separator.markup = ('<span color="%s">•</span>'):format(colors.fg.dimmer)

      if busy and not poll.started then
        poll:start()
      elseif not busy and poll.started then
        poll:stop()
      end

      if #blinking > 0 and not blink.started then
        blink:start()
      elseif #blinking == 0 and blink.started then
        blink:stop()
      end
    end)
  end

  poll:connect_signal('timeout', update)

  awesome.connect_signal('claude::update', update)
  gears.timer({ timeout = 30, autostart = true, callback = update }) -- catch crashed sessions

  return { widget = widget, update = update }
end)()

-- [[ Reviews (pull requests waiting on me, see ~/scripts/review-queue) ]] -----

local reviews = (function()
  local scripts = os.getenv('HOME') .. '/scripts'
  local warn_after, alert_after = 4 * 3600, 24 * 3600

  local icon = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
  local count = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
  local label = wibox.widget({ icon, count, spacing = 6, layout = wibox.layout.fixed.horizontal })
  local paint = function(color, text)
    icon.markup = ('<span font="CaskaydiaCove Nerd Font Mono 16" color="%s"></span>'):format(color)
    count.markup = ('<span color="%s">%s</span>'):format(color, text)
  end
  local separator = wibox.widget({ widget = wibox.widget.textbox })
  local widget = wibox.widget({
    label,
    { separator, left = 10, right = 10, layout = wibox.container.margin },
    visible = false,
    layout = wibox.layout.fixed.horizontal,
  })
  local tooltip = awful.tooltip({ objects = { label }, mode = 'outside', preferred_alignments = { 'middle' } })

  local age = function(seconds)
    if seconds < 3600 then return math.floor(seconds / 60) .. 'm' end
    if seconds < 86400 then return math.floor(seconds / 3600) .. 'h' end
    return ('%dd%dh'):format(math.floor(seconds / 86400), math.floor(seconds % 86400 / 3600))
  end

  -- Queue lines: <requested at> <repo> <number> <author> <+> <-> <url> <title>
  local render = function(out, err, _, code)
    local colors = beautiful.colors
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

  local refresh = function() awful.spawn.easy_async({ scripts .. '/review-queue' }, function() end) end
  local reload = function() awful.spawn.easy_async({ scripts .. '/review-queue', '--cached' }, render) end

  -- Clicked refreshes report back, so we know GitHub was actually asked
  local refresh_and_report = function()
    awful.spawn.easy_async({ scripts .. '/review-queue' }, function(out, err, _, code)
      local count = select(2, out:gsub('[^\n]+', ''))
      local naughty = require('naughty')
      if code == 0 then
        naughty.notify({
          app_name = 'reviews',
          title = 'Reviews refreshed',
          text = count == 0 and 'Nothing waiting on your review'
              or ('%d review%s waiting on you'):format(count, count > 1 and 's' or ''),
        })
      else
        naughty.notify({
          app_name = 'reviews',
          preset = naughty.config.presets.critical,
          title = 'Reviews not refreshed',
          text = code == 2 and (err:gsub('^review%-queue: ', ''):gsub('%s+$', ''))
              or ('Could not reach GitHub, showing the last known queue (%d)'):format(count),
        })
      end
    end)
  end

  label:buttons(gears.table.join(
    awful.button({}, 1, function() awful.spawn({ scripts .. '/rofi-reviews' }) end),
    awful.button({}, 3, refresh_and_report)
  ))

  awesome.connect_signal('reviews::changed', reload)
  gears.timer({ timeout = 300, autostart = true, call_now = true, callback = refresh })
  gears.timer({ timeout = 60, autostart = true, callback = reload }) -- keep ages (and colors) current

  return { widget = widget, update = reload }
end)()

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
