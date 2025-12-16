return {
  'sontungexpt/stcursorword',
  opts = {
    max_word_length = 100,
    min_word_length = 2,
    excluded = {
      filetypes = { "TelescopePrompt" },
      buftypes = { "terminal", },
      patterns = {},
    },
    highlight = { link = 'Cursorword' },
  },
  keys = {
    { '<c-space>', '<cmd>Cursorword toggle<cr>' },
  },
  config = function(_, opts)
    require('stcursorword').setup(opts)
    vim.cmd.Cursorword('disable')
  end
}
