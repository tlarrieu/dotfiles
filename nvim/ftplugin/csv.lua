vim.fn['gnuplot#setup']()

vim.keymap.set('n', '<cr>', ':Plot bars<cr>', { silent = true, buffer = true })
vim.keymap.set('n', '<leader><cr>', ':Plot lines<cr>', { silent = true, buffer = true })
