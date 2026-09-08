local state = require('testbus.state')

local M = {}

M.handle = function()
  state.succeed()
  return false, nil
end

M.options = {}

---@type Handler
return M
