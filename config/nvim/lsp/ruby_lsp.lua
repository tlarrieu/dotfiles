---@type vim.lsp.Config
return {
  init_options = {
    addonSettings = {
      ['Ruby LSP Rails'] = {
        enablePendingMigrationsPrompt = false,
      },
    }
  },
}
