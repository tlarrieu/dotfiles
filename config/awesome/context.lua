local M = {}

M.path = string.format("%s/.context.env", os.getenv('HOME'))

M.get = function()
  local file, context = io.open(M.path, 'r'), nil

  if file then
    local line = file:read('*l')
    file:close()
    context = line and line:match('CONTEXT="(%a*)"')
  end

  return context or 'home'
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
