vim.keymap.set('n', '<c-l>', '<cmd>YAMLTelescope<cr>', { desc = 'Telescope YAML', silent = true, buffer = true })
vim.keymap.set('n', '<leader>yk', '<cmd>YAMLYankKey<cr>', { silent = true, buffer = true })
vim.keymap.set('n', '<leader>yv', '<cmd>YAMLYankValue<cr>', { silent = true, buffer = true })
