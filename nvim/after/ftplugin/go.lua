vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'cni'
vim.opt_local.expandtab = false
vim.opt_local.spell = true

local runner = require('runner')
runner.default({
  main = runner.term('go run .'),
})

require('utils').autoformat('*.go')
