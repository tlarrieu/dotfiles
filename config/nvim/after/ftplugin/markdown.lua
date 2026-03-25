vim.opt_local.formatoptions:append('t')
vim.opt_local.foldlevel = 10
vim.opt_local.foldlevelstart = 10
vim.opt_local.spell = vim.bo.buftype ~= 'nofile'
vim.opt_local.shiftwidth = 2

vim.keymap.set('v', '<leader>b', 'S*gvS*eee', { buffer = true, remap = true })
vim.keymap.set('v', '<leader>i', 'S_ee', { buffer = true, remap = true })
vim.keymap.set('v', '<leader>s', 'S~gvS~eee', { buffer = true, remap = true })

require('utils').autocapitalize('*.md')
