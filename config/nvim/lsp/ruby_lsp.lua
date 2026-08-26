return {
  cmd = { vim.fn.exepath('bundle'), 'exec', 'ruby-lsp' },
  filetypes = { 'ruby' },
  cmd_env = { RUBY_LSP_BYPASS_TYPECHECKER = 'true' },
  init_options = {
    addonSettings = {
      ['Ruby LSP Rails'] = {
        enablePendingMigrationsPrompt = false,
      },
    }
  },
}
