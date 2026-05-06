require('runner').setup({
  main = { args = { cmd = { 'lua', vim.fn.expand('%') } } },
  overrides = {
    {
      patterns = { 'config/awesome/.*.*/.*.lua', 'config/awesome/.*.lua' },
      main = { args = { cmd = { 'sh', vim.fn.expand('~/scripts/awesome-test') }, winbar = '  awesome test' }, desc = 'Awesome test' }
    },
  },
})

require('utils').autoformat('*.lua')
