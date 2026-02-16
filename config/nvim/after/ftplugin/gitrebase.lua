local group = vim.api.nvim_create_augroup('GITREBASE_AUTOCMD', {})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*' },
  command = 'quit',
  group = group
})
