---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local root = config.root_dir
    local bundled = root and vim.fn.filereadable(root .. '/Gemfile') == 1
    local cmd = bundled and { 'bundle', 'exec', 'rubocop', '--lsp' } or { vim.fn.exepath('rubocop'), '--lsp' }
    -- Speed fix for a slow cop (see the patch itself)
    local patch = vim.fn.stdpath('config') .. '/lsp/rubocop/block_alignment.rb'
    local rubyopt = vim.trim(('%s -r%s'):format(vim.env.RUBYOPT or '', patch))
    return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root, env = { RUBYOPT = rubyopt } })
  end,
  filetypes = { 'ruby' },
  root_markers = { '.rubocop.yml', 'Gemfile', '.git' },
  -- The server lints the whole file on every change, one request at a time: on large files a
  -- run outlasts the default 150ms between changes, so they pile up (and formatting waits behind
  -- them). Changes are sent at most once per second instead.
  -- Neovim applies the smallest debounce of all clients sharing a sync kind: full sync keeps
  -- rubocop apart from the other (incremental) servers.
  flags = {
    debounce_text_changes = 1000,
    allow_incremental_sync = false,
  },
}
