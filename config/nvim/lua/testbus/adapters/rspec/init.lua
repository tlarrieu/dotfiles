local ansi = require('testbus.ansi')
local file = require('testbus.file')
local state = require('testbus.state')

local M = {}

-- TODO: add support for multiple buffers
-- Right now we only support the current one, and ignore files not matching
-- the current one.
-- This is fine for now, since we only run tests within a single spec file, but it'd
-- be more robust to be generic.

local create_diagnostic = function(bufnr, lnum, message, severity)
  vim.fn.bufload(bufnr) -- ensure the buffer is loaded so next line actual returns something
  local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, lnum, lnum + 1, true)

  if not ok then lines = { '' } end

  local _, col = (lines[1] or ''):find('^%s*')
  return {
    bufnr = bufnr,
    lnum = lnum,
    col = col or 0,
    severity = severity or vim.diagnostic.severity.ERROR,
    message = message,
    source = 'rspec',
    namespace = state.namespace(),
  }
end

---@param path string path relative to the working directory
---@param create boolean whether to add the buffer when none exists for this path
---@return integer?
local find_buffer = function(path, create)
  local fullpath = vim.fn.fnamemodify(path, ':p')
  if not create and vim.fn.bufexists(fullpath) == 0 then return nil end
  local bufnr = vim.fn.bufadd(fullpath)
  if create then vim.bo[bufnr].buflisted = true end
  return bufnr
end

local simplify_message = function(str)
  return str
      :gsub(' for class .*$', '')
      :gsub(' for #<RSpec::.*$', '')
end

---@param data table<string> stdout from running job
---@param path string path to the JSON file holding the test results
---@return boolean, Reports?
M.handle = function(data, path)
  if state.is_done() then return false, nil end

  local stdout = table.concat(data)
  if stdout:find('shutting down') then return false, state.stop() end
  if stdout:find('pry') then
    local filename, linenr = ansi.strip(stdout):match("From: (.*):(%d+).*:")
    if filename and linenr then
      local bufnr = vim.fn.bufnr(vim.fs.normalize(filename), true)
      if bufnr and bufnr ~= -1 then
        state.cmdline()
        return true, {
          [bufnr] = {
            outcomes = {},
            diag = { create_diagnostic(bufnr, tonumber(linenr) - 1, ' Execution has stopped here', vim.diagnostic.severity.WARN) },
          }
        }
      end
    end

    return false, state.cmdline()
  end

  local success, json = pcall(function() return vim.json.decode(file.read(path)) end)

  if not success then return false, nil end

  if json.summary.errors_outside_of_examples_count > 0 then
    state.panic()
  elseif json.summary.failure_count > 0 then
    state.fail(json.summary.failure_count)
  else
    state.succeed()
  end

  local reports = {}
  local report_for = function(bufnr)
    reports[bufnr] = reports[bufnr] or { outcomes = {}, diag = {} }
    return reports[bufnr]
  end

  local buffers = {}
  local buffer_for = function(path, create)
    if buffers[path] == nil then
      buffers[path] = find_buffer(path, create) or false
    end
    return buffers[path] or nil
  end

  for _, message in ipairs(json.messages or {}) do
    local error, errname
    local anchored = {}
    for line in ansi.strip(message):gmatch('[^\n]+') do
      if errname and not error then                     -- the error is located right after the error name
        error = simplify_message(line):match('%s*(.*)') -- strip leading blank spaces
      end

      local _errname = line:match('.*[^/]Error:') -- we don't want to match the `Failure/Error: …` line
      if _errname and not errname then errname = _errname end

      -- anchor the diagnostic to the first line number mentioned for each file
      local errpath, lnum = line:match('# ./(.*):(%d+)')
      if errpath and lnum and not anchored[errpath] then
        anchored[errpath] = true
        local bufnr = buffer_for(errpath, false)
        if bufnr and error then
          table.insert(
            report_for(bufnr).diag,
            create_diagnostic(bufnr, tonumber(lnum) - 1, errname .. ' ' .. error, vim.diagnostic.severity.ERROR)
          )
        end
      end
    end
  end

  for _, example in ipairs(json.examples) do
    local file_path = example.included_from.file_path or example.file_path
    local bufnr = buffer_for(file_path, true)
    local report = report_for(bufnr)
    local lnum = (example.included_from.line_number or example.line_number) - 1

    report.outcomes[lnum] = (report.outcomes[lnum] == nil or report.outcomes[lnum] == example.status)
        and example.status
        or Outcome.MIXED

    if example.status == 'failed' then
      local anchor = lnum
      if not example.included_from.line_number then
        for _, line in ipairs(example.exception.backtrace) do
          local match = line:match(vim.pesc(file_path) .. ':(%d+)')
          if match then
            anchor = tonumber(match) - 1
          end
        end
      end

      local message = simplify_message(ansi.strip(example.exception.message))
      table.insert(report.diag, create_diagnostic(bufnr, anchor, message, vim.diagnostic.severity.ERROR))
    elseif example.status == 'pending' then
      table.insert(report.diag,
        create_diagnostic(
          bufnr,
          lnum,
          simplify_message(ansi.strip(example.pending_message)),
          vim.diagnostic.severity.INFO
        ))
    end
  end

  return true, reports
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
