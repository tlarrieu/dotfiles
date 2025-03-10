#!/bin/sh

awesome-client <<-END | sed -zE 's/   string "(.*)"/\1/'
local script_input = "$(echo "$*" | awk -F ' ' '{print $1}')"

local icons = require('icons')

local strlen = function(x)
  return #x:gsub('[\128-\191]', '')
end

local fit = function(str, len)
  local _str = tostring(str):sub(1, len)
  return _str .. string.rep(' ', len - strlen(_str))
end

local clients, lines = {}, {}

local i = 0
for s in screen do
  for _, client in ipairs(s.all_clients) do
    i = i + 1
    table.insert(clients, client)
    table.insert(
      lines,
      fit(i, 3) .. ' ' .. icons.fetch(client) .. '  ' .. fit(client.pid, 6) .. ' ' .. fit(client.instance, 15) .. '  ' .. client.name
    )
  end
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
