vim.pack.add({ 'https://github.com/andrewradev/linediff.vim' }, { confirm = false })

vim.keymap.set('x', '<leader>d', ':Linediff<cr>', { silent = true })
