return {
  '0xfraso/nvim-listchars',
  event = 'BufEnter',
  opts = {
    save_state = false,
    notifications = true,
    exclude_filetypes = { 'help', 'man', 'codediff-explorer' },
  },
  init = function()
    vim.opt.list = true
    vim.opt.listchars = { tab = '› ', trail = '·', nbsp = '⎵', extends = '»', precedes = '«' }
  end
}
