return {
  cmd = { vim.fn.exepath('ruby') },
  filetypes = { 'ruby' },
  init_options = {
    addonSettings = {
      ['Ruby LSP Rails'] = {
        enablePendingMigrationsPrompt = false,
      },
    }
  },
}
