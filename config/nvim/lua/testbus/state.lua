local file = require('testbus.file')

---@class State
---@field namespace fun()
---@field has_run fun(): boolean
---@field is_done fun(): boolean
---@field start fun(fun: fun(), path: string) notify start
---@field cmdline fun() notify interactive mode
---@field stop fun() notify normal end
---@field panic fun() notify panic
---@field fail fun(count: integer) notify failure (with error count)
---@field succeed fun() notify success
---@field current fun(): string get current state status
---@field handler fun(): Handler
local M = {}

---@enum Status
Status = {
  RUNNING = 'running',
  CMDLINE = 'cmdline',
  STOPPED = 'stopped',
  SUCCESS = 'success',
  FAILURE = 'failure',
  PANIC = 'panic',
}

M.namespace = function() return vim.api.nvim_create_namespace('testbus') end

M.has_run = function() return vim.g.testbus_status ~= nil end
M.is_running = function()
  return vim.g.testbus_status == Status.RUNNING
      or vim.g.testbus_status == Status.CMDLINE
end
M.is_awaiting = function()
  return vim.g.testbus_status == Status.CMDLINE
end
M.is_done = function() return not M.is_running() end

local set_adapter = function()
  if vim.bo.filetype == 'ruby' then
    vim.g.testbus_adapter = 'rspec'
  else
    vim.g.testbus_adapter = 'default'
  end
end

---@param fun fun() the function starting the test, it should write to a file and to STDOUT
---@param path string the path to the output json
M.start = function(fun, path)
  if M.is_running() then return end
  file.rm(path)
  set_adapter()
  M.clear()
  vim.g.testbus_status = Status.RUNNING
  vim.g.testbus_failures = nil
  if fun then fun() end
end
M.clear = function()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    vim.diagnostic.set(M.namespace(), bufnr, {}, {})
    vim.api.nvim_buf_clear_namespace(bufnr, M.namespace(), 0, -1)
  end
end
M.cmdline = function() vim.g.testbus_status = Status.CMDLINE end
M.stop = function() vim.g.testbus_status = Status.STOPPED end
M.panic = function() vim.g.testbus_status = Status.PANIC end
M.fail = function(count)
  vim.g.testbus_status = Status.FAILURE
  vim.g.testbus_failures = count
end
M.succeed = function() vim.g.testbus_status = Status.SUCCESS end

M.current = function() return vim.g.testbus_status end
M.error_count = function() return vim.g.testbus_failures or 0 end

M.handler = function()
  return require('testbus.adapters')[vim.g.testbus_adapter]
end

return M
