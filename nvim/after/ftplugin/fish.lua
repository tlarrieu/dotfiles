-- NOTE: temporary files from `edit_command_buffer`
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '/tmp/tmp.*.fish' },
  callback = function()
    vim.keymap.set({ 'n', 'i', 'x' }, '<c-s>', '<esc>:x<cr>')
  end,
  group = vim.api.nvim_create_augroup('fish_autocmd', {})
})
