local awful = require('awful')

local M = {}

local find_client = function(props)
  for _, client in ipairs(client.get()) do
    if props.any_of then
      for _, rule in ipairs(props.any_of) do
        if awful.rules.match(client, rule) then
          return client
        end
      end
    else
      if awful.rules.match(client, props) then
        return client
      end
    end
  end
end

M.shell = function(command)
  return 'fish -c "' .. command .. '"'
end

M.terminal = function(cmd, opts)
  local options = ''
  if opts then
    for name, value in pairs(opts) do
      options = string.format('%s --%s %s', options, name, value)
    end
  end

  return string.format(
    'kitty --single-instance %s %s',
    options,
    cmd and M.shell(cmd) or ''
  )
end

M.grab_mouse_until_released = function()
  mousegrabber.run(function(_mouse)
    for _, v in pairs(_mouse.buttons) do
      if v then return true end
    end
    return false
  end, 'mouse')
end

M.actions = {
  MOVE = 'MOVE',
  JUMP = 'JUMP_TO',
}

M.soft_kill = function(client) if client.immortal then client:tags({}) else client:kill() end end

M.spawn = function(cmd, props, action)
  if action then
    local _client = find_client(props)

    if _client then
      if _client == client.focus and _client.screen == mouse.screen and _client.immortal then
        M.soft_kill(_client)
      else
        _client:emit_signal('client::custom', action)
      end
      return
    end
  end

  awful.spawn(type(cmd) == 'function' and cmd() or cmd, props, function(client)
    if #client:tags() == 0 then
      local tag = require('helpers').create_tag(client.screen)
      client:tags({ tag })
      client:raise()
      tag:view_only()
    end
  end)
end

local action_for = function(target)
  local t_target = type(target)

  if t_target == 'function' then return target end
  if t_target == 'table' then return function() M.spawn(target.app, target.props, target.signal) end end
  if t_target == 'string' then return function() M.spawn(target) end end

  error('type of "' .. t_target .. '" is not supported. Must be one of function, table or string')
end

M.key = function(mods, key, target) return awful.key(mods, key, action_for(target)) end

M.button = awful.button

return M
