vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'cni'
vim.opt_local.expandtab = false
vim.opt_local.spell = true

local runner = require('runner')

runner.default({
  main = runner.term('go run .'),
  alt = runner.test.last(),
})

runner.match({ '*_test.go' }, {
  main = runner.test.nearest(),
  alt = runner.test.file()
})

require('utils').autoimport('*.go')
require('utils').autoformat('*.go')
