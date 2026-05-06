require('runner').setup({
  main = { args = { cmd = { 'sh', vim.fn.expand('%') }, winbar = '󱆃 sh %%' }, desc = 'sh %' },
})
