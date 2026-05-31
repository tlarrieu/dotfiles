-- do not set any keymaps
vim.g.no_plugin_maps = true

vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'cni'
vim.opt_local.expandtab = false
vim.opt_local.spell = true

require('runner').setup({
  main = { args = { cmd = { 'go', 'run', '.' }, winbar = '󰟓 go run .' }, desc = 'go run .' },
})
