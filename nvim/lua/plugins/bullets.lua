return {
  'dkarter/bullets.vim',
  ft = {
    'markdown',
    'gitcommit',
  },
  config = function(ctx)
    local group = vim.api.nvim_create_augroup('bullets_autocmd', {})

    vim.api.nvim_create_autocmd('FileType', {
      pattern = ctx.ft,
      callback = function()
        local options = { silent = true, buffer = true }
        vim.keymap.set('n', '<cr>', '<esc>:InsertNewBullet<cr>', options)
        vim.keymap.set('i', '<cr>', '<esc>:InsertNewBullet<cr>', options)
        vim.keymap.set('i', '<C-cr>', '<cr>', options)
        vim.keymap.set('n', 'o', ':InsertNewBullet<cr>', options)
        vim.keymap.set('v', 'gn', ':RenumberSelection<cr>', options)
        vim.keymap.set('n', '<leader>x', ':ToggleCheckbox<cr>', options)
        vim.keymap.set('o', 'it', ':SelectBulletText<cr>', options)
        vim.keymap.set('o', 'at', ':SelectBullet<cr>', options)
      end,
      group = group
    })
  end
}
