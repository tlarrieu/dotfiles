#!/bin/sh

awesome-client <<-END | sed -zE 's/   string "(.*)"/\1/'
local script_input = "$(echo "$*" | awk -F ' ' '{print $1}')"

local icons = require('icons')
local screen = require('awful').screen:focused()

local strlen = function(x)
  return #x:gsub('[\128-\191]', '')
end

local pad = function(str, len)
  local _str = tostring(str)
  return _str .. string.rep(' ', len - strlen(_str))
end

local clients, lines = {}, {}

for i, client in ipairs(screen.all_clients) do
  table.insert(clients, client)
  table.insert(
    lines,
    pad(i, 4) .. icons.fetch(client) .. ' ' .. pad(client.instance, 15) .. '  ' .. client.name
  )
end

if script_input == '' then
  return table.concat(lines, '\n')
else
  local s = script_input:match('^([0-9]+)$')
  if not s then return end

  local client = clients[tonumber(s)]
  if #client:tags() == 0 then require('helpers').create_tag_and_attach_to(client, false) end
  client:jump_to()
end
END

# vim: ft=lua.sh
