return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  version = '*',
  event = { 'BufReadPre', 'BufNewFile' },
  build = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
  opts = {
    ensure_installed = {
      'bash',
      'fish',
      'go',
      'haskell',
      'javascript',
      'latex',
      'lua',
      'markdown',
      'norg',
      'ocaml',
      'query',
      'ruby',
      'typescript',
    },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
      enable = true,
      select = {
        enable = true,
        lookahead = true,

        keymaps = {
          ['if'] = '@function.inner',
          ['af'] = '@function.outer',
          ['ic'] = '@parameter.inner',
          ['ac'] = '@parameter.outer',
          ['ie'] = '@block.inner',
          ['ae'] = '@block.outer',
          ['id'] = '@conditional.inner',
          ['ad'] = '@conditional.outer',
          ['il'] = '@assignment.lhs',
          ['ir'] = '@assignment.rhs',
        },
      }
    }
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end
}
