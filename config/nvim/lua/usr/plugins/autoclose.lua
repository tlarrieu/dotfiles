vim.pack.add({ 'https://github.com/m4xshen/autoclose.nvim' }, { confirm = false })

require('autoclose').setup({
  keys = {
    ['$'] = { escape = true, close = true, pair = '$$', enabled_filetypes = { 'tex' } },
    ['<'] = { escape = true, close = true, pair = '<>', enabled_filetypes = { 'html', 'embedded_template', 'xml' } },
  },
  options = {
    disabled_filetypes = { 'TelescopePrompt', 'ledger', 'gitcommit' },
    disable_when_touch = true,
    touch_regex = "[%w(%[{%%'\"]",
    disable_command_mode = true,
  },
})
