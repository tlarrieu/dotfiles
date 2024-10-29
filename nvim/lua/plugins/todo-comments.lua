return {
  'folke/todo-comments.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' },
  },
  keys = {
    {
      '<c-è>',
      ':TodoTelescope keywords=TODO,FIX,FIXME,WARN,PERF<cr>',
      desc = 'Telescope TODO'
    },
  },
  event = { 'BufNew' },
  opts = {
    signs = false,
    sign_priority = 8,
    keywords = {
      FIX = {
        icon = '󰨰 ',
        color = 'error',
        alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = '󰥪 ', color = 'info' },
      HACK = { icon = '󱍔 ', color = 'error' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = '󰅒 ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
      TEST = { icon = '󰙨 ', color = 'test', alt = { 'TESTING' } },
    },
    gui_style = {
      fg = 'NONE',
      bg = 'BOLD',
    },
    merge_keywords = true,
    highlight = {
      multiline = true,
      multiline_pattern = '^.',
      multiline_context = 10,
      before = '',
      keyword = 'bg',
      after = 'fg',
      pattern = [[.*<(KEYWORDS)(\(.*\))?\s*:]],
      comments_only = true,
      max_line_len = 400,
      exclude = {},
    },
    colors = {
      error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
      warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
      info = { 'DiagnosticInfo', '#2563EB' },
      hint = { 'DiagnosticHint', '#10B981' },
      test = { 'Identifier', '#FF00FF' },
      default = { 'Identifier', '#7C3AED' },
    },
    search = {
      command = 'rg',
      args = {
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--iglob=!**/snippets/all.lua',
      },
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    },
  }
}
