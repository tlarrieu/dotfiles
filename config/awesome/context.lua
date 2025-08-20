local M = {}

M.path = string.format("%s/.context.env", os.getenv('HOME'))

M.get = function()
  local file = io.open(M.path, 'r')
  if file then
    local context = file:read('*l'):match('CONTEXT="(%a*)"')
    file:close()
    return context
  end

  return 'home'
end

M.set = function(context)
  local file = io.open(M.path, 'w+')
  if file then
    file:write('CONTEXT="' .. context .. '"')
    file:close()

    require('panel').reset()
  end
end

M.toggle = function() M.set(M.get() == 'home' and 'work' or 'home') end

return M
