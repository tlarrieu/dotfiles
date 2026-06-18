vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { 'COMMIT_EDITMSG', 'MERGE_MSG' },
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if first_line == '' then
      vim.cmd.normal('gg')
      vim.cmd.startinsert({ bang = true })
    end
  end,
  group = vim.api.nvim_create_augroup('GIT_AUTOCMD', {})
})

vim.keymap.set('n', 's', function() vim.cmd('silent x') end, { silent = true, buffer = 0 })
vim.keymap.set({ 'n', 'i' }, '<c-c>', function()
  vim.cmd.normal({ 'ggdG', mods = { silent = true } })
  vim.cmd.x({ mods = { silent = true } })
end, { silent = true, buffer = 0 })

vim.opt_local.spell = true
