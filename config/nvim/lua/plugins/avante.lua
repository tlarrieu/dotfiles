return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- Never set this value to '*'! Never!
  keys = {
    { '<c-e>', ':AvanteEdit<cr>', desc = 'Avante edit', silent = true, mode = { 'n', 'v' } },
    { '<c-s-e>', ':AvanteAsk<cr>', desc = 'Avante ask', silent = true },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim',
    'hrsh7th/nvim-cmp',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
  },
  opts = {
    instructions_file = 'avante.md',
    provider = 'copilot',
    selection = { enabled = false },
  },
}
