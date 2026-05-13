vim.pack.add({ 'https://github.com/dkarter/bullets.vim' }, { confirm = false })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'gitcommit' },
  callback = function()
    local options = { silent = true, buffer = true }
    vim.keymap.set('n', 'o', '<cmd>InsertNewBullet<cr>', options)
    vim.keymap.set('n', '<leader>x', '<cmd>ToggleCheckbox<cr>', options)
  end,
  group = vim.api.nvim_create_augroup('bullets_autocmd', {})
})

vim.g.set_mappings = 0
