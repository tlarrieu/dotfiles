vim.pack.add({ 'https://github.com/brenoprata10/nvim-highlight-colors' }, { confirm = false })

require('nvim-highlight-colors').setup({
  exclude_filetypes = {
    'mason',
    'gitcommit',
    'gitsigns-blame',
    'fugitive',
    'floggraph',
    'git',
    'markdown',
  },
  exclude_buffer = function(buf)
    return vim.api.nvim_buf_get_name(buf):match('nvim%-pack') or
        vim.api.nvim_buf_get_name(buf):match('consistency_checks')
  end,
  render = 'virtual',
  virtual_symbol = '',
})
