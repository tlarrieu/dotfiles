local awful = require("awful")

local _M = {}

local find_client = function(props)
  for _, client in ipairs(client.get()) do
    if awful.rules.match(client, props) then
      return client
    end
  end
end

_M.shell = function(command)
  return "fish -c '" .. command .. "'"
end

_M.termstart = function(cmd, opts)
  local options = ""
  if opts then
    for name, value in pairs(opts) do
      options = string.format("%s --%s %s", options, name, value)
    end
  end

  return _M.shell(string.format(
    "kitty --single-instance %s %s",
    options,
    cmd
  ))
end

_M.grab_mouse_until_released = function()
  mousegrabber.run(function(_mouse)
    for _, v in pairs(_mouse.buttons) do
      if v then return true end
    end
    return false
  end, "mouse")
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

_M.key = function(mods, key, target)
  if type(target) == 'function' then
    return awful.key(
      mods,
      key,
      target
    )
  elseif type(target) == 'table' then
    return awful.key(
      mods,
      key,
      function() _M.spawn(target.app, target.props, target.callback) end
    )
  elseif type(target) == 'string' then
    return awful.key(
      mods,
      key,
      function() _M.spawn(target) end
    )
  else
    error(
      "type of '"
      .. target
      .. "' is not supported. Must be one of function, table or string"
    )
  end
end

_M.button = awful.button

return _M
