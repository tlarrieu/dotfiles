local file = require('file')

---- Configuration -------------------------------------------------------------
local config = {
  status = {
    running = { id = 'running', icon = '󰐌', color = nil }, -- white
    cmdline = { id = 'cmdline', icon = '', color = 'DiagnosticHint' }, -- violet
    stopped = { id = 'stopped', icon = '', color = 'DiagnosticWarn' }, -- yellow
    success = { id = 'success', icon = '󰗠', color = 'DiagnosticOk' }, -- green
    failure = { id = 'failure', icon = '󰅙', color = 'DiagnosticError' }, -- red
    panic = { id = 'panic', icon = '󰀨', color = 'DiagnosticUnnecessary' }, -- pink
  },
  json_path = '/tmp/testbus.json',
}
local namespace = vim.api.nvim_create_namespace('testbus')
--------------------------------------------------------------------------------

---- State management ----------------------------------------------------------
local has_run = function() return vim.g.testbus_status ~= nil end
local is_running = function()
  return vim.g.testbus_status == config.status.running.id
      or vim.g.testbus_status == config.status.cmdline.id
end
local is_done = function() return not is_running() end

local start = function()
  if is_running() then return false end
  file.rm(config.json_path)
  vim.diagnostic.set(namespace, 0, {}, {})
  vim.g.testbus_bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(vim.g.testbus_bufnr, namespace, 0, -1)
  vim.g.testbus_status = config.status.running.id
  vim.g.testbus_failures = nil
  return true
end
local cmdline = function() vim.g.testbus_status = config.status.cmdline.id end
local stop = function() vim.g.testbus_status = config.status.stopped.id end
local panic = function() vim.g.testbus_status = config.status.panic.id end
local fail = function(count)
  vim.g.testbus_status = config.status.failure.id
  vim.g.testbus_failures = count
end
local succeed = function() vim.g.testbus_status = config.status.success.id end

local status = function() return vim.g.testbus_status end
--------------------------------------------------------------------------------

-- TODO: add support for multiple buffers
-- Right now we only support the current one, and ignore files not matching
-- the current one.
-- This is fine for now, since we only run tests within a single spec file, but it'd
-- be more robust to be generic.
local adapters = {
  rspec = function(data)
    if is_done() then return end

    local stdout = table.concat(data)
    if stdout:find('shutting down') then return stop() end
    if stdout:find('pry') then return cmdline() end

    local success, json = pcall(function() return vim.json.decode(file.read(config.json_path)) end)

    if not success then return end

    if json.summary.errors_outside_of_examples_count > 0 then
      panic()
    elseif json.summary.failure_count > 0 then
      fail(json.summary.failure_count)
    else
      succeed()
    end

    local diag = {}
    local bufnr = vim.g.testbus_bufnr
    local bufname = vim.api.nvim_buf_get_name(vim.g.testbus_bufnr)
    for _, example in ipairs(json.examples) do
      local file_path = example.included_from.file_path or example.file_path
      if bufname:find(vim.fs.normalize(file_path)) then
        local outcome = {}
        local lnum = (example.included_from.line_number or example.line_number) - 1
        if example.status == 'passed' then
          outcome = { ' ✔ ', 'DiagnosticPass' }
        else
          outcome = { ' ✘ ', 'DiagnosticFail' }

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
            message = require('ansi').strip(example.exception.message),
            source = 'rspec',
            namespace = namespace,
          })
        end

        local _, col = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, true)[1]:find('^%s*')
        local mark = { id = lnum, virt_text_pos = 'inline', virt_text = { outcome, { ' ', 'Normal' } } }
        vim.api.nvim_buf_set_extmark(bufnr, namespace, lnum, col, mark)
      end
    end
    vim.diagnostic.set(namespace, bufnr, diag, { virtual_lines = true, virtual_text = false, underline = false })
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
          vim.g.testbus_failures
          and require('glyphs').number(vim.g.testbus_failures)
          or (config.status[status()] or {}).icon
        )
      ) or ''
    end,
    color = function() return (config.status[status()] or {}).color end,
  },
  parse = function(data) handlers.ruby(data) end,
  interrupt = function() if is_running() then stop() end end
}
--------------------------------------------------------------------------------
