local group = vim.api.nvim_create_augroup('LUA_AUTOCMD', {})

vim.keymap.set('n', '<cr>', ':T lua %<cr>', { silent = true, buffer = true })

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { 'config/awesome/**/*.lua', 'config/awesome/*.lua' },
  callback = function()
    vim.keymap.set('n', '<cr>', ':T ~/scripts/awesome-test<cr>', { silent = true, buffer = true })
  end,
  group = group
})
