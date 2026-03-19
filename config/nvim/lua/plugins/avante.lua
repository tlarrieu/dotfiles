return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- Never set this value to '*'! Never!
  opts = {
    instructions_file = 'avante.md',
    provider = 'copilot',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim',
    'hrsh7th/nvim-cmp',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
  },
}
