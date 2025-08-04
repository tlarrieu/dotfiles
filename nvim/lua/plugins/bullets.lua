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
        vim.keymap.set('i', '<cr>', '<esc><cmd>InsertNewBullet<cr>', options)
        vim.keymap.set('i', '<C-cr>', '<cr>', options)
        vim.keymap.set('n', 'o', '<cmd>InsertNewBullet<cr>', options)
        vim.keymap.set('n', '<leader>x', '<cmd>ToggleCheckbox<cr>', options)
      end,
      group = group
    })

    vim.g.set_mappings = 0
  end
}
