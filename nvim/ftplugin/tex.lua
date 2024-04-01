require('utils').autocapitalize({ '*.tex', '*.latex' })

vim.keymap.set('n', '<cr>', ':T xelatex % -o output.pdf<cr>', { silent = true, buffer = true })
