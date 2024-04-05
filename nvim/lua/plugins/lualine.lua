return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    extensions = {
      'toggleterm',
      'quickfix',
      'oil',
      'lazy',
      'fugitive',
      'mason',
    },
  },
  config = function(_, opts)
    local lualine = require('lualine')

    lualine.setup(opts)

    local group = vim.api.nvim_create_augroup('lualine_autocmd', {})

    vim.api.nvim_create_autocmd('User', {
      pattern = { 'BackdropVisible' },
      callback = function()
        lualine.hide({ place = {}, unhide = false })
        vim.o.laststatus = 0
      end,
      group = group
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = { 'BackdropHidden' },
      callback = function()
        require('lualine').setup(opts)
        vim.o.laststatus = 3
      end,
      group = group
    })
  end,

}
