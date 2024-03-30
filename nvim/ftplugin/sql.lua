vim.fn['sql#configure']()

vim.keymap.set('n', '<cr>', [[vip:ExecuteSQL<cr>]], { silent = true, buffer = true, remap = true })
vim.keymap.set('v', '<cr>', [[:'<,'>ExecuteSQL<cr>]], { silent = true, buffer = true, remap = true })
vim.keymap.set('n', '<leader><cr>', [[:call sql#identify('<c-r><c-a>')<cr>]], { silent = true, buffer = true, remap = true })
