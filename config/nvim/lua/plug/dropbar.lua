vim.pack.add({ 'https://github.com/Bekaboo/dropbar.nvim' }, { confirm = false })

require('dropbar').setup({
  bar = {
    enable = function(buf, win, _)
      buf = vim._resolve_bufnr(buf)

      if not vim.api.nvim_buf_is_valid(buf) then return false end
      if not vim.api.nvim_win_is_valid(win) then return false end
      if vim.fn.win_gettype(win) ~= '' then return false end
      if vim.wo[win].winbar ~= '' then return false end
      if vim.bo[buf].bt == 'nofile' then return false end

      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname:match('gitsigns://') then
        vim.opt_local.winbar = bufname
        return false
      end

      local stat = vim.uv.fs_stat(bufname)
      if stat and stat.size > 1024 * 1024 then return false end

      return vim.bo[buf].bt == 'terminal'
          or pcall(vim.treesitter.get_parser, buf)
          or not vim.tbl_isempty(vim.lsp.get_clients({
            bufnr = buf,
            method = 'textDocument/documentSymbol',
          }))
    end,
    update_events = {
      buf = {
        vim.version().minor >= 13 and { event = 'OptionSet', pattern = 'modified' } or 'BufModifiedSet',
        'FileChangedShellPost',
        'TextChanged',
        'ModeChanged',
      }
    },
  },
  sources = {
    path = {
      max_depth = 1,
      min_widths = { 1000 },
      modified = function(sym)
        return sym:merge({ icon = '󰴓 ', name_hl = 'DropBarModified', icon_hl = 'DropBarModified' })
      end
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
    terminal = {
      icon = '󰆍 ',
      name = function(_)
        local ok, pid = pcall(vim.fn.jobpid, vim.bo.channel)
        if ok then return 'term://' .. pid else return 'term://???' end
      end,
    },
  },
  icons = {
    ui = {
      bar = { separator = ' 󰅂 ', extends = ' 󰇘 ' },
      menu = { separator = ' ', indicator = ' ' },
    },
    kinds = {
      file_icon = function(path)
        local buf = vim.iter(vim.api.nvim_list_bufs()):find(function(buf)
          return vim.api.nvim_buf_get_name(buf) == path
        end)

        local icon

        if buf then
          icon, _ = require('helpers').icon_and_filetype(
            vim.api.nvim_buf_get_name(buf),
            vim.bo[buf].filetype
          )
        else -- HACK: if we could not find a buf number, this usually means that we are in a file coming from gitsigns or codediff
          icon = ''
        end

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
        Folder = ' ',
        Struct = ' ',
        Event = '󱐌 ',
        Operator = '󱓉 ',
        TypeParameter = ' ',

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
        Terminal = '󰆍 ',
        Type = ' ',
        WhileStatement = '󰑖 ',
      },
    },
  },
})

local group = vim.api.nvim_create_augroup('dropbar_filetype_autocmd', {})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'man', },
  callback = function() vim.opt_local.winbar = '󰭣  man' end,
  group = group,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit' },
  callback = function() vim.opt_local.winbar = ' commit' end,
  group = group,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'fugitive' },
  callback = function() vim.opt_local.winbar = ' fugitive' end,
  group = group,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf' },
  callback = function() vim.opt_local.winbar = ' quickfix' end,
  group = group,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'oil' },
  callback = function() vim.opt_local.winbar = ' ' .. require('oil').get_current_dir():gsub('/home/%w+/', '~/') end,
  group = group,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'floggraph' },
  callback = function() vim.opt_local.winbar = ' logs' end,
  group = group,
})
