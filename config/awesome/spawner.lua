local awful = require("awful")

local _M = {}

local find_client = function(props)
  for _, client in ipairs(client.get()) do
    if awful.rules.match(client, props) then
      return client
    end
  end
end

_M.callbacks = {
  move_client = function(client)
    client:tags({ awful.screen.focused().selected_tag })
  end,
  jump_to_client = function(client)
    client:tags()[1]:view_only()
  end
}

_M.spawn = function(cmd, props, callback)
  if callback then
    local client = find_client(props)

    if client then
      callback(client)
      client:emit_signal(
        "request::activate",
        "client.focus.bydirection",
        {raise=true}
      )
      return
    end
  end

  awful.spawn(cmd, props)
end

_M.spawn_or_jump = function(cmd, props)
  _M.spawn(cmd, props, _M.callbacks.jump_to_client)
end

_M.spawn_or_move_client = function(cmd, props)
  _M.spawn(cmd, props, _M.callbacks.move_client)
end

return _M
