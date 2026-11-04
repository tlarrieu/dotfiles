---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root = config.root_dir
    local bundled = root and vim.fn.filereadable(root .. '/Gemfile') == 1
    local cmd = bundled and { 'bundle', 'exec', 'rubocop', '--lsp' } or { vim.fn.exepath('rubocop'), '--lsp' }
    return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root })
  end,
  filetypes = { 'ruby' },
  root_markers = { '.rubocop.yml', 'Gemfile', '.git' },
}
