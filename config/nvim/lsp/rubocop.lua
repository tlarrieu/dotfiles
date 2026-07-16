---@type vim.lsp.Config
return {
  cmd = { vim.fn.exepath('rubocop'), '--lsp' },
  filetypes = { 'ruby' },
  root_markers = { '.rubocop.yml', 'Gemfile', '.git' },
}
