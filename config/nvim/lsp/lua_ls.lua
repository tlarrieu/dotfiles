local root_markers = {
  '.emmyrc.json',
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
  '.git'
}

---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = root_markers,
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = 'Disable' },
      format = {
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
          align_array_table = 'false',
        },
      },
      diagnostics = {
        neededFileStatus = { ['codestyle-check'] = 'Any' },
      },
    },
  },
}
