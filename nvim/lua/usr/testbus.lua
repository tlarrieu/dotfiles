local file = require('file')

---- Configuration -------------------------------------------------------------
local config = {
  status = {
    running = { id = 'running', icon = '󰐌', color = 254 }, -- white
    cmdline = { id = 'cmdline', icon = '', color = 68 }, -- violet
    stopped = { id = 'stopped', icon = '', color = 136 }, -- yellow
    success = { id = 'success', icon = '󰗠', color = 106 }, -- green
    failure = { id = 'failure', icon = '󰅙', color = 167 }, -- red
    panic = { id = 'panic', icon = '󰀨', color = 168 }, -- pink
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
-- Right now we only support the current one, and we expect all examples in result
-- file to be matching the current one.
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
      if bufname:find(vim.fs.normalize(example.file_path)) then
        local mark = {}
        local lnum = example.line_number - 1
        if example.status == 'passed' then
          mark = { '󰸞 ', '@comment' }
        else
          mark = { '󰆤 ', 'DiagnosticError' }

          local anchor = lnum
          for _, line in ipairs(example.exception.backtrace) do
            local match = line:match(example.file_path .. ':(%d+)')
            if match then
              anchor = tonumber(match) - 1
              break
            end
          end
          -- TODO: make the diag target only the written portion of the line,
          -- excluding preceding whitespaces
          table.insert(diag, {
            bufnr = bufnr,
            lnum = anchor,
            col = 0,
            severity = vim.diagnostic.severity.ERROR,
            message = require('ansi').strip(example.exception.message),
            source = 'rspec',
            namespace = namespace,
          })
        end
        vim.api.nvim_buf_set_extmark(bufnr, namespace, lnum, 0, { id = lnum, virt_text = { mark } })
      end
    end
    vim.diagnostic.set(namespace, bufnr, diag, {})
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
    color = function() return { fg = (config.status[status()] or {}).color } end,
  },
  parse = function(data) handlers.ruby(data) end,
  interrupt = function() if is_running() then stop() end end
}
--------------------------------------------------------------------------------
