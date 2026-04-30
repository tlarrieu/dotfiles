local format = function() require('conform').format() end

local prettier = { 'prettier', lsp_format = 'fallback' }
local biome = { 'biome', lsp_format = 'never' }

return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      json = { 'jq', lsp_format = 'never' },
      javascript = biome,
      typescript = biome,
      yaml = prettier,
      sql = { 'sql' },
      edifact = { 'edifact' },

      ['_'] = { 'trim_whitespace' },
    },
    default_format_opts = {
      lsp_format = 'prefer',
      async = true,
    },
    formatters = {
      sql = {
        command = 'pg_format',
        args = { '-u', 1, '-U', 1, '-b', '-s', 2 },
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
  },
  keys = {
    { '<leader>f', format, mode = 'n', desc = 'Format (conform)' },
    { '<leader>f', format, mode = 'x', desc = 'Format (conform)' },
  },
}
