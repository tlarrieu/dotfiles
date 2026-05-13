vim.keymap.set('n', '<c-l>', '<cmd>YAMLTelescope<cr>', { desc = 'Telescope YAML', silent = true, buffer = true })
vim.keymap.set('n', 'yk', '<cmd>YAMLYankKey<cr>', { buffer = true })
vim.keymap.set('n', 'yv', '<cmd>YAMLYankValue<cr>', { buffer = true })
