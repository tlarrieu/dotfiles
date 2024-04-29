local _M = {}

local PATH = string.format("%s/.context.env", os.getenv('HOME'))

_M.get = function()
  local file = io.open(PATH, 'r')
  if file then
    local context = file:read('*l'):match('CONTEXT="(%a*)"')
    file:close()
    return context
  end

  return 'home'
end

_M.set = function(context)
  local file = io.open(PATH, 'w+')
  if file then
    file:write('CONTEXT="'.. context .. '"')
    file:close()
    _M.notify()
  end
end

_M.notify = function()
  io.popen([[notify-send Context "']] .. _M.get() .. [['"]])
end

_M.toggle = function()
  local context = _M.get()
  if context == 'home' then
    _M.set('work')
  else
    _M.set('home')
  end
end

return _M
