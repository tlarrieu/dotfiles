return {
  "nvim-neorg/neorg",
  dependencies = { 'nvim-lua/plenary.nvim' },
  build = ":Neorg sync-parsers",
  ft = { 'norg' },
  keys = {
    { '<leader>ei', '<cmd>Neorg index<cr>',    desc = 'Neorg index' },
    { '<leader>eq', '<cmd>Neorg return<cr>',   desc = 'Leave neorg' },
    { '<leader>et', '<cmd>Neorg toc left<cr>', desc = 'Neorg ToC' },
  },
  opts = {
    load = {
      ["core.defaults"] = {},
      ["core.summary"] = {},
      ["core.concealer"] = {},
      ["core.qol.toc"] = {
        config = {
          close_after_use = true
        }
      },
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
