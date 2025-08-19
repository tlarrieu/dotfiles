vim.opt_local.list = false

vim.keymap.set('n', 'ß', '[[', { remap = true, buffer = true, desc = 'Previous hunk' })
vim.keymap.set('n', 'þ', ']]', { remap = true, buffer = true, desc = 'Next hunk' })
