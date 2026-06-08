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
  exclude_buffer = function(buf)
    -- somehow, it does not get excluded by exclude_filetypes, so we need to exclude it by buffer name
    return vim.api.nvim_buf_get_name(buf):match('nvim%-pack')
  end,
  render = 'virtual',
  virtual_symbol = '',
})
