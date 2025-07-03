local file = require('file')

---- Configuration -------------------------------------------------------------
local config = {
  status = {
    running = { id = 'running', icon = '󰐌', color = 254 }, -- white
    stopped = { id = 'stopped', icon = '', color = 136 }, -- yellow
    success = { id = 'success', icon = '󰗠', color = 106 }, -- green
    failure = { id = 'failure', icon = '󰅙', color = 167 }, -- red
    panic = { id = 'panic', icon = '󰀨', color = 168 }, -- pink
  },
  json_path = '/tmp/testbus.json',
}
--------------------------------------------------------------------------------

---- State management ----------------------------------------------------------
local has_run = function() return vim.g.test_status ~= nil end
local is_running = function() return vim.g.test_status == config.status.running.id end
local is_done = function() return not is_running() end

local start = function()
  if is_running() then return false end
  file.rm(config.json_path)
  vim.g.test_status = config.status.running.id
  vim.g.test_failures = nil
  return true
end
local stop = function() vim.g.test_status = config.status.stopped.id end
local panic = function() vim.g.test_status = config.status.panic.id end
local fail = function(count)
  vim.g.test_status = config.status.failure.id
  vim.g.test_failures = count
end
local succeed = function() vim.g.test_status = config.status.success.id end

local status = function() return vim.g.test_status end
--------------------------------------------------------------------------------

local adapters = {
  rspec = function(data)
    if is_done() then return end

    if table.concat(data):find('shutting down') then return stop() end

    local success, json = pcall(function() return vim.json.decode(file.read(config.json_path)) end)

    if not success then return end

    if json.summary.errors_outside_of_examples_count > 0 then
      panic()
    elseif json.summary.failure_count > 0 then
      fail(json.summary.failure_count)
    else
      succeed()
    end
  end
}

local handlers = {
  ruby = adapters.rspec
}

local wrap = function(fun) return function() return start() and fun() end end
local run = {
  nearest = wrap(vim.cmd.TestNearest),
  file = wrap(vim.cmd.TestFile),
  last = wrap(vim.cmd.TestLast)
}

---- Public interface ----------------------------------------------------------
return {
  run = run,
  lualine = {
    function()
      return has_run() and (
        '󰙨 → ' .. (
          vim.g.test_failures
          and require('glyphs').number(vim.g.test_failures)
          or (config.status[status()] or {}).icon
        )
      ) or ''
    end,
    color = function() return { fg = (config.status[status()] or {}).color } end,
  },
  parse = function(data) handlers.ruby(data) end,
  interrupt = function() if is_running() then stop() end end
}
--------------------------------------------------------------------------------
