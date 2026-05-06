vim.bo.softtabstop = 4
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

require('runner').setup({
  main = { args = { cmd = { 'python', vim.fn.expand('%') }, winbar = ' python %%' }, desc = 'python %' }
})
