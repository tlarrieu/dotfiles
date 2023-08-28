return {
  "nvim-neorg/neorg",
  dependencies = { 'nvim-lua/plenary.nvim' },
  build = ":Neorg sync-parsers",
  ft = { 'norg' },
  keys = {
    { '<leader>ei', '<cmd>Neorg index<cr>', desc = 'Neorg index' },
    { '<leader>et', '<cmd>Neorg toc<cr>',   desc = 'Neorg ToC' },
  },
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            work = "~/.neorg/work",
            home = "~/.neorg/home",
          },
          default_workspace = 'home'
        }
      }
    }
  }
}
