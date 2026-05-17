return {
  settings = {
    gopls = {
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        staticcheck = true,
        unreachable = true,
      }
    }
  }
}
