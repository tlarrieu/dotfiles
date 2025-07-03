local adapters = {
  rspec = function(data)
    local msg = table.concat(data)

    if not vim.g.test_status == 'running' then return end

    if msg:find('shutting down') then
      vim.g.test_status = 'stopped'
    elseif msg:find('errors? occurred outside') then
      vim.g.test_status = 'panic'
    elseif msg:find('0 failures') then
      vim.g.test_status = 'success'
    elseif msg:find('%d failures?') then
      local match = msg:match('(%d) failures?')
      vim.g.test_status = 'failure'
      vim.g.test_failures = tonumber(match)
    end
  end
}

local handlers = {
  ruby = adapters.rspec
}

local wrap = function(fun)
  return function()
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
  running = { icon = '󰐌', color = nil }, -- no color
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
  parse = function(stdout) handlers.ruby(stdout) end,
  interrupt = function()
    if vim.g.test_status ~= 'running' then return end

    vim.g.test_status = 'stopped'
  end
}
