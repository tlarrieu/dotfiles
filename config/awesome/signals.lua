local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')

local helpers = require('helpers')
local icons = require('icons')
local spawner = require('spawner')

-- [[ Focus ]] -----------------------------------------------------------------

client.connect_signal('focus', function(client)
  client.border_color = beautiful.border_focus
  -- Never leave the focused client behind another one (e.g. floating ones after a restart)
  client:raise()
end)
client.connect_signal('unfocus', function(client) client.border_color = beautiful.border_normal end)

client.connect_signal('request::activate', function(client, context)
  local skip = context == 'mouse_click' or
      context == 'ewmh' or
      context == 'autofocus.check_focus'

  if skip then return end

  helpers.center_mouse_in_client(client)
end)

-- Background Claude agents (see rules.lua) ask to be activated once mapped.
-- We deny it, yet kitty flags them as focused, which leaves the focused kitty
-- window with an unfocused cursor: bouncing the focus sends it a fresh focus event.
-- Focus may still be in flux at that point (e.g. no client focused while the rofi
-- that spawned the agent closes), so we bounce once it settled.
client.connect_signal('request::activate', function(c, context)
  if context ~= 'ewmh' or c.instance ~= 'claude-agent' or #c:tags() > 0 then return end

  gears.timer.start_new(0.05, function()
    local focused = client.focus or awful.client.focus.history.get(awful.screen.focused(), 0)
    if not (focused and focused.valid) then return end

    client.focus = nil
    gears.timer.start_new(0.05, function()
      if focused.valid and not client.focus then client.focus = focused end
    end)
  end)
end)

-- [[ Dynamic tag names ]] -----------------------------------------------------

local update_icon = function(tag)
  local xs = {}
  for _, client in ipairs(tag:clients()) do xs[icons.fetch(client)] = true end

  local ys = {}
  for k in pairs(xs) do table.insert(ys, k) end

  tag.name = require('glyphs').number(tag.index) .. ' ' .. table.concat(ys, ' ') .. ' '
end

local handle = function(object)
  if type(object) == 'tag' then return update_icon(object) end
  if type(object) == 'client' then for _, tag in ipairs(object.screen.tags) do update_icon(tag) end end
end

local client_signals = {
  'property::name',
  'property::class',
  'property::instance',
  'unmanage',
  'manage',
  'focus'
}

for _, signal in ipairs(client_signals) do client.connect_signal(signal, handle) end

client.connect_signal('property::minimized', function(client)
  if client.name == 'meet.google.com is sharing a window.' then return end
  client.minimized = false
end)

awful.screen.connect_for_each_screen(function(screen)
  for _, signal in ipairs({ 'tagged', 'untagged' }) do
    awful.tag.attached_connect_signal(screen, signal, handle)
  end
  awful.tag.attached_connect_signal(screen, 'property::urgent', function(tag)
    tag:view_only()
  end)

  require('panel').init(screen)
end)

client.connect_signal('client::custom', function(client, action)
  if action == spawner.actions.MOVE then
    client:move_to_screen(mouse.screen)
    if client.floating then helpers.resize_and_center(client) end
    if #client:tags() == 0 or client.screen ~= mouse.screen then
      helpers.create_tag_and_attach_to(client)
    else
      local tag = mouse.screen.selected_tag or helpers.create_tag(mouse.screen)
      client:tags({ tag })
    end
  elseif action == spawner.actions.JUMP then
    if #client:tags() == 0 or client.screen ~= mouse.screen then
      helpers.create_tag_and_attach_to(client)
    end
  else
    return
  end

  client:jump_to()
  client:emit_signal('request::activate')
end)
