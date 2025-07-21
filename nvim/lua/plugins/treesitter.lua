return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
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
        },
        selection_modes = {
          ['@function.outer'] = 'V',
          ['@block.outer'] = 'V',
          ['@conditional.outer'] = 'V',
        },
      }
    }
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)

    -- Fix vim-indentobject keymaps
    vim.keymap.set('s', 'ai', 'ai')
  end
}
