local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local icons = require("icons")

client.connect_signal("focus", function(client)
  client.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(client)
  client.border_color = beautiful.border_normal
end)

client.connect_signal("request::activate", function(client, context)
  local skip = context == "mouse_click" or
    context == "ewmh" or
    context == "autofocus.check_focus"

  if skip then return end

  helpers.center_mouse_in_client(client)
end)

-- [[ Dynamic tag names ]] -----------------------------------------------------

local client_signals = {
  "property::name",
  "property::class",
  "property::instance",
  "unmanage",
  "manage",
  "focus"
}
local tag_signals = { "tagged", "untagged" }

local update_icon = function(tag)
  local xs = {}
  for _, client in ipairs(tag:clients()) do xs[icons.fetch(client)] = true end

  local name = ''
  for k, v in pairs(xs) do name = name .. " " .. k end
  tag.name = name
end

local handle = function(object)
  local tag

  if type(object) == 'client' then
    tag = object.first_tag
  elseif type(object) == 'tag' then
    tag = object
  else
    return
  end

  update_icon(tag)
end

for _, signal in ipairs(client_signals) do
  client.connect_signal(signal, handle)
end

client.connect_signal("property::minimized", function(client)
  if client.name == "meet.google.com is sharing a window." then
    return
  end

  client.minimized = false
end)

awful.screen.connect_for_each_screen(function(screen)
  for _, signal in ipairs(tag_signals) do
    awful.tag.attached_connect_signal(screen, signal, handle)
  end
end)
