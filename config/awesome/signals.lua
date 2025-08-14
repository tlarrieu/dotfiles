local awful = require('awful')
local beautiful = require('beautiful')

local helpers = require('helpers')
local icons = require('icons')
local spawner = require('spawner')

-- [[ Focus ]] -----------------------------------------------------------------

client.connect_signal('focus', function(client) client.border_color = beautiful.border_focus end)
client.connect_signal('unfocus', function(client) client.border_color = beautiful.border_normal end)

client.connect_signal('request::activate', function(client, context)
  local skip = context == 'mouse_click' or
      context == 'ewmh' or
      context == 'autofocus.check_focus'

  if skip then return end

  helpers.center_mouse_in_client(client)
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
  if type(object) == 'client' then
    for _, tag in ipairs(object.screen.tags) do
      update_icon(tag)
    end
  elseif type(object) == 'tag' then
    update_icon(object)
  end
end

local client_signals = {
  'property::name',
  'property::class',
  'property::instance',
  'unmanage',
  'manage',
  'focus'
}

for _, signal in ipairs(client_signals) do
  client.connect_signal(signal, handle)
end

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
    helpers.create_tag_and_attach_to(client)
  elseif action == spawner.actions.JUMP then
    if #client:tags() == 0 then helpers.create_tag_and_attach_to(client) end
    client:jump_to()
  else
    return
  end

  client:emit_signal('request::activate', 'client.focus.bydirection', { raise = true })
end)
