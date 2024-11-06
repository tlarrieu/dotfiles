vim.opt_local.commentstring = '# %s'

-- NOTE: temporary files from `edit_command_buffer`
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '/tmp/tmp.*.fish',
  callback = function() vim.cmd.quit() end,
  group = vim.api.nvim_create_augroup('fish_autocmd', {})

})
