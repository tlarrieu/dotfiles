vim.opt_local.textwidth = 1000

local group = vim.api.nvim_create_augroup('TASKEDIT_AUTOCMD', {})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*' },
  command = 'quit',
  group = group
})
