local ansi = require('ansi')
---@type FileHelper
local file = require('file')

local state = require('usr.testbus.state')
local config = require('usr.testbus.config')

-- TODO: add support for multiple buffers
-- Right now we only support the current one, and ignore files not matching
-- the current one.
-- This is fine for now, since we only run tests within a single spec file, but it'd
-- be more robust to be generic.

---@param data string stdout from running job
return function(data)
  if state.is_done() then return false end

  local stdout = table.concat(data)
  if stdout:find('shutting down') then return false, state.stop() end
  if stdout:find('pry') then return false, state.cmdline() end

  local success, json = pcall(function() return vim.json.decode(file.read(config.json_path)) end)

  if not success then return false end

  if json.summary.errors_outside_of_examples_count > 0 then
    state.panic()
  elseif json.summary.failure_count > 0 then
    state.fail(json.summary.failure_count)
  else
    state.succeed()
  end

  local diag = {}
  local outcomes = {}
  local bufnr = vim.g.testbus_bufnr
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  for _, example in ipairs(json.examples) do
    local file_path = example.included_from.file_path or example.file_path
    if bufname:find(vim.fs.normalize(file_path)) then
      local lnum = (example.included_from.line_number or example.line_number) - 1

      outcomes[lnum] = (outcomes[lnum] == nil or outcomes[lnum] == example.status) and example.status or Outcome.MIXED

      if example.status == 'failed' then
        local anchor = lnum
        if not example.included_from.line_number then
          for _, line in ipairs(example.exception.backtrace) do
            local match = line:match(file_path .. ':(%d+)')
            if match then
              anchor = tonumber(match) - 1
              break
            end
          end
        end

        local _, col = vim.api.nvim_buf_get_lines(bufnr, anchor, anchor + 1, true)[1]:find('^%s*')
        table.insert(diag, {
          bufnr = bufnr,
          lnum = anchor,
          col = col,
          severity = vim.diagnostic.severity.ERROR,
          message = ansi.strip(example.exception.message),
          source = 'rspec',
          namespace = state.namespace(),
        })
      end
    end
  end

  return true, { bufnr = bufnr, outcomes = outcomes, diag = diag }
end
