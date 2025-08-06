return {
  'yetone/avante.nvim',
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
    local run = function(action)
      return function()
        if action == 'toggle' then return require('avante').toggle() end
        require('avante.api')[action]()
      end
    end

    local mappings = {
      { '<c-space>',  run('ask'),          desc = 'avante: ask',          mode = { 'n', 'v' } },
      { ' ',          run('edit'),         desc = 'avante: edit',         mode = 'v' },
      { '<leader>aa', run('toggle'),       desc = 'avante: toggle',       mode = 'n' },
      { '<leader>ae', run('focus'),        desc = 'avante: focus',        mode = 'n' },
      { '<leader>as', run('select_model'), desc = 'avante: select model', mode = 'n' },
    }
    mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
    return vim.list_extend(mappings, keys)
  end,
  opts = {
    provider = 'copilot',
    auto_suggestions_provider = 'copilot',
    hints = { enabled = false },
    mappings = {
      sidebar = {
        apply_all = 'A',
        apply_cursor = 'a',
        retry_user_request = 'r',
        edit_user_request = 'e',
        switch_windows = nil,
        reverse_switch_windows = nil,
        remove_file = 'd',
        add_file = '@',
        close = { 'q' },
        close_from_input = { normal = 'q', insert = '<c-d>' },
      },
      submit = {
        normal = '<cr>',
        insert = '<cr>',
      },
      cancel = {
        normal = { '<esc>' },
        insert = { '<esc>' },
      },
    },
    prompt_logger = {
      enabled = true,
      log_dir = vim.fn.stdpath('cache') .. '/avante_prompts',
      fortune_cookie_on_success = false,
      next_prompt = {
        normal = '<c-n>',
        insert = '<c-n>',
      },
      prev_prompt = {
        normal = '<c-p>',
        insert = '<c-p>',
      },
    },
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
        editing = {
          '∙∙∙',
          '∙∙∙',
          '●∙∙',
          '●∙∙',
          '∙●∙',
          '∙●∙',
          '∙∙●',
          '∙∙●',
        },
        generating = {
          "▰▱▱",
          "▰▱▱",
          "▰▱▱",
          "▰▰▱",
          "▰▰▱",
          "▰▰▱",
          "▰▰▰",
          "▰▰▰",
          "▰▰▰",
        },
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
        name = 'annotate',
        description = 'Add comments to the code',
        details = 'Document the code with comments explaining its purpose, logic, and any important considerations.',
        prompt =
        'Please document the code with comments explaining its purpose, logic, and any important considerations.',
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
