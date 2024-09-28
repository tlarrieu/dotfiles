local apply_xrdb = function()
  local xrdb = require('xrdb').load()
  if not xrdb then return end

  vim.cmd.colorscheme(xrdb.vim.theme)
  vim.o.background = xrdb.vim.background
  vim.cmd.syntax('on')
end

return {
  'maxmx03/solarized.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    palette = 'solarized',
    transparent = {
      enabled = true,
      normal = false,
      normalfloat = true,
      pmenu = true,
      telescope = true,
      lazy = true,
      mason = true,
    },
    styles = {
      comments = { italic = true, bold = false },
      functions = { bold = false },
      variables = { italic = false },
    },
    on_colors = function(c, _)
      local colors

      if vim.o.background == 'light' then
        colors = {
          fg = c.base00,
          mix_fg = c.base1,
          bg = c.base3,
          mix_bg = c.base2,
          dim_bg = c.base4,
          comment = c.base1,

          lualine = {
            git = {
              added = { fg = c.green, bg = c.base01 },
              removed = { fg = c.red, bg = c.base01 },
              modified = { fg = c.yellow, bg = c.base01 },
            },
          },
        }
      else
        colors = {
          fg = c.base0,
          mix_fg = c.base01,
          bg = c.base03,
          mix_bg = c.base02,
          dim_bg = c.base04,
          comment = c.base01,

          lualine = {
            git = {
              added = { fg = c.green, bg = c.base1 },
              removed = { fg = c.red, bg = c.base1 },
              modified = { fg = c.yellow, bg = c.base1 },
            },
          },
        }
      end

      return require('helpers').merge(colors, {
        none = 'None',
        telescope = {
          prompt = {
            fg = colors.bg,
            bg = colors.fg
          }
        }
      })
    end,
    on_highlights = function(c, _)
      for kind, icon in pairs({ Error = "", Warn = "", Hint = "", Info = "" }) do
        local hl = "DiagnosticSign" .. kind
        vim.fn.sign_define(hl, { text = icon, texthl = '', numhl = '' })
      end

      local paint = function(color, opts)
        return require('helpers').merge({ fg = c[color], bg = c['mix_' .. color] }, opts or {})
      end

      local group = vim.api.nvim_create_augroup('set_hl_ns', {})

      vim.api.nvim_set_hl(0, "LineNr", paint('blue'))
      vim.api.nvim_set_hl(0, "CursorLineNr", { link = 'CursorLine' })
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = c.comment })
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = c.comment })
      vim.api.nvim_set_hl(1, "LineNr", { fg = c.comment })
      vim.api.nvim_set_hl(1, "CursorLineNr", { link = 'LineNr' })
      vim.api.nvim_set_hl(1, "LineNrAbove", { link = 'LineNr' })
      vim.api.nvim_set_hl(1, "LineNrBelow", { link = 'LineNr' })

      vim.api.nvim_create_autocmd('WinEnter', {
        pattern = '*',
        callback = function()
          -- HACK: This is a sketchy way of not calling next line when in telescope prompt
          -- If next line is called, for some reason TelescopePromptNormal, defined
          -- later, does not properly get applied, and instead NormalFloat is applied
          if vim.bo[0].buftype == 'nofile' then return end

          vim.api.nvim_win_set_hl_ns(0, 0)
        end,
        group = group
      })

      vim.api.nvim_create_autocmd('WinLeave', {
        pattern = '*',
        callback = function() vim.api.nvim_win_set_hl_ns(0, 1) end,
        group = group
      })

      return {
        ---------------------- base ------------------------

        Normal = { fg = c.fg, bg = c.none },
        Constant = { fg = c.magenta },
        Identifier = { fg = c.blue },
        Include = { fg = c.orange },
        Keyword = { fg = c.green, bold = false },
        Special = { fg = c.magenta },
        String = { italic = true },
        Tag = { fg = c.yellow },
        TagAttribute = { fg = c.violet },
        Type = { fg = c.yellow },
        Whitespace = { fg = c.comment },
        Nontext = { fg = c.comment, bg = c.none, bold = true },

        ['@markup.strong'] = { fg = c.none, bold = true },
        ['@markup.italic'] = { fg = c.none, italic = true, underline = false },
        ['@markup.underline'] = { fg = c.none, underline = true },

        ['@conditional'] = { link = 'Conditional' },
        ['@field'] = { link = 'Normal' },
        ['@include'] = { link = 'Include' },
        ['@label'] = { fg = c.violet },
        ['@method'] = { link = 'Function' },
        ['@operator'] = { link = 'Normal' },
        ['@repeat'] = { link = 'Keyword' },
        ['@symbol'] = { link = 'String' },
        ['@type.builtin'] = { link = '@type' },
        ['@type.qualifier'] = { link = 'Keyword' },
        ['@variable'] = { link = 'Normal' },
        ['@variable.global'] = { fg = c.violet },

        ['@constructor.css'] = { fg = c.yellow },
        ['@operator.css'] = { link = '@tag.css' },
        ['@property.css'] = { fg = c.violet },
        ['@tag.css'] = { fg = c.orange },
        ['@type.css'] = { fg = c.violet },
        ['@field.css'] = { fg = c.mix_fg },

        ['@namespace.rasi'] = { fg = c.violet },
        ['@field.rasi'] = { fg = c.mix_fg },

        Folded = { link = 'Comment' },
        FoldColumn = { link = 'SignColumn' },

        CursorColumn = { fg = c.blue, bg = c.mix_blue },
        CursorLine = { link = 'CursorColumn' },

        Visual = { link = 'CursorColumn' },
        YankHighlight = { link = 'Visual' },

        Search = paint('magenta', { bold = false, underline = false }),
        IncSearch = paint('magenta', { bold = true, underline = true }),
        CurSearch = { link = 'IncSearch' },

        SpellBad = paint('red'),
        SpellCap = paint('blue', { undercurl = true }),
        SpellLocal = { link = 'SpellCap' },
        SpellRare = { link = 'SpellCap' },
        Error = { undercurl = true },

        DiagnosticOk = { fg = c.green, bg = c.none },
        DiagnosticError = { fg = c.red, bg = c.none },
        DiagnosticWarn = { fg = c.yellow, bg = c.none },
        DiagnosticInfo = { fg = c.blue, bg = c.none },
        DiagnosticHint = { fg = c.blue, bg = c.none },
        DiagnosticUnderlineOk = paint('green', { underline = false }),
        DiagnosticUnderlineError = paint('red', { underline = false }),
        DiagnosticUnderlineWarn = paint('yellow', { underline = false }),
        DiagnosticUnderlineInfo = paint('blue', { underline = false }),
        DiagnosticUnderlineHint = paint('blue', { underline = false }),

        DiffAdd = paint('green', { reverse = false }),
        DiffDelete = paint('red', { reverse = false }),
        DiffText = paint('blue', { reverse = false }),
        DiffChange = paint('yellow', { reverse = false }),
        Added = { link = 'DiffAdd' },
        Removed = { link = 'DiffDelete' },
        Changed = { link = 'DiffChange' },
        ['@diff.plus'] = { fg = c.green },
        ['@diff.minus'] = { fg = c.red },
        ['@diff.delta'] = { fg = c.yellow },
        ['@text.diff.add.diff'] = { link = 'DiffAdd' },
        ['@text.diff.delete.diff'] = { link = 'DiffDelete' },
        ['@text.diff.change.diff'] = { link = 'DiffChange' },

        Statusline = { fg = c.comment, bg = c.mix_bg },
        StatuslineNC = { link = 'Statusline' },
        LualineAdded = c.lualine.git.added,
        LualineRemoved = c.lualine.git.removed,
        LualineModified = c.lualine.git.modified,
        LualineTablineActive = { fg = c.bg, bg = c.blue },
        LualineTablineActiveAlt = { fg = c.bg, bg = c.fg },
        LualineTablineInactive = { fg = c.fg, bg = c.mix_bg },

        WinSeparator = { fg = c.comment },

        NormalFloat = { fg = c.fg, bg = c.mix_bg },
        FloatBorder = { fg = c.mix_bg, bg = c.mix_bg },
        FloatTitle = { fg = c.mix_fg, bg = c.mix_bg, bold = true },
        FloatFooter = { fg = c.fg, bg = c.bg },

        FidgetGroup = { fg = c.blue, bg = c.bg },

        QuickFixLine = { link = 'Search' },

        Pmenu = { fg = c.fg, bg = c.mix_bg },
        PmenuSel = { link = 'CursorLine' },

        --------------------- plugins ----------------------

        OilDir = { link = 'Normal' },
        OilDirIcon = { link = 'OilDir' },

        TelescopeNormal = { link = 'NormalFloat' },
        TelescopeBorder = { link = 'FloatBorder' },
        TelescopeTitle = { link = '@markup.strong' },
        TelescopePromptNormal = { fg = c.telescope.prompt.fg, bg = c.telescope.prompt.bg },
        TelescopePromptBorder = { link = 'TelescopePromptTitle' },
        TelescopePromptTitle = { fg = c.telescope.prompt.bg, bg = c.telescope.prompt.bg },
        TelescopePromptPrefix = { fg = c.telescope.prompt.fg },
        TelescopePromptCounter = { link = 'TelescopePromptPrefix' },
        TelescopeSelection = { link = 'CursorLine' },
        TelescopeSelectionCaret = { link = 'TelescopeSelection' },
        TelescopeMatching = { link = 'Incsearch' },
        TelescopeMultiSelection = { fg = c.yellow },
        TelescopeMultiIcon = { link = 'TelescopeMultiSelection' },
        TelescopeResultsDiffAdd = { fg = c.green },
        TelescopeResultsDiffDelete = { fg = c.red },
        TelescopeResultsDiffChange = { fg = c.yellow },

        LazyNormal = { link = 'NormalFloat' },
        LazyButton = paint('blue'),
        LazyButtonActive = paint('magenta'),
        LazySpecial = { fg = c.fg },

        MasonNormal = { link = 'NormalFloat' },
        MasonHeader = { link = 'lazyH1' },
        MasonHighlight = { fg = c.blue, bg = c.none },
        MasonHighlightBlock = paint('green'),
        MasonHighlightBlockBold = { link = 'LazyButtonActive' },
        MasonMutedBlock = { link = 'LazyButton' },

        GitSignsAdd = paint('green'),
        GitSignsDelete = paint('red'),
        GitSignsChange = paint('yellow'),
        GitSignsAddNr = { link = 'GitSignsAdd' },
        GitSignsDeleteNr = { link = 'GitSignsDelete' },
        GitSignsChangeNr = { link = 'GitSignsChange' },
        GitSignsAddLn = { fg = c.none, bg = c.mix_green },
        GitSignsChangeLn = { fg = c.none, bg = c.mix_yellow },

        GitSignsStagedAdd = { fg = c.mix_green, bg = c.dim_bg },
        GitSignsStagedDelete = { fg = c.mix_red, bg = c.dim_bg },
        GitSignsStagedChange = { fg = c.mix_yellow, bg = c.dim_bg },
        GitSignsStagedAddNr = { link = 'GitSignsStagedAdd' },
        GitSignsStagedDeleteNr = { link = 'GitSignsStagedDelete' },
        GitSignsStagedChangeNr = { link = 'GitSignsStagedChange' },
        GitSignsStagedAddLn = { fg = c.none, bg = c.dim_bg },
        GitSignsStagedChangeLn = { fg = c.none, bg = c.dim_bg },

        fugitiveHeading = { link = 'Include' },
        fugitiveStagedHeading = { fg = c.green },
        fugitiveUnstagedHeading = { fg = c.orange },
        ['@text.title.gitcommit'] = { link = 'Keyword' },
        ['@text.reference.gitcommit'] = { link = 'Special' },
        ['@text.uri.gitcommit'] = { link = 'Normal' },
        ['@keyword.gitcommit'] = { link = 'Constant' },

        CmpGhostText = { link = '@markup.list.unchecked' },
        CmpItemAbbrMatch = { bold = true },
        CmpItemKindVariable = { fg = c.violet },
        CmpItemKindSnippet = { fg = c.orange },

        ['@field.ledger'] = { fg = c.blue },
        ['@number.ledger'] = { fg = c.magenta },
        ['@string.special.ledger'] = { fg = c.yellow, bold = true },

        -- Those are definitions that we use inside actual neorg configuration
        NeorgDone = { link = '@markup.list.unchecked' },
        NeorgPending = { fg = c.green, italic = false },
        NeorgOnHold = { fg = c.yellow, italic = false },
        NeorgUndone = { fg = c.none, italic = false },
        NeorgCancelled = { link = 'NeorgDone' },
        NeorgLinkDescription = { underline = true, italic = true },
        NeorgCodeBlock = { bg = c.mix_bg },
        ['@markup.heading.1'] = { fg = c.magenta },
        ['@markup.heading.2'] = { fg = c.green },
        ['@markup.heading.3'] = { fg = c.blue },
        ['@markup.heading.4'] = { fg = c.yellow },
        ['@markup.heading.5'] = { fg = c.cyan },
        ['@markup.heading.6'] = { fg = c.violet },

        ['@punctuation.special.markdown'] = { fg = c.red },
        ['@text.title.1'] = { link = '@markup.heading.1' },
        ['@text.title.2'] = { link = '@markup.heading.2' },
        ['@text.title.3'] = { link = '@markup.heading.3' },
        ['@text.title.4'] = { link = '@markup.heading.4' },
        ['@text.title.5'] = { link = '@markup.heading.5' },
        ['@text.title.6'] = { link = '@markup.heading.6' },

        ['@todo.done'] = { fg = c.comment, strikethrough = true },
        ['@todo.priority'] = { fg = c.yellow },
        ['@todo.kv'] = { fg = c.comment, italic = true },
        ['@todo.date'] = { link = '@todo.kv' },
        ['@todo.project'] = { fg = c.violet },
        ['@todo.context'] = { fg = c.orange },

        ['@date.late'] = { fg = c.red, italic = true },
        ['@date.early'] = { fg = c.green, italic = true },
        ['@date.today'] = { fg = c.yellow, italic = true },

        DashboardHeader = { link = 'Comment' },
        DashboardFooter = { link = 'DashboardHeader' },
        DashboardDesc = { fg = c.fg, bold = true },
        DashboardIcon = { fg = c.violet },
        DashboardKey = { fg = c.cyan },
      }
    end
  },
  config = function(_, opts)
    require('solarized').setup(opts)

    apply_xrdb()

    vim.api.nvim_create_autocmd('Signal', {
      pattern = { 'SIGUSR1' },
      callback = apply_xrdb,
      nested = true,
      group = vim.api.nvim_create_augroup('update_background', {})
    })

    vim.api.nvim_create_autocmd('TextYankPost', {
      pattern = '*',
      callback = function() vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 }) end,
      group = vim.api.nvim_create_augroup("text_yank", {})
    })
  end
}
