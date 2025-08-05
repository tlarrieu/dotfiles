return {
  'yetone/avante.nvim',
  build = 'make',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'MunifTanjim/nui.nvim' },
    {
      'zbirenbaum/copilot.lua',
      opts = {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    },
    { 'nvim-telescope/telescope.nvim' },
    { 'hrsh7th/nvim-cmp' },
    { 'nvim-tree/nvim-web-devicons' },
  },
  keys = function(_, keys)
    local avante = require('avante.api')
    local mappings = {
      { '<leader>ca', avante.ask,          desc = 'avante: ask',          mode = { 'n', 'v' } },
      { '<leader>cr', avante.refresh,      desc = 'avante: refresh',      mode = 'v', },
      { '<leader>ce', avante.edit,         desc = 'avante: edit',         mode = { 'n', 'v' } },
      { '<leader>cr', avante.refresh,      desc = 'avante: refresh',      mode = { 'n', 'v' } },
      { '<leader>cf', avante.focus,        desc = 'avante: focus',        mode = { 'n', 'v' } },
      { '<leader>cs', avante.stop,         desc = 'avante: stop',         mode = { 'n', 'v' } },
      { '<leader>c?', avante.select_model, desc = 'avante: select model', mode = { 'n', 'v' } },
    }
    mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
    return vim.list_extend(mappings, keys)
  end,
  opts = {
    provider = 'copilot',
    auto_suggestions_provider = 'copilot',
    hints = { enabled = false },
    behaviour = {
      auto_suggestions = true,
      auto_set_highlight_group = true,
      auto_set_keymaps = false,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,
      enable_token_counting = true,
      auto_approve_tool_permissions = false,
    },
  },
}
