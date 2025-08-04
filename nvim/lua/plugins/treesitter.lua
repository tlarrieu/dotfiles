return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  priority = 100,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
    'OXY2DEV/markview.nvim'
  },
  version = '*',
  build = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
  event = { 'BufRead' },
  opts = {
    ensure_installed = {
      'bash',
      'fish',
      'gitcommit',
      'go',
      'gomod',
      'haskell',
      'javascript',
      'latex',
      'lua',
      'luadoc',
      'markdown',
      'norg',
      'ocaml',
      'query',
      'ruby',
      'tsx',
      'typescript',
      'ledger',
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'make' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = " ",
        node_incremental = " ",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    context = {
      enable = true,
      max_lines = 5,
      multiwindow = true,
      mode = 'cursor',
      separator = '-',
    },
    textobjects = {
      enable = true,

      select = {
        enable = true,
        lookahead = true,

        keymaps = {
          ['if'] = '@function.inner',
          ['af'] = '@function.outer',
          ['ia'] = '@parameter.inner',
          ['aa'] = '@parameter.outer',
          ['ie'] = '@block.inner',
          ['ae'] = '@block.outer',
          ['ic'] = '@conditional.inner',
          ['ac'] = '@conditional.outer',
          ['iC'] = '@class.inner',
          ['aC'] = '@class.outer',
          ['il'] = '@assignment.lhs',
          ['ir'] = '@assignment.rhs',
        },
        selection_modes = {
          ['@function.outer'] = 'V',
          ['@block.outer'] = 'V',
          ['@conditional.outer'] = 'V',
        },
      },

      lsp_interop = {
        enable = true,
        border = 'none',
        floating_preview_opts = {},
        peek_definition_code = {
          ['go'] = '@function.outer',
        },
      },
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
    require('treesitter-context').setup(opts['context'])
  end,
}
