local group = vim.api.nvim_create_augroup("ultisnips_hooks", {})

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*',
  callback = function() vim.fn['skeleton#insert']() end,
  group = group
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'ProjectionistActivate',
  callback = function() vim.fn['skeleton#insert']() end,
  group = group
})
