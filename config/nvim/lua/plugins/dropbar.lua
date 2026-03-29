return {
  'Bekaboo/dropbar.nvim',
  dependencies = { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  opts = {
    bar = {
      enable = function(buf, win, _)
        buf = vim._resolve_bufnr(buf)

        if not vim.api.nvim_buf_is_valid(buf) then return false end
        if not vim.api.nvim_win_is_valid(win) then return false end
        if vim.fn.win_gettype(win) ~= '' then return false end
        if vim.wo[win].winbar ~= '' then return false end
        if vim.bo[buf].bt == 'nofile' then return false end
        if vim.bo[buf].ft == 'gitcommit' then return false end

        local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
        if stat and stat.size > 1024 * 1024 then return false end

        return vim.bo[buf].bt == 'terminal'
            or pcall(vim.treesitter.get_parser, buf)
            or not vim.tbl_isempty(vim.lsp.get_clients({
              bufnr = buf,
              method = 'textDocument/documentSymbol',
            }))
      end,
    },
    sources = {
      path = {
        max_depth = 1,
        min_widths = { 1000 },
        modified = function(sym) return sym:merge({ icon = '󰴓 ', name_hl = 'DropbarModified', icon_hl = 'DropbarModified' }) end
      },
      lsp = {
        min_widths = { 1000, 1000 },
        valid_symbols = {
          'File',
          'Module',
          'Namespace',
          'Class',
          'Method',
          'Constructor',
          'Function',
          'Object',
          'Variable',
          'Property',
          'Field',
          'Array',
        },
      },
      treesitter = {
        min_widths = { 1000, 1000 },
        valid_types = {
          'class',
          'constant',
          'constructor',
          'function',
          'interface',
          'method',
          'namespace',
          'package',
          'variable',
          'field',
          'object',
          'property',
        }
      },
    },
    icons = {
      ui = {
        bar = { separator = '  ', extends = '󰇘' },
        menu = { separator = ' ', indicator = ' ' },
      },
      kinds = {
        file_icon = function(path)
          local buf = vim.iter(vim.api.nvim_list_bufs()):find(function(buf)
            return vim.api.nvim_buf_get_name(buf) == path
          end)

          local icon, _ = require('helpers').icon_and_filetype(
            vim.api.nvim_buf_get_name(buf),
            vim.bo[buf].filetype
          )

          return icon .. ' ', 'DropBarIconKindDefault'
        end,
        symbols = {
          Text = ' ',
          Method = '󰡱 ',
          Function = '󰡱 ',
          Constructor = '󰡱 ',
          Field = ' ',
          Property = ' ',
          Variable = '󰀫 ',
          Constant = '󱃮 ',
          Class = ' ',
          Interface = ' ',
          Module = '󰅩 ',
          Unit = '󰺾 ',
          Value = '󰎠 ',
          Enum = ' ',
          EnumMember = ' ',
          Keyword = ' ',
          Color = '󰌁 ',
          Reference = ' ',
          File = '󰈔 ',
          Folder = ' ',
          Struct = ' ',
          Event = '󱐌 ',
          Operator = '󱓉 ',
          TypeParameter = ' ',
          Copilot = '󱨚 ',

          Array = '󰅪 ',
          BlockMappingPair = '󰅩 ',
          Boolean = ' ',
          BreakStatement = '󰙧 ',
          Call = '󰅲 ',
          CaseStatement = '󱃙 ',
          ContinueStatement = '→ ',
          Declaration = '󰙠 ',
          Delete = '󰩺 ',
          DoStatement = '󰑖 ',
          Element = '󰅩 ',
          ForStatement = '󰑖 ',
          GotoStatement = '󰁔 ',
          Identifier = '󰀫 ',
          IfStatement = '󰇉 ',
          List = '󰅪 ',
          Log = '󰦪 ',
          Lsp = ' ',
          Macro = '󰁌 ',
          MarkdownH1 = '󰉫 ',
          MarkdownH2 = '󰉬 ',
          MarkdownH3 = '󰉭 ',
          MarkdownH4 = '󰉮 ',
          MarkdownH5 = '󰉯 ',
          MarkdownH6 = '󰉰 ',
          Namespace = '󰅩 ',
          Null = '󰢤 ',
          Number = '󰎠 ',
          Object = '󰅩 ',
          Package = '󰏗 ',
          Pair = '󰅪 ',
          Regex = ' ',
          Repeat = '󰑖 ',
          Return = '󰌑 ',
          Rule = '󰅩 ',
          RuleSet = '󰅩 ',
          Scope = '󰅩 ',
          Section = '󰅩 ',
          Snippet = '󰩫 ',
          Specifier = '󰦪 ',
          Statement = '󰅩 ',
          String = '󰉾 ',
          SwitchStatement = '󰺟 ',
          Table = '󰅪 ',
          Terminal = ' ',
          Type = ' ',
          WhileStatement = '󰑖 ',
        },
      },
    },
  },
  config = function(_, opts)
    -- for some reason, filetype does not get set before dropbar access it
    -- let's just disable winbar manually for filetypes we want it off
    -- this might be a bug in neovim
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'Neogit*', 'gitcommit' },
      callback = function() vim.opt_local.winbar = nil end,
      group = vim.api.nvim_create_augroup('neogit_filetype_autocmd', {}),
    })

    require('dropbar').setup(opts)
  end,
}
