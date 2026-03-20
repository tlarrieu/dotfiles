return {
  'brenoprata10/nvim-highlight-colors',
  opts = {
    exclude_filetypes = {
      'lazy',
      'mason',
      'fugitive',
      'NeogitStatus',
      'NeogitLogView',
      'gitcommit',
      'GV',
    },
  },
  config = function(_, opts)
    require('nvim-highlight-colors').setup(opts)
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = require("nvim-highlight-colors").turnOn,
      group = vim.api.nvim_create_augroup('colorizer_group', {})
    })
  end
}
