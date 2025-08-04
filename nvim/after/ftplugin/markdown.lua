local o = vim.opt_local

o.formatoptions = o.formatoptions + 't'
o.foldlevel = 10
o.foldlevelstart = 10
o.spell = vim.bo.buftype ~= 'nofile'
o.shiftwidth = 2

local runner = require('runner')
runner.default({ main = runner.term("mdprev w '%'") })

vim.keymap.set('v', '<leader>b', 'S*gvS*eee', { buffer = true, remap = true })
vim.keymap.set('v', '<leader>i', 'S_ee', { buffer = true, remap = true })
vim.keymap.set('v', '<leader>s', 'S~gvS~eee', { buffer = true, remap = true })
vim.keymap.set('n', '<leader>i', '<cmd>Markview toggle<cr>', { buffer = true, remap = true })

require('utils').autocapitalize('*.md')
