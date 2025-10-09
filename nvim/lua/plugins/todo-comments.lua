return {
  'folke/todo-comments.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' },
  },
  keys = {
    {
      '<c-s-è>',
      ':TodoTelescope keywords=TODO,FIX,FIXME,WARN,PERF<cr>',
      desc = 'Telescope TODO',
      silent = true,
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
      TODO = { icon = ' ' },
      HACK = { icon = '󱍔 ' },
      WARN = { icon = ' ', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = '󰅒 ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = '󰋽 ', alt = { 'INFO' } },
      TEST = { icon = '󰙨 ', alt = { 'TESTING' } },
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
