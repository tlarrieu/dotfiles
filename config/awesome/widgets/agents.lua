-- Agents (fed by ~/scripts/agent-state hooks)
-- Panel widget, see panel.lua: returns { widget, update }

local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local GLib = require('lgi').GLib

---@alias AgentState 'running'|'monitoring'|'done'|'idle'|'attention'
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

-- Projects' short names: the second word of ~/.config/agents/projects'
-- lines, when any (as ~/scripts/rofi-github reads them). Read on each
-- rebuild, so that an edit shows on the next one
---@return table<string, string>
local short_names = function()
  local names = {}
  local file = io.open((os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME') .. '/.config') .. '/agents/projects')
  if not file then return names end
  for line in file:lines() do
    local long, short = line:match('^%s*([^#%s]%S*)%s+(%S+)')
    if long then names[long] = short end
  end
  file:close()
  return names
end

-- A project's name as shown: its short name, an agent worktree's
-- (<project>-<slot>) its project's short one then the slot, else as it is
---@param names table<string, string> See short_names
---@param project string
---@return string
local short_name = function(names, project)
  if names[project] then return names[project] end
  local base, slot = project:match('^(.+)%-(%d+)$')
  if base and names[base] then return names[base] .. '-' .. slot end
  return project
end

-- Turn duration, compact enough for the panel: 42s, 4m, 1h05
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

-- Running agents pulse between blue and grey, eased with a cosine; monitoring
-- ones (their turn over, on a Monitor or a background shell) between teal
-- and grey
---@type number
local period = 1.2  -- seconds for a full grey → color → grey cycle
---@type Timer
local blink = gears.timer({ timeout = 1 / 20 })
---@type table<Paint, string>
local blinking = {} -- paint functions of the pulsing agents, each to its color's name

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
---@param name string The color pulsed towards, in beautiful.colors
---@return string color #rrggbb
local pulse = function(name)
  local colors = beautiful.colors
  local seconds = GLib.get_monotonic_time() / 1e6
  local ratio = (1 - math.cos(2 * math.pi * seconds / period)) / 2
  return mix(colors.fg.dim, colors[name].base, ratio)
end

-- The states pulsing, each towards its color
---@type table<AgentState, string>
local pulsing = { running = 'blue', monitoring = 'cyan' }

blink:connect_signal('timeout', function()
  for paint, name in pairs(blinking) do paint(pulse(name)) end
end)

-- Rebuild the entries from agent-list, and (un)schedule polling/blinking
---@type SpawnCallback
local rebuild = function(out)
  local colors = beautiful.colors
  ---@type table<AgentState, string>
  local palette = {
    running = pulse(pulsing.running),
    monitoring = pulse(pulsing.monitoring),
    done = colors.green.base,
    idle = colors.fg.dim,
    attention = colors.yellow.base,
  }
  -- (mirrors faces in ~/scripts/lib/agents.sh)
  local faces = { running = '󱚣', monitoring = '󱚣', done = '󱜙', idle = '󱜙', attention = '󱚟', fallback = '󰚩' }
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
  local names = short_names()

  for _, agent in ipairs(shown) do
    local state, since, project = agent.state, agent.since, agent.project
    ---@cast state AgentState

    local face = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
    local label = wibox.widget({ valign = 'center', widget = wibox.widget.textbox })
    local glyph = faces[state] or faces.fallback
    -- Under its short name (see short_name). On a pull request: its number,
    -- the project without the worktree's slot (jeancaisse-11 → jc #182343),
    -- telling agents apart
    local number = (agent.pr or '-'):match('#(%d+)$')
    local name = gears.string.xml_escape(number and ('%s #%s'):format(short_name(names, (project:gsub('%-%d+$', ''))), number)
      or short_name(names, project))

    ---@type integer?
    local started = tonumber(since) -- nil when not running (-)

    ---@type Paint
    local paint = function(color)
      -- Mono variant keeps the glyph within a single cell
      face.markup = ('<span font="%s 20" color="%s">%s</span>'):format(beautiful.icon_font, color, glyph)
      local text = name
      if pulsing[state] and started then
        text = ('%s <span fgalpha="60%%">%s</span>'):format(name, elapsed(started))
      end
      label.markup = ('<span color="%s">%s</span>'):format(color, text)
    end

    paint(palette[state] or colors.fg.dimmer)
    if pulsing[state] then blinking[paint] = pulsing[state] end

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

  if next(blinking) and not blink.started then
    blink:start()
  elseif not next(blinking) and blink.started then
    blink:stop()
  end
end

---@type fun()
local update = function() awful.spawn.easy_async({ scripts .. '/agent-list' }, rebuild) end

poll:connect_signal('timeout', update)

awesome.connect_signal('agents::update', update)
gears.timer({ timeout = 30, autostart = true, callback = update }) -- catch crashed sessions

---@type PanelWidget
return { widget = widget, update = update }
