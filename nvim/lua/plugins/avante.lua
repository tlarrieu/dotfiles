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
    windows = {
      position = 'right',
      wrap = true,
      width = 35, -- %
      sidebar_header = {
        enabled = true,
        align = 'center',
        rounded = true,
      },
      spinner = {
        editing = { '∙∙∙', '●∙∙', '∙●∙', '∙∙●', '∙∙∙' },
        generating = { '✶', '✸', '✹', '✺', '✹', '✷' },
        thinking = { '🤯', '🙄' },
      },
      input = {
        prefix = ' ',
        height = 8,
      },
      edit = {
        border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
        start_insert = true,
      },
      ask = {
        floating = true,
        start_insert = true,
        border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
        focus_on_apply = 'ours',
      },
    },
    highlights = {
      diff = {
        current = 'DiffText',
        incoming = 'DiffAdd',
      },
    },
    behaviour = {
      auto_suggestions = true,
      auto_set_highlight_group = true,
      auto_set_keymaps = false,
      auto_apply_diff_after_generation = true,
      support_paste_from_clipboard = false,
      minimize_diff = true,
      enable_token_counting = true,
      auto_approve_tool_permissions = false,
    },
    shortcuts = {
      {
        name = 'refactor',
        description = 'Refactor code with best practices',
        details =
        'Automatically refactor code to improve readability, maintainability, and follow best practices while preserving functionality',
        prompt =
        'Please refactor this code following best practices, improving readability and maintainability while preserving functionality.',
      },
      {
        name = 'test',
        description = 'Generate unit tests',
        details = 'Create comprehensive unit tests covering edge cases, error scenarios, and various input conditions',
        prompt = 'Please generate comprehensive unit tests for this code, covering edge cases and error scenarios.',
      },
      {
        name = 'explain',
        description = 'Explain code functionality',
        details =
        "Provide a detailed explanation of the code's functionality, including its purpose, logic, and any important considerations.",
        prompt =
        "Please provide a detailed explanation of the code's functionality, including its purpose, logic, and any important considerations.",
      },
      {
        name = 'summarize',
        description = 'Generate short summary',
        details = 'Generate a concise summary of the selected text, highlighting key elements and main ideas.',
        prompt = 'Please generate a concise summary of the selected text, highlighting key elements and main ideas.',
      },
    }
  },
}
