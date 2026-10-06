local ansi = require('testbus.ansi')

---@class Location
---@field path string
---@field lnum integer 0-indexed

---@class LoadError
---@field message string
---@field locations table<Location> first line mentioned in the backtrace, for each file

---@class ExampleResult
---@field path string file holding the example, or including it for shared examples
---@field lnum integer 0-indexed
---@field status string passed, failed or pending
---@field finding Finding? failure or pending reason

---@class RspecParser
---@field breakpoint fun(stdout: string): Location?
---@field load_error fun(message: string): LoadError?
---@field example fun(example: table): ExampleResult
local _M = {}

---@return string # message stripped of the noisy object descriptions
local simplify = function(str)
  return (str:gsub(' for class .*$', ''):gsub(' for #<RSpec::.*$', ''))
end

---@param stdout string
---@return Location? # where pry stopped the execution
_M.breakpoint = function(stdout)
  local path, lnum = ansi.strip(stdout):match('From: (.*):(%d+).*:')
  if not (path and lnum) then return nil end
  return { path = vim.fs.normalize(path), lnum = tonumber(lnum) - 1 }
end

--- Parse an error raised outside of examples (e.g. while loading a spec file):
---
---   NameError:
---     undefined local variable or method `foo' for class X
---   # ./spec/some_spec.rb:12:in `<top (required)>'
---
---@param message string
---@return LoadError?
_M.load_error = function(message)
  local name, details
  local locations, seen = {}, {}

  for line in ansi.strip(message):gmatch('[^\n]+') do
    if name and not details then details = simplify(line):match('%s*(.*)') end -- details follow the error name
    name = name or line:match('.*[^/]Error:')                                   -- skips the `Failure/Error: …` line

    local path, lnum = line:match('# ./(.*):(%d+)')
    if path and not seen[path] then
      seen[path] = true
      if details then table.insert(locations, { path = path, lnum = tonumber(lnum) - 1 }) end
    end
  end

  if not details then return nil end
  return { message = name .. ' ' .. details, locations = locations }
end

--- Shared examples are reported on the line including them, since that is the one belonging to the spec file
---@param example table example from the JSON formatter
---@return ExampleResult
_M.example = function(example)
  local included = example.included_from
  local path = included.file_path or example.file_path
  local lnum = (included.line_number or example.line_number) - 1
  local result = { path = path, lnum = lnum, status = example.status }

  if example.status == 'failed' then
    local anchor = lnum
    if not included.line_number then
      -- point at the deepest line of the spec file in the backtrace (usually the failing expectation)
      for _, line in ipairs(example.exception.backtrace) do
        local match = line:match(vim.pesc(path) .. ':(%d+)')
        if match then anchor = tonumber(match) - 1 end
      end
    end
    result.finding = {
      lnum = anchor,
      message = simplify(ansi.strip(example.exception.message)),
      severity = vim.diagnostic.severity.ERROR,
    }
  elseif example.status == 'pending' then
    result.finding = {
      lnum = lnum,
      message = simplify(ansi.strip(example.pending_message)),
      severity = vim.diagnostic.severity.INFO,
    }
  end

  return result
end

return _M
