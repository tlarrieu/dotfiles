return function ()
  local icons = require("icons")
  local screen = require('awful').screen:focused()
  local strlen = function(x)
    return #x:gsub("[\128-\191]", "")
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
      pad(i, 3) .. icons.fetch(client) .. "  " .. client.name
    )
  end

  local path = os.tmpname()
  local file = io.open(path, "w")
  if file then
    file:write(table.concat(lines, "\n"))
    file:close()
  else
    return
  end

  local handle = io.popen("rofi -dmenu -i -p 󰲌 -input " .. path)
  local result
  if handle then
    result = handle:read("*l")
    handle:close()
    if not result then return end
  else
    return
  end

  local s = result:match('^([0-9]+) .*$')
  if not s then return end

  local client = clients[tonumber(s)]
  if #client:tags() == 0 then require('helpers').create_tag_and_attach_to(client, false) end
  client:jump_to()
end