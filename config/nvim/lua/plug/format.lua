vim.pack.add({ 'https://github.com/stevearc/conform.nvim' }, { confirm = false })

local conform = require('conform')

local prettier = { 'prettier', lsp_format = 'fallback' }
local biome = { 'biome', lsp_format = 'never' }

conform.setup({
  formatters_by_ft = {
    json = { 'jq', lsp_format = 'never' },
    javascript = biome,
    typescript = biome,
    yaml = prettier,
    sql = { 'sql', lsp_format = 'never' },
    edifact = { 'edifact' },
    go = { 'goimports', lsp_format = 'never' },

    ['_'] = { 'trim_whitespace' },
  },
  default_format_opts = {
    lsp_format = 'prefer',
    async = true,
  },
  format_after_save = { undojoin = true },
  formatters = {
    sql = {
      command = 'pg_format',
      args = { '-u', 1, '-U', 1, '-f', 1, '-b', '-s', 2, '-L' },
    },
    edifact = {
      command = 'perl',
      args = {
        '-p',
        '-e', [[s/(?<!\?)' */'/g;]],
        '-e', [[s/(?<!\?)' *(.)/'\n\1/g;]],
        '-e', [[s/^ *//g;]],
        '-e', [[s/^\n$//g;]],
      },
    },
  },
})

vim.keymap.set({ 'n', 'x' }, '<leader>f', function() conform.format({ async = true }) end, { desc = 'Format (conform)' })
