local file = require('file')
local config = require('usr.testbus.config')

---@class State
---@field namespace function
---@field has_run function
---@field is_done function
---@field start function
---@field cmdline function
---@field stop function
---@field panic function
---@field fail function
---@field succeed function
---@field current function
local _M = {}

_M.namespace = function() return vim.api.nvim_create_namespace('testbus') end

_M.has_run = function() return vim.g.testbus_status ~= nil end
_M.is_running = function()
  return vim.g.testbus_status == config.status.running.id
      or vim.g.testbus_status == config.status.cmdline.id
end
_M.is_done = function() return not _M.is_running() end

_M.start = function()
  if _M.is_running() then return false end
  file.rm(config.json_path)
  vim.diagnostic.set(_M.namespace(), 0, {}, {})
  vim.g.testbus_bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(vim.g.testbus_bufnr, _M.namespace(), 0, -1)
  vim.g.testbus_status = config.status.running.id
  vim.g.testbus_failures = nil
  return true
end
_M.cmdline = function() vim.g.testbus_status = config.status.cmdline.id end
_M.stop = function() vim.g.testbus_status = config.status.stopped.id end
_M.panic = function() vim.g.testbus_status = config.status.panic.id end
_M.fail = function(count)
  vim.g.testbus_status = config.status.failure.id
  vim.g.testbus_failures = count
end
_M.succeed = function() vim.g.testbus_status = config.status.success.id end

_M.current = function() return vim.g.testbus_status end
_M.error_count = function() return vim.g.testbus_failures or 0 end

return _M
