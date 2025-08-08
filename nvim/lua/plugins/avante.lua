local strip = require('helpers').strip
return {
  'yetone/avante.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'MunifTanjim/nui.nvim' },
    { 'zbirenbaum/copilot.lua' },
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
          '▰▱▱',
          '▰▱▱',
          '▰▱▱',
          '▰▰▱',
          '▰▰▱',
          '▰▰▱',
          '▰▰▰',
          '▰▰▰',
          '▰▰▰',
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
        details = 'Refactor code to enhance readability, maintainability, and follow best practices.',
        prompt = strip([[
          Please refactor this code following best practices. Improve readability, maintainability, and code structure
          by applying relevant design patterns, simplifying logic where possible, and ensuring that functionality remains
          unchanged. Clearly document any complex sections of code and address any potential performance or security concerns.
        ]]),
      },
      {
        name = 'test',
        description = 'Generate unit tests',
        details = 'Create comprehensive unit tests covering edge cases, error scenarios, and various input conditions',
        prompt = strip([[
          Please generate comprehensive unit tests for this code, ensuring coverage of both typical and edge cases, error
          scenarios, and a variety of input conditions. Your tests should verify expected outputs, check for proper error
          handling, and include assertions for boundary and invalid input situations. If relevant, mock dependencies as
          needed and provide clear naming for each test case to indicate its purpose.
        ]]),
      },
      {
        name = 'explain',
        description = 'Explain code functionality',
        details = 'Explain what this code does, its main purpose, step-by-step logic, and any key design decisions.',
        prompt = strip([[
          Please explain in detail what this code does: describe its purpose, break down its logic step by step,
          and highlight any important implementation details or considerations.
        ]]),
      },
      {
        name = 'annotate',
        description = 'Add comments to the code',
        details = 'Document the code with comments explaining its purpose, logic, and any important considerations.',
        prompt = strip([[
          Please document the code by adding clear and concise comments.
          For each function, variable, or logic block, include comments that explain its main purpose, its inputs and
          outputs, and how it interacts with other parts of the code.
          Ensure that any complex algorithms, edge cases, or tricky logic are thoroughly explained.
          Highlight any important considerations such as performance implications, security concerns, or dependencies.
        ]]),
      },
      {
        name = 'summarize',
        description = 'Generate short summary',
        details = 'Generate a concise summary of the selected text, highlighting key elements and main ideas.',
        prompt = 'Please generate a concise summary of the selected text, highlighting key elements and main ideas.',
      },
      {
        name = 'review',
        description = 'Review code for potential issues',
        details =
        'Analyze the code for potential issues, bugs, or areas of improvement, providing suggestions for enhancement.',
        prompt = strip([[
          You are a seasoned engineer with expertise in code review. Your task is to analyze the provided code snippet and come up with a detailed review.
          Focus your attention on:
          - code clarity
          - readability and performance
        ]])
      },
    }
  },
}
