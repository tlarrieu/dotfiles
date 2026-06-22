vim.g.colors_name = 'chromatic'

vim.api.nvim_create_autocmd('Signal', {
  pattern = { 'SIGUSR1' },
  callback = function() vim.cmd.colorscheme('chromatic') end,
  group = vim.api.nvim_create_augroup('refresh_colorscheme', {})
})

vim.cmd.highlight('clear')
vim.o.background = require('mode').current()
local palette = require('colors.palettes').load(vim.o.background)

require('colors.components.base')(palette)
require('colors.components.languages')(palette)
require('colors.components.plugins')(palette)
