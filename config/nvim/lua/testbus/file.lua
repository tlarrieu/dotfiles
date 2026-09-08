---@class FileHelper
---@field read function
---@field rm function
local _M = {}

_M.read = function(path)
  local file = io.open(path, 'r')
  if not file then return end
  local content = file:read('*a')
  file:close()
  return content
end

_M.rm = function(path) os.remove(path) end

return _M
