return {
  'stevearc/conform.nvim',
  opts = {
    default_format_opts = {
      lsp_format = 'prefer',
      async = true,
    },
  },
  config = function(_, opts)
    local conform = require('conform')
    conform.setup(opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>f', conform.format)
  end
}
