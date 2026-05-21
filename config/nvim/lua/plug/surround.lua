vim.pack.add({ 'https://github.com/tpope/vim-surround' }, { confirm = false })

vim.g.surround_no_insert_mappings = 1
vim.keymap.set({ 'n', 'o' }, 'S', 'ys', { remap = true, silent = true })
vim.keymap.set({ 'x' }, 'S', '<Plug>VSurround', { remap = true, silent = true })
