require('backdrop'):show()

vim.api.nvim_create_autocmd('BufLeave', {
  buffer = vim.api.nvim_get_current_buf(),
  callback = function()
    require('backdrop'):hide()
  end,
  group = vim.api.nvim_create_augroup('harpoon_backdrop_autocmd', {})
})
