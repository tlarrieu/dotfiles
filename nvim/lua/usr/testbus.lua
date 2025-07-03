local file = require('file')
local json_path = '/tmp/testbus.json'

local adapters = {
  rspec = function(data)
    if vim.g.test_status ~= 'running' then return end

    if table.concat(data):find('shutting down') then
      vim.g.test_status = 'stopped'
      return
    end

    vim.notify(vim.inspect(vim.g.test_status))

    local success, json = pcall(function() return vim.json.decode(file.read(json_path)) end)

    if not success then return end

    if json.summary.errors_outside_of_examples_count > 0 then
      vim.g.test_status = 'panic'
    elseif json.summary.failure_count > 0 then
      vim.g.test_status = 'failure'
      vim.g.test_failures = json.summary.failure_count
    else
      vim.g.test_status = 'success'
    end
  end
}

local handlers = {
  ruby = adapters.rspec
}

local wrap = function(fun)
  return function()
    if vim.g.test_status == 'running' then return end

    file.rm(json_path)
    vim.g.test_status = 'running'
    vim.g.test_failures = nil
    fun()
  end
end

local run = {
  nearest = wrap(vim.cmd.TestNearest),
  file = wrap(vim.cmd.TestFile),
  last = wrap(vim.cmd.TestLast)
}

local config = {
  running = { icon = '󰐌', color = 254 }, -- white
  stopped = { icon = '', color = 136 }, -- yellow
  success = { icon = '󰗠', color = 106 }, -- green
  failure = { icon = '󰅙', color = 167 }, -- red
  panic   = { icon = '󰀨', color = 168 }, -- pink
}

return {
  run = run,
  lualine = {
    function()
      if not vim.g.test_status then return '' end

      return '󰙨 → ' .. (
        vim.g.test_failures
        and require('glyphs').number(vim.g.test_failures)
        or (config[vim.g.test_status] or {}).icon
      )
    end,
    color = function() return { fg = (config[vim.g.test_status] or {}).color } end,
  },
  parse = function(data) handlers.ruby(data) end,
  interrupt = function() if vim.g.test_status == 'running' then vim.g.test_status = 'stopped' end end
}
