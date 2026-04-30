return {
  'm4xshen/autoclose.nvim',
  config = {
    keys = {
      ['$'] = { escape = true, close = true, pair = '$$', enabled_filetypes = { 'tex' } },
      ['<'] = { escape = true, close = true, pair = '<>', enabled_filetypes = { 'html', 'embedded_template', 'xml' } },
    },
    options = {
      disabled_filetypes = { 'TelescopePrompt' },
      disable_when_touch = true,
      disable_command_mode = true,
    },
  },
}
