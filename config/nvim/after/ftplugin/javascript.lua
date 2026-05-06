vim.opt_local.spell = true

require('runner').setup({
  main = { args = { cmd = { 'node', vim.fn.expand('%') }, winbar = '󰎙 node %%' }, desc = 'node %' },
})
