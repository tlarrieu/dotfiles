vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.conf' },
  callback = function()
    if vim.bo.filetype ~= 'kitty' then return end
    os.execute('pkill --signal USR1 kitty')
  end,
  group = vim.api.nvim_create_augroup('kitty_config_reload', {})
})
