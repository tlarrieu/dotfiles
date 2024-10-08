local _M = {}

_M.path = string.format("%s/.context.env", os.getenv('HOME'))

_M.get = function()
  local file = io.open(_M.path, 'r')
  if file then
    local context = file:read('*l'):match('CONTEXT="(%a*)"')
    file:close()
    return context
  end

  return 'home'
end

_M.set = function(context)
  local file = io.open(_M.path, 'w+')
  if file then
    file:write('CONTEXT="' .. context .. '"')
    file:close()

    require('panel').reset()
  end
end

_M.toggle = function() _M.set(_M.get() == 'home' and 'work' or 'home') end

return _M
