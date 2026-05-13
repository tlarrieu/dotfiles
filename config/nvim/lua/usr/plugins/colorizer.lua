vim.pack.add({ 'https://github.com/brenoprata10/nvim-highlight-colors' }, { confirm = false })

require('nvim-highlight-colors').setup({
  exclude_filetypes = {
    'mason',
    'NeogitStatus',
    'NeogitLogView',
    'NeogitCommitView',
    'NeogitCommitSelectView',
    'gitcommit',
    'gitsigns-blame',
  },
  render = 'virtual',
  virtual_symbol = '',
})

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = require('nvim-highlight-colors').turnOn,
  group = vim.api.nvim_create_augroup('colorizer_group', {})
})
