local adapters = {
  rspec = function(data)
    local started = false
    local success = false
    local failure = false
    local stopped = false
    local progress

    for _, line in ipairs(data) do
      local match = line:match("%d+/%d+")
      if match then progress = match end

      if line:find('rspec') then started = true end
      if line:find('shutting down') then stopped = true end
      if not stopped then
        if line:find('0 failures') then
          success = true
        elseif line:find('failure') then
          failure = true
        end
      end
    end

    if not success and not failure and not stopped then
      vim.g.test_progress = progress
    end

    if success then
      vim.g.test_status = 'success'
    elseif failure then
      vim.g.test_status = 'failure'
    elseif started then
      vim.g.test_status = 'running'
    elseif stopped then
      vim.g.test_status = 'stopped'
    end
  end
}

local handlers = {
  ruby = adapters.rspec
}

return {
  lualine = {
    function()
      local icons = { running = '󰐌', stopped = '', success = '󰗠', failure = '󰅙' }

      local icon = icons[vim.g.test_status]

      if not icon then return '' end

      local progress = ''
      if vim.g.test_progress then progress = ' (' .. vim.g.test_progress .. ')' end

      return '󰙨 → ' .. icon .. progress
    end,
    color = function()
      if not vim.g.test_status then return {} end
      if vim.g.test_status == 'running' then return {} end
      if vim.g.test_status == 'stopped' then return { fg = 136 } end -- red
      if vim.g.test_status == 'success' then return { fg = 106 } end -- green
      if vim.g.test_status == 'failure' then return { fg = 167 } end -- yellow
    end,
  },
  parse = function(stdout) handlers.ruby(stdout) end,
  interrupt = function()
    if vim.g.test_status ~= 'running' then return end

    vim.g.test_status = 'stopped'
  end
}
