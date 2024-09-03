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
      'gitcommit',
      'go',
      'gomod',
      'haskell',
      'javascript',
      'latex',
      'lua',
      'markdown',
      'norg',
      'ocaml',
      'query',
      'ruby',
      'tsx',
      'typescript',
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = { 'embedded_template', 'html' },
      additional_vim_regex_highlighting = { 'markdown', 'make' },
    },
    indent = { enable = true, disable = { 'embedded_template', 'html' } },
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
          ['i='] = '@assignment.inner',
          ['a='] = '@assignment.outer',
        },
      }
    }
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)

    vim.api.nvim_create_autocmd('Filetype', {
      pattern = { '*' },
      callback = function(args)
        local ft = args.match
        if vim.treesitter.language.get_lang(ft) then
          vim.opt_local.spell = true
        end
      end,
      group = vim.api.nvim_create_augroup('treesitter_autocmd', {})
    })
  end
}
