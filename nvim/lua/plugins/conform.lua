local format = function() require('conform').format() end

return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      json = { 'jq', lsp_format = 'never' },
      javascript = { 'biome', lsp_format = 'never' },
      typescript = { 'biome', lsp_format = 'never' },
      yaml = { 'prettier', lsp_format = 'fallback' },
    },
    default_format_opts = {
      lsp_format = 'prefer',
      async = true,
    },
  },
  keys = {
    { '<leader>f', format, mode = 'n', desc = 'Format (conform)' },
    { '<leader>f', format, mode = 'x', desc = 'Format (conform)' },
  },
}
