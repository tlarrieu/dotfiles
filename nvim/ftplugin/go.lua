vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'cni'
vim.opt_local.expandtab = false

vim.keymap.set('n', '<return>', ":GoRun<cr>", { silent = true, buffer = true })
vim.keymap.set('n', '<leader><return>', ":T go run .<cr>:Topen<cr>", { silent = true, buffer = true })

local group = vim.api.nvim_create_augroup('GO_AUTOCMD', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    require('go.format').goimport()
  end,
  group = group
})
