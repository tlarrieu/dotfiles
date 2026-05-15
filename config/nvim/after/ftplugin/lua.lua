require('runner').setup({
  main = { args = { cmd = { 'lua', vim.fn.expand('%') } } },
  repl = { args = { cmd = 'lua', winbar = ' REPL' }, desc = 'Lua REPL' },
  overrides = {
    {
      patterns = { 'config/awesome/.*.lua' },
      main = { args = { cmd = { 'sh', vim.fn.expand('~/scripts/awesome-test') }, winbar = '  awesome test' }, desc = 'Awesome test' }
    },
  },
})
