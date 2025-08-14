local restore_win_separator = function()
  vim.api.nvim_set_hl(0, 'WinSeparator', { link = '_WinSeparator' })
end

local save_win_separator = function()
  local saved = vim.api.nvim_get_hl(0, {})['_WinSeparator']
  if not saved then
    vim.api.nvim_set_hl(0, '_WinSeparator', vim.api.nvim_get_hl(0, {})['WinSeparator'])
  end
end

return {
  'akinsho/toggleterm.nvim',
  dependencies = { 'tlarrieu/testbus' },
  version = '*',
  cmd = { 'TermExec', 'TermOpen', 'ToggleTerm' },
  opts = {
    direction = 'float',
    size = function(term)
      local factor = 0.3
      if term.direction == 'horizontal' then
        return math.max(10, vim.o.lines * factor)
      elseif term.direction == 'vertical' then
        return math.max(80, vim.o.columns * factor)
      end
    end,
    open_mapping = '<c-s>',
    hide_numbers = true,
    on_open = function(term)
      save_win_separator()
      if term.direction == 'vertical' or term.direction == 'horizontal' then
        vim.api.nvim_set_hl(0, 'WinSeparator', { link = 'FloatBorder' })
      end
    end,
    on_close = restore_win_separator,
    on_stdout = function(_, _, data) require('testbus').redraw(data) end,
    on_exit = function()
      restore_win_separator()
      require('testbus').interrupt()
    end,
    shade_terminals = false,
    start_in_insert = true,
    insert_mappings = false,
    terminal_mappings = false,
    persist_size = false,
    persist_mode = true,
    close_on_exit = false,
    shell = '/usr/bin/fish',
    auto_scroll = false,
    float_opts = {
      border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      winblend = 5,
      title_pos = 'center',
    },
    highlights = {
      Normal = { link = 'NormalFloat' },
      NormalFloat = { link = 'NormalFloat' },
      WinSeparator = { link = 'FloatBorder' },
      FloatBorder = { link = 'FloatBorder' },
    },
  },
  config = true,
  keys = {
    {
      '<c-s>',
      function() require('toggleterm').toggle() end,
      desc = 'Toggle terminal',
      mode = { 'n', 'i', 't' }
    },
    {
      '<cr>',
      function() require('toggleterm').send_lines_to_terminal('visual_lines', true, { args = 2 }) end,
      mode = 'x',
      desc = 'Send to terminal'
    },
  },
}
