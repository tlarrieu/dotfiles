vim.pack.add({ 'https://github.com/pabloariasal/webify.nvim' }, { confirm = false })

vim.keymap.set('n', 'yg', '<cmd>YankLineUrl +<cr>', { silent = true, desc = 'Git(Hub) yank line URL' })
vim.keymap.set('n', 'yG', '<cmd>YankFileUrl +<cr>', { silent = true, desc = 'Git(Hub) yank file URL' })
