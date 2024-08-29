vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'cni'
vim.opt_local.expandtab = false

local runner = require('runner')

runner.default({
  main = runner.exec('GoRun'),
  alt = runner.exec('GoTest'),
})

local group = vim.api.nvim_create_augroup('GO_AUTOCMD', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function() require('go.format').goimport() end,
  group = group
})
