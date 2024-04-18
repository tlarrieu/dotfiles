return {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
      format = {
        -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
        -- view: (default is cmdline view)
        -- opts: any options passed to the view
        -- icon_hl_group: optional hl_group for the icon
        -- title: set to anything or empty string to hide
        cmdline = { pattern = '^:', icon = ' ', lang = 'vim', title = '' },
        replace = { kind = 'search', pattern = '^:%%s/', icon = '󰃕 ', lang = 'regex', title = '' },
        search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex', title = '' },
        search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex', title = '' },
        filter = { kind = 'search', pattern = '^:%%s!', icon = ' ', lang = 'bash', title = '' },
        shell = { pattern = '^:!', icon = ' ', lang = 'bash', title = '' },
        lua = { pattern = '^:lua ', icon = ' ', lang = 'lua', title = '' },
        vim = { pattern = '^:call ', icon = ' ', lang = 'vim', title = '' },
        input = { title = '' },
      },
    },
    messages = {
      enabled = true,
    },
    views = {
      cmdline_popup = {
        position = { row = '20%', col = '50%' },
        border = { style = "single" },
      },
      confirm = {
        border = { style = "single", padding = { 0, 1 } },
      },
    },
    routes = {
      {
        filter = {
          any = {
            { event = 'msg_show', find = '".*" .*L, .*B' },
            { event = 'msg_show', kind = 'search_count' },
            { event = 'msg_show', find = 'search hit BOTTOM' },
            { event = 'msg_show', find = 'search hit TOP' },
            { event = 'msg_show', find = 'Pattern not found' },
            { event = 'msg_show', find = 'Hunk' },
            { event = 'msg_show', find = 'hunk' },
            { event = 'msg_show', find = 'change; before' },
            { event = 'msg_show', find = 'changes; before' },
            { event = 'msg_show', find = 'change; after' },
            { event = 'msg_show', find = 'changes; after' },
            { event = 'msg_show', find = 'line; before' },
            { event = 'msg_show', find = 'line; after' },
            { event = 'msg_show', find = 'line less' },
            { event = 'msg_show', find = 'line more' },
            { event = 'msg_show', find = 'fewer lines' },
            { event = 'msg_show', find = 'more lines' },
            { event = 'msg_show', find = '--No lines in buffer--' },
            { event = 'msg_show', find = '>ed' },
            { event = 'msg_show', find = '<ed' },
            { event = 'msg_show', find = 'indented' },
            { event = 'msg_show', find = 'yanked' },
          }
        },
        opts = { skip = true },
      },
    },
    lsp = {
      signature = {
        enabled = true,
        silent = true,
        opts = {
          border = 'single',
        },
        auto_open = {
          enabled = true,
          trigger = false, -- Automatically show signature help when typing a trigger character from the LSP
          luasnip = true,  -- Will open signature help when jumping to Luasnip insert nodes
          throttle = 250,  -- Debounce lsp signature help request by 50ms
        },
      },
      hover = {
        enabled = true,
        silent = true,
        opts = {
          border = 'single',
        }
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
    },
  }
}
