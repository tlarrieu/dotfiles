require('utils').autoformat()
require('runner').setup({
  main = { args = { cmd = { 'psql', '-f', vim.fn.expand('%') }, winbar = ' psql -f %%' }, desc = 'psql -f %' },
})
