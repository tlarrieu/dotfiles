vim.keymap.set('n', '<leader>.', ':lua require("oil").close()<cr>',
  { buffer = true, silent = true, desc = 'Open Oil split' })
vim.keymap.set('n', 'à', ':lua require("oil").close()<cr>',
  { buffer = true, silent = true, desc = 'Open Oil split' })
