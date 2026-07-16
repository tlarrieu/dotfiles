---@type vim.lsp.Config
return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  settings = {
    gopls = {
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
      semanticTokens = true,
      analyses = {
        unusedparams = true,
        staticcheck = true,
        unreachable = true,
      }
    }
  }
}
