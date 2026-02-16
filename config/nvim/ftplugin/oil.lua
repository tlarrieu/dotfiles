vim.keymap.set('n', '<leader>.', function() require('oil').close() end,
  { buffer = true, silent = true, desc = 'Close Oil split' })
vim.keymap.set('n', 'à', function() require('oil').close() end,
  { buffer = true, silent = true, desc = 'Close Oil split' })
