vim.pack.add({ 'https://github.com/0xfraso/nvim-listchars' }, { confirm = false })

require('nvim-listchars').setup({
  save_state = false,
  notifications = true,
  exclude_filetypes = { 'help', 'man', 'codediff-explorer' },
})

vim.opt.list = true
vim.opt.listchars = { tab = '› ', trail = '·', nbsp = '⎵', extends = '»', precedes = '«' }
