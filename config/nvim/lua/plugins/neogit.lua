return {
  'NeogitOrg/neogit',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  cmd = 'Neogit',
  keys = {
    { '<c-y>', '<cmd>Neogit<cr>', desc = 'Neogit' }
  },
  opts = {
    signs = {
      -- { CLOSED, OPENED }
      hunk = { "", "" },
      item = { "", "" },
      section = { "", "" },
    },
    integrations = {
      telescope = true,
    },
    graph_style = 'kitty',
    remember_settings = true,
    kind = 'tab',
    status = {
      show_head_commit_hash = true,
      recent_commit_count = 10,
      HEAD_padding = 7,
      HEAD_folded = false,
      mode_padding = 1,
      mode_text = {
        M = "M",
        N = "N",
        A = "A",
        D = "D",
        C = "C",
        U = "U",
        R = "R",
        T = "T",
        DD = "DD",
        AU = "AU",
        UD = "UD",
        UA = "UA",
        DU = "DU",
        AA = "AA",
        UU = "UU",
        ["?"] = "",
      },
    },
    mappings = {},
  },
}
