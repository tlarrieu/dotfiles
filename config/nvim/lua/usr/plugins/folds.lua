vim.pack.add({ 'https://github.com/bbjornstad/pretty-fold.nvim' }, { confirm = false })

local opts = {
  sections = {
    left = { 'content' },
    right = {
      ' ',
      'number_of_folded_lines',
      ' ',
      '󰁂',
      ' ',
      function(config) return config.fill_char:rep(4) end,
    }
  },
  fill_char = '-',
  ft_ignore = {},
}

require('pretty-fold').setup(opts)

vim.opt.foldcolumn = '0'
vim.opt.foldclose = ''
vim.opt.fillchars:append('fold:' .. opts.fill_char)
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldnestmax = 3
vim.opt.foldlevelstart = 10
vim.opt.foldminlines = 2
