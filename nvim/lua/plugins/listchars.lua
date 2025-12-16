return {
  '0xfraso/nvim-listchars',
  event = 'BufEnter',
  opts = {
    save_state = false,
    notifications = true,
    exclude_filetypes = { 'help', 'man' },
  },
  config = function(_, opts)
    vim.opt.list = true
    vim.opt.listchars = { tab = '› ', trail = '·', nbsp = '⎵', extends = '»', precedes = '«' }
    require('nvim-listchars').setup(opts)
  end
}
