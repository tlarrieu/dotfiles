return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    direction = 'vertical', -- 'vertical' | 'horizontal' | 'tab' | 'float',
    size = function(term)
      local factor = 0.3
      if term.direction == 'horizontal' then
        return vim.o.lines * factor
      elseif term.direction == 'vertical' then
        return vim.o.columns * factor
      end
    end,
    open_mapping = '<leader><tab>',
    hide_numbers = true,
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
      winblend = 3,
      title_pos = 'center' -- 'left' | 'center' | 'right'
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    vim.g['test#strategy'] = 'toggleterm'

    vim.keymap.set('x', '<cr>', function()
      require('toggleterm').send_lines_to_terminal('visual_lines', true, { args = 2 })
    end)
  end,
}
