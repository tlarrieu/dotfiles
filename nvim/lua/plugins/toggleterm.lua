return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = 'TermExec',
  opts = {
    direction = 'float', -- 'vertical' | 'horizontal' | 'tab' | 'float',
    size = function(term)
      local factor = 0.3
      if term.direction == 'horizontal' then
        return math.max(30, vim.o.lines * factor)
      elseif term.direction == 'vertical' then
        return math.max(80, vim.o.columns * factor)
      end
    end,
    open_mapping = '<leader><tab>',
    hide_numbers = true,
    on_stdout = function(_, _, data)
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
    end,
    on_exit = function()
      if vim.g.test_status == 'running' then vim.g.test_status = 'stopped' end
    end,
    shade_terminals = false,
    start_in_insert = false,
    insert_mappings = false,
    terminal_mappings = false,
    persist_size = false,
    persist_mode = true,
    close_on_exit = false,
    shell = vim.o.shell,
    auto_scroll = false,
    float_opts = {
      border = 'single',   -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
      winblend = 0,
      title_pos = 'center' -- 'left' | 'center' | 'right'
    },
    highlights = {
      NormalFloat = { link = 'NormalFloat' },
      FloatBorder = { link = 'TelescopeBorder' },
    },
  },
  config = true,
  keys = {
    {
      '<cr>',
      function()
        require('toggleterm').send_lines_to_terminal('visual_lines', true, { args = 2 })
      end,
      mode = 'x',
      desc = 'Send to terminal'
    }
  },
}
