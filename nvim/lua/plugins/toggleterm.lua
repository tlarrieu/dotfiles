return {
  'akinsho/toggleterm.nvim',
  dependencies = { 'tlarrieu/testbus' },
  version = '*',
  cmd = { 'TermExec', 'TermOpen' },
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
    on_stdout = function(_, _, data) require('testbus').redraw(data) end,
    on_exit = require('testbus').interrupt,
    shade_terminals = false,
    start_in_insert = false,
    insert_mappings = false,
    terminal_mappings = false,
    persist_size = false,
    persist_mode = true,
    close_on_exit = false,
    shell = '/usr/bin/fish',
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
    { '<leader><tab>', function() require('toggleterm').toggle() end, desc = 'Send to terminal' },
    {
      '<cr>',
      function()
        require('toggleterm').send_lines_to_terminal('visual_lines', true, { args = 2 })
      end,
      mode = 'x',
      desc = 'Send to terminal'
    },
  },
}
