return {
  'nvim-treesitter/nvim-treesitter',
  version = '*',
  build = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
  opts = {
    modules = {},
    ensure_installed = { 'all' },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
  }
}
