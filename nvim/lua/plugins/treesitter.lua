return {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
  opts = {
    modules = {},
    ensure_installed = { 'all' },
    sync_install = false,
    auto_install = true,
    ignore_install = { "javascript" },
    highlight = { enable = true },
  }
}
