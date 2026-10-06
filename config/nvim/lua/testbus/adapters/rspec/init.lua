local file = require('testbus.file')
local state = require('testbus.state')
local ReportsBuilder = require('testbus.reports')
local parser = require('testbus.adapters.rspec.parser')

local M = {}

---@param stdout string
---@return boolean, Reports?
local on_breakpoint = function(stdout)
  state.cmdline()

  local location = parser.breakpoint(stdout)
  if not location then return false, nil end

  local builder = ReportsBuilder.new('rspec')
  builder:diagnostic(location.path, {
    lnum = location.lnum,
    message = ' Execution has stopped here',
    severity = vim.diagnostic.severity.WARN,
  }, true)
  return true, builder.reports
end

local update_status = function(summary)
  if summary.errors_outside_of_examples_count > 0 then
    state.panic()
  elseif summary.failure_count > 0 then
    state.fail(summary.failure_count)
  else
    state.succeed()
  end
end

---@return Reports
local collect = function(json)
  local builder = ReportsBuilder.new('rspec')

  for _, message in ipairs(json.messages or {}) do
    local load_error = parser.load_error(message)
    if load_error then
      for _, location in ipairs(load_error.locations) do
        builder:diagnostic(location.path, {
          lnum = location.lnum,
          message = load_error.message,
          severity = vim.diagnostic.severity.ERROR,
        }, false)
      end
    end
  end

  for _, example in ipairs(json.examples) do
    local result = parser.example(example)
    builder:outcome(result.path, result.lnum, result.status)
    if result.finding then builder:diagnostic(result.path, result.finding, true) end
  end

  return builder.reports
end

---@param data table<string> stdout from running job
---@param path string path to the JSON file holding the test results
---@return boolean, Reports?
M.handle = function(data, path)
  if state.is_done() then return false, nil end

  local stdout = table.concat(data)
  if stdout:find('shutting down') then
    state.stop()
    return false, nil
  end
  if stdout:find('pry') then return on_breakpoint(stdout) end

  local success, json = pcall(function() return vim.json.decode(file.read(path)) end)
  if not success then return false, nil end -- the JSON is only written once the run is over

  update_status(json.summary)
  return true, collect(json)
end

local curpath = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or "./"

M.options = {
  '--require',
  curpath .. 'json_formatter.rb',
  '--format=JsonFormatter',
  '--out=/tmp/testbus.json',
  '--format=progress'
}

---@type Handler
return M
