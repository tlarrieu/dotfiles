vim.keymap.set('n', '<cr>', [[:call gnuplot#plot(expand('%'), 'bars')<cr>]], { silent = true, buffer = true })
vim.keymap.set('n', '<leader><cr>', [[:call gnuplot#plot(expand('%'), 'lines')<cr>]], { silent = true, buffer = true })
