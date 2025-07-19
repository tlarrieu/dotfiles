return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'austintaylor/vim-indentobject' -- not treesitter related, but close enough
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
      }
    }
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)

    -- Fix vim-indentobject keymaps
    vim.keymap.set('s', 'ai', 'ai')
  end
}
