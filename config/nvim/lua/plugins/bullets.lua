vim.pack.add({ 'https://github.com/dkarter/bullets.vim' }, { confirm = false })

vim.g.bullets_set_mappings = 0

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'gitcommit' },
  callback = function()
    local options = { silent = true, buffer = true }
    vim.keymap.set('n', 'o', vim.cmd.InsertNewBullet, options)
    vim.keymap.set('i', '<cr>', vim.cmd.InsertNewBullet, options)
    vim.keymap.set('n', '<leader>x', vim.cmd.ToggleCheckbox, options)
    vim.keymap.set('i', '<c-t>', vim.cmd.BulletDemote, options)
    vim.keymap.set('i', '<c-d>', vim.cmd.BulletPromote, options)
    vim.keymap.set('n', '>>', vim.cmd.BulletDemote, options)
    vim.keymap.set('n', '<<', vim.cmd.BulletPromote, options)
    vim.keymap.set('x', '>', vim.cmd.BulletDemote, options)
    vim.keymap.set('x', '<', vim.cmd.BulletPromote, options)
  end,
  group = vim.api.nvim_create_augroup('bullets_autocmd', {})
})
