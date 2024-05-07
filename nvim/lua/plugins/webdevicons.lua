return {
  'nvim-tree/nvim-web-devicons',
  opts = {
    default = true,
    default_icon = '',
    override = {
      help = { icon = '' },
      man = { icon = '' },
      qf = { icon = '󰁨' },
      query = { icon = '󰙅' }, -- treesitter tree view

      harpoon = { icon = '🪝' },
      mason = { icon = '󰣪' },
      lazy = { icon = '󰘧' },
      TelescopePrompt = { icon = '', name = 'telescope' },
      oil = { icon = '' },

      norg = { icon = '󱗖' },

      vim = { icon = '' },
      json = { icon = '' },
      html = { icon = '' },
      css = { icon = '' },
      go = { icon = '' },
      gomod = { icon = '' },
      markdown = { icon = '' },
      ruby = { icon = '' },
      python = { icon = '' },
      cpp = { icon = '' },
      c = { icon = '' },
      gitcommit = { icon = '' },
      fugitive = { icon = '' },
      haskell = { icon = '󰲒' },
      rust = { icon = '' },
      java = { icon = '' },
      jar = { icon = '' },
      javascript = { icon = '' },
      ['javascript.jsx'] = { icon = '' },
      ['test.js'] = { icon = '' },
      ['test.jsx'] = { icon = '' },
      ['spec.js'] = { icon = '' },
      ['spec.jsx'] = { icon = '' },
      typescript = { icon = '' },
      typescriptreact = { icon = '' },
      ['test.ts'] = { icon = '' },
      ['test.tsx'] = { icon = '' },
      ['spec.ts'] = { icon = '' },
      ['spec.tsx'] = { icon = '' },
    },
    override_by_extension = {
      mod = { icon = '' },
    }
  },
}
