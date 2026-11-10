-- Claude agents (fed by ~/scripts/claude-agent-state hooks)
-- Panel widget, see panel.lua: returns { widget, update }

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local GLib = require('lgi').GLib

---@alias AgentState 'running'|'done'|'idle'|'attention'
---@alias Paint fun(color: string) Repaint an agent entry in the given color

---@type Widget
local list = wibox.widget({ spacing = 16, layout = wibox.layout.fixed.horizontal })
-- Trailing separator lives here so it hides along with the agents
---@type Widget
local separator = wibox.widget({ widget = wibox.widget.textbox })
---@type Widget
local widget = wibox.widget({
  list,
  { separator, left = 10, right = 10, layout = wibox.container.margin },
  visible = false,
  layout = wibox.layout.fixed.horizontal,
})

local scripts = os.getenv('HOME') .. '/scripts'

-- Turn duration, compact enough for the panel: 42s, 4m, 1h05 (mirrors elapsed
-- in ~/scripts/lib/claude-agents.sh)
---@param since integer When the turn started (epoch seconds)
---@return string
local elapsed = function(since)
  local seconds = math.max(0, os.time() - since)
  if seconds < 60 then return seconds .. 's' end
  if seconds < 3600 then return math.floor(seconds / 60) .. 'm' end
  return ('%dh%02d'):format(math.floor(seconds / 3600), math.floor(seconds % 3600 / 60))
end

-- Poll while an agent is not idle, since neither interrupts nor kitty tab
-- switches signal us
---@type Timer
local poll = gears.timer({ timeout = 3 })

-- Running agents pulse between blue and grey, eased with a cosine
---@type number
local period = 1.2  -- seconds for a full grey → blue → grey cycle
---@type Timer
local blink = gears.timer({ timeout = 1 / 20 })
---@type Paint[]
local blinking = {} -- paint functions of the running agents

-- Blend two colors
---@param from string #rrggbb
---@param to string #rrggbb
---@param ratio number 0 (from) → 1 (to)
---@return string color #rrggbb
local mix = function(from, to, ratio)
  ---@param i integer Offset of the channel's hex pair in the color string
  ---@return integer
  local channel = function(i)
    local a, b = tonumber(from:sub(i, i + 1), 16), tonumber(to:sub(i, i + 1), 16)
    return math.floor(a + (b - a) * ratio + 0.5)
  end
  return ('#%02x%02x%02x'):format(channel(2), channel(4), channel(6))
end

-- Phase follows the monotonic clock, so rebuilding the widgets doesn't reset it
---@return string color #rrggbb
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

-- Rebuild the entries from claude-agent-list, and (un)schedule polling/blinking
---@type SpawnCallback
local rebuild = function(out)
  local colors = beautiful.colors
  ---@type table<AgentState, string>
  local palette = {
    running = pulse(),
    done = colors.green.base,
    idle = colors.fg.dim,
    attention = colors.yellow.base,
  }
  -- (mirrors faces in ~/scripts/lib/claude-agents.sh)
  local faces = { running = '󱚣', done = '󱜙', idle = '󱜙', attention = '󱚟', fallback = '󰚩' }
  ---@type Widget[]
  local entries = {}
  blinking = {}

  -- Idle agents stay out: nothing to tell (rofi-github lists them all)
  ---@type table[]
  local shown = {}
  for _, agent in ipairs(require('records').parse(out)) do
    if agent.state ~= 'idle' then table.insert(shown, agent) end
  end
  -- Something to follow: poll
  local busy = #shown > 0

  for _, agent in ipairs(shown) do
    local state, since, project = agent.state, agent.since, agent.project
    ---@cast state AgentState

    local face = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
    local label = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
    local glyph = faces[state] or faces.fallback
    local name = gears.string.xml_escape(project)

    ---@type integer?
    local started = tonumber(since) -- nil when not running (-)

    ---@type Paint
    local paint = function(color)
      -- Mono variant keeps the glyph within a single cell
      face.markup = ('<span font="%s 20" color="%s">%s</span>'):format(beautiful.icon_font, color, glyph)
      local text = name
      if state == 'running' and started then
        text = ('%s <span fgalpha="60%%">%s</span>'):format(name, elapsed(started))
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
end

---@type fun()
local update = function() awful.spawn.easy_async({ scripts .. '/claude-agent-list' }, rebuild) end

poll:connect_signal('timeout', update)

awesome.connect_signal('claude::update', update)
gears.timer({ timeout = 30, autostart = true, callback = update }) -- catch crashed sessions

---@type PanelWidget
return { widget = widget, update = update }
