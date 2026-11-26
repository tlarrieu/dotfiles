vim.pack.add({ 'https://github.com/sontungexpt/stcursorword' }, { confirm = false })

require('stcursorword').setup({
  max_word_length = 100,
  min_word_length = 2,
  excluded = {
    filetypes = { "TelescopePrompt" },
    buftypes = { "terminal", },
    patterns = {},
  },
  highlight = { link = 'Cursorword' },
})

vim.keymap.set('n', ' ', '<cmd>Cursorword toggle<cr>', { desc = 'Toggle cursorword', silent = true })

vim.cmd.Cursorword('disable')
