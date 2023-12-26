vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'cni'
vim.opt_local.expandtab = false

vim.keymap.set('n', '<return>', ":T go run .<cr>", { silent = true, buffer = true })

local group = vim.api.nvim_create_augroup('GO_AUTOCMD', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    require('go.format').goimport()
  end,
  group = group
})
