local xrdb = require('xrdb')

local apply_xrdb = function()
  vim.cmd.colorscheme('solarized')
  vim.o.background = xrdb.load().vim.background or 'light'
  vim.cmd.syntax('on')

  local theme = xrdb.load() or {}
  vim.g.terminal_color_0 = theme.color0
  vim.g.terminal_color_1 = theme.color1
  vim.g.terminal_color_2 = theme.color2
  vim.g.terminal_color_3 = theme.color3
  vim.g.terminal_color_4 = theme.color4
  vim.g.terminal_color_5 = theme.color5
  vim.g.terminal_color_6 = theme.color6
  vim.g.terminal_color_7 = theme.color7
  vim.g.terminal_color_8 = theme.color8
  vim.g.terminal_color_9 = theme.color9
  vim.g.terminal_color_10 = theme.color10
  vim.g.terminal_color_11 = theme.color11
  vim.g.terminal_color_12 = theme.color12
  vim.g.terminal_color_13 = theme.color13
  vim.g.terminal_color_14 = theme.color14
  vim.g.terminal_color_15 = theme.color15
end

local merge = require('helpers').merge

return {
  'maxmx03/solarized.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    palette = 'solarized',
    transparent = {
      enabled = true,
      normal = true,
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

          lualine = {
            git = {
              added = { fg = c.green, bg = c.base2 },
              removed = { fg = c.red, bg = c.base2 },
              modified = { fg = c.yellow, bg = c.base2 },
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

          lualine = {
            git = {
              added = { fg = c.green, bg = c.base02 },
              removed = { fg = c.red, bg = c.base02 },
              modified = { fg = c.yellow, bg = c.base02 },
            },
          },
        }
      end

      return merge(colors, {
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
      for kind, icon in pairs({ Error = "󰅙", Warn = "", Hint = "󰠠", Info = "" }) do
        local hl = "DiagnosticSign" .. kind
        local hl_value = 'Diagnostic' .. kind
        vim.fn.sign_define(hl, { text = icon, texthl = hl_value, numhl = hl_value })
      end

      local paint = function(color, opts)
        return merge({ fg = c[color], bg = c['mix_' .. color] }, opts or {})
      end

      local group = vim.api.nvim_create_augroup('set_hl_ns', {})

      vim.api.nvim_set_hl(0, "LineNr", paint('blue'))
      vim.api.nvim_set_hl(0, "CursorLineNr", { link = 'CursorLine' })
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = c.mix_fg })
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = c.mix_fg })
      vim.api.nvim_set_hl(1, "LineNr", { fg = c.mix_fg })
      vim.api.nvim_set_hl(1, "CursorLineNr", { link = 'LineNr' })
      vim.api.nvim_set_hl(1, "LineNrAbove", { link = 'LineNr' })
      vim.api.nvim_set_hl(1, "LineNrBelow", { link = 'LineNr' })

      vim.api.nvim_create_autocmd({ 'WinEnter' }, {
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
        ---------------------| base |-----------------------

        Normal = { fg = c.fg, bg = c.none },
        Constant = { fg = c.magenta },
        Identifier = { fg = c.blue },
        Include = { fg = c.orange, bold = false },
        Keyword = { fg = c.green, bold = false },
        Special = { fg = c.magenta },
        String = { italic = true },
        Tag = { fg = c.yellow },
        TagAttribute = { fg = c.violet },
        Type = { fg = c.yellow },
        Whitespace = { fg = c.mix_fg },
        Nontext = { fg = c.mix_fg, bg = c.none, bold = true },

        ['@normal'] = { fg = c.fg, bg = c.none },
        qfText = { link = '@normal' },

        ['@markup.strong'] = { fg = c.none, bold = true },
        ['@markup.italic'] = { fg = c.none, italic = true, underline = false },
        ['@markup.underline'] = { fg = c.none, underline = true },
        ['@markup.quote'] = { fg = c.none, italic = true },

        ['@markup.raw.markdown_inline'] = { fg = c.none, bg = c.none },

        ['@conditional'] = { link = 'Conditional' },
        ['@field'] = { link = '@normal' },
        ['@include'] = { link = 'Include' },
        ['@label'] = { fg = c.violet },
        ['@method'] = { link = 'Function' },
        ['@operator'] = { link = '@normal' },
        ['@repeat'] = { link = 'Keyword' },
        ['@symbol'] = { link = 'String' },
        ['@type.builtin'] = { link = '@type' },
        ['@type.qualifier'] = { link = 'Keyword' },
        ['@variable'] = { link = '@normal' },
        ['@property'] = { fg = c.mix_fg, bg = c.none },
        ['@variable.global'] = { fg = c.violet },

        ['@variable.parameter.fish'] = { fg = c.violet },

        ['@variable.member.lua'] = { link = '@normal' },
        ['@variable.parameter.lua'] = { link = '@normal' },
        ['@keyword.luadoc'] = { link = '@constant' },
        ['@keyword.import.luadoc'] = { link = '@keyword.luadoc' },
        ['@keyword.return.luadoc'] = { link = '@keyword.luadoc' },
        ['@variable.member.luadoc'] = { link = '@comment' },
        ['@variable.parameter.luadoc'] = { link = '@comment' },
        ['@function.macro.luadoc'] = { link = '@type' },

        ['@function.builtin.make'] = { link = 'makeConfig' },

        ['@variable.parameter.ruby'] = { link = '@normal' },
        ['@string.special.symbol.ruby'] = { link = '@string.ruby' },
        ['@variable.member.ruby'] = { fg = c.violet, bg = c.none },
        ['@operator.ruby'] = { fg = c.mix_fg, bg = c.none },

        ['@variable.sql'] = { fg = c.normal, bg = c.none, italic = true },
        ['@variable.member.sql'] = { fg = c.mix_fg, bg = c.none },
        ['@type.sql'] = { fg = c.yellow, bg = c.none },

        ['@property.yaml'] = { fg = c.mix_fg, bg = c.none, bold = false },

        ['@variable.parameter.go'] = { fg = c.mix_fg },
        ['@variable.member.go'] = { fg = c.mix_fg },

        ['@constructor.css'] = { fg = c.yellow },
        ['@operator.css'] = { link = '@tag.css' },
        ['@property.css'] = { fg = c.violet },
        ['@tag.css'] = { fg = c.orange },
        ['@type.css'] = { fg = c.violet },
        ['@field.css'] = { fg = c.mix_fg },

        ['@constructor.scss'] = { fg = c.yellow },
        ['@operator.scss'] = { link = '@tag.css' },
        ['@property.scss'] = { fg = c.violet },
        ['@tag.scss'] = { fg = c.orange },
        ['@type.scss'] = { fg = c.violet },
        ['@field.scss'] = { fg = c.mix_fg },

        ['@namespace.rasi'] = { fg = c.yellow },
        ['@field.rasi'] = { fg = c.mix_fg },
        ['@variable.rasi'] = { fg = c.violet },

        Folded = { link = 'Comment' },
        FoldColumn = { link = 'SignColumn' },

        CursorColumn = { fg = c.none, bg = c.mix_blue },
        CursorLine = { link = 'CursorColumn' },
        CursorLineNr = { fg = c.blue, bg = c.mix_blue },

        Visual = { link = 'CursorColumn' },
        YankHighlight = { link = 'Visual' },

        Search = paint('magenta', { bold = false, underline = false }),
        IncSearch = paint('magenta', { bold = true, underline = true }),
        CurSearch = { link = 'IncSearch' },
        ExchangeRegion = paint('violet'),

        SpellBad = paint('red'),
        SpellCap = paint('blue', { undercurl = true }),
        SpellLocal = { link = 'SpellCap' },
        SpellRare = { link = 'SpellCap' },
        Error = { undercurl = true },

        DiagnosticOk = { fg = c.green, bg = c.none },
        DiagnosticError = { fg = c.red, bg = c.none },
        DiagnosticWarn = { fg = c.yellow, bg = c.none },
        DiagnosticInfo = { fg = c.violet, bg = c.none },
        DiagnosticHint = { fg = c.violet, bg = c.none },

        DiagnosticFloatingOk = { fg = c.green, bg = c.none },
        DiagnosticFloatingError = { fg = c.red, bg = c.none },
        DiagnosticFloatingWarn = { fg = c.yellow, bg = c.none },
        DiagnosticFloatingInfo = { fg = c.violet, bg = c.none },
        DiagnosticFloatingHint = { fg = c.violet, bg = c.none },

        DiagnosticVirtualTextOk = { fg = c.green, bg = c.none },
        DiagnosticVirtualTextError = { fg = c.red, bg = c.none },
        DiagnosticVirtualTextWarn = { fg = c.yellow, bg = c.none },
        DiagnosticVirtualTextInfo = { fg = c.violet, bg = c.none },
        DiagnosticVirtualTextHint = { fg = c.violet, bg = c.none },

        DiagnosticUnderlineOk = paint('green', { underline = false }),
        DiagnosticUnderlineError = paint('red', { underline = false }),
        DiagnosticUnderlineWarn = paint('yellow', { underline = false }),
        DiagnosticUnderlineInfo = paint('violet', { underline = false }),
        DiagnosticUnderlineHint = paint('violet', { underline = false }),

        DiagnosticPass = { fg = c.green, bg = c.mix_green, italic = true },
        DiagnosticMixed = { fg = c.yellow, bg = c.mix_yellow, italic = true },
        DiagnosticFail = { fg = c.red, bg = c.mix_red, italic = true },

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

        Statusline = { fg = c.mix_fg, bg = c.mix_bg },
        StatuslineNC = { link = 'Statusline' },
        LualineAdded = c.lualine.git.added,
        LualineRemoved = c.lualine.git.removed,
        LualineModified = c.lualine.git.modified,
        LualineTablineActive = { fg = c.bg, bg = c.blue },
        LualineTablineActiveAlt = { fg = c.bg, bg = c.fg },
        LualineTablineInactive = { fg = c.fg, bg = c.mix_bg },

        WinSeparator = { fg = c.mix_bg, bg = c.none },

        NormalFloat = { fg = c.fg, bg = c.mix_bg },
        FloatBorder = { fg = c.mix_bg, bg = c.mix_bg },
        FloatTitle = { fg = c.mix_fg, bg = c.mix_bg, bold = true },
        FloatFooter = { fg = c.fg, bg = c.bg },

        FidgetGroup = { fg = c.blue, bg = c.bg },

        QuickFixLine = { link = 'Search' },

        Pmenu = { fg = c.fg, bg = c.mix_bg },
        PmenuSel = { link = 'CursorLine' },

        --------------------| plugins |---------------------

        OilDir = { link = '@normal' },
        OilDirIcon = { link = 'OilDir' },

        HarpoonLine = { link = 'QuickFixLine' },

        TreesitterContext = { fg = c.none, bg = c.mix_bg },
        TreesitterContextBottom = { fg = c.none, bg = c.mix_bg },
        TreesitterContextLineNumber = { fg = c.mix_fg, bg = c.mix_bg },

        TelescopeNormal = { link = 'NormalFloat' },
        TelescopeBorder = { link = 'FloatBorder' },
        TelescopeTitle = { link = '@markup.strong' },
        TelescopePreviewBorder = { fg = c.telescope.prompt.bg, bg = c.mix_bg, bold = true },
        TelescopePreviewTitle = { link = 'TelescopePreviewBorder' },
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

        MarkSignHL = { fg = c.mix_fg, bg = c.mix_bg },
        MarkSignNumHL = { link = 'MarkSignHL' },

        ['MarkviewCode'] = { fg = c.none, bg = c.mix_bg },
        ['MarkviewInlineCode'] = { fg = c.none, bg = c.mix_bg },
        ['MarkviewHeading1'] = { fg = c.magenta, bg = c.mix_bg, underline = true },
        ['MarkviewHeading2'] = { fg = c.green, bg = c.none },
        ['MarkviewHeading3'] = { fg = c.blue, bg = c.none },
        ['MarkviewHeading4'] = { fg = c.yellow, bg = c.none },
        ['MarkviewHeading5'] = { fg = c.cyan, bg = c.none },
        ['MarkviewHeading6'] = { fg = c.violet, bg = c.none },
        ['MarkviewPalette0'] = { fg = c.none, bg = c.mix_bg },
        ['MarkviewPalette1'] = paint('magenta'),
        ['MarkviewPalette2'] = paint('green'),
        ['MarkviewPalette3'] = paint('blue'),
        ['MarkviewPalette4'] = paint('yellow'),
        ['MarkviewPalette5'] = paint('cyan'),
        ['MarkviewPalette6'] = paint('violet'),
        ['MarkviewPalette1Sign'] = { fg = c.magenta, bg = c.none },
        ['MarkviewPalette2Sign'] = { fg = c.green, bg = c.none },
        ['MarkviewPalette3Sign'] = { fg = c.blue, bg = c.none },
        ['MarkviewPalette4Sign'] = { fg = c.yellow, bg = c.none },
        ['MarkviewPalette5Sign'] = { fg = c.cyan, bg = c.none },
        ['MarkviewPalette6Sign'] = { fg = c.violet, bg = c.none },
        ['MarkviewBlockQuoteDefault'] = { fg = c.mix_fg, bg = c.none },

        GitSignsAdd = paint('green'),
        GitSignsAddNr = { link = 'GitSignsAdd' },
        GitSignsAddLn = { fg = c.none, bg = c.mix_green },
        GitSignsDelete = paint('red'),
        GitSignsDeleteNr = { link = 'GitSignsDelete' },
        GitSignsTopDelete = { link = 'GitSignsDelete' },
        GitSignsTopDeleteNr = { link = 'GitSignsTopDelete' },
        GitSignsChange = paint('yellow'),
        GitSignsChangeNr = { link = 'GitSignsChange' },
        GitSignsChangeLn = { fg = c.none, bg = c.mix_yellow },
        GitSignsChangeDelete = paint('violet'),
        GitSignsChangeDeleteNr = { link = 'GitSignsChangeDelete' },
        GitSignsChangeDeleteLn = { fg = c.none, bg = c.mix_violet },
        GitSignsStagedAdd = { fg = c.mix_fg, bg = c.dim_bg },
        GitSignsStagedAddNr = { link = 'GitSignsStagedAdd' },
        GitSignsStagedAddLn = { fg = c.none, bg = c.dim_bg },
        GitSignsStagedDelete = { fg = c.mix_fg, bg = c.dim_bg },
        GitSignsStagedDeleteNr = { link = 'GitSignsStagedDelete' },
        GitSignsStagedTopDelete = { link = 'GitSignsStagedDelete' },
        GitSignsStagedTopDeleteNr = { link = 'GitSignsStagedDeleteNr' },
        GitSignsStagedChange = { fg = c.mix_fg, bg = c.dim_bg },
        GitSignsStagedChangeNr = { link = 'GitSignsStagedChange' },
        GitSignsStagedChangeLn = { fg = c.none, bg = c.dim_bg },
        GitSignsStagedChangeDelete = { link = 'GitSignsStagedChange' },
        GitSignsStagedChangeDeleteNr = { link = 'GitSignsStagedChangeNr' },
        GitSignsStagedChangeDeleteLn = { link = 'GitSignsStagedChangeLn' },
        GitSignsCurrentLineBlame = { fg = c.mix_fg, bg = c.mix_bg, underline = true, italic = true },

        fugitiveHeading = { link = 'Include' },
        fugitiveStagedHeading = { fg = c.green },
        fugitiveUnstagedHeading = { fg = c.orange },
        ['@markup.heading.gitcommit'] = { fg = c.green, bg = c.none },
        ['@text.reference.gitcommit'] = { fg = c.magenta, bg = c.none },
        ['@text.uri.gitcommit'] = { fg = c.fg, bg = c.none },
        ['@string.special.path.gitcommit'] = { fg = c.mix_fg, bg = c.none },
        ['@keyword.gitcommit'] = { fg = c.yellow, bg = c.none },
        ['@markup.heading.git_config'] = { fg = c.yellow, bg = c.none },

        CmpGhostText = { link = '@markup.list.unchecked' },
        CmpItemAbbrMatch = { bold = true },
        CmpItemKindVariable = { fg = c.violet },
        CmpItemKindSnippet = { fg = c.orange },

        ['@field.ledger'] = { fg = c.blue },
        ['@number.ledger'] = { fg = c.magenta },
        ['@markup.raw.ledger'] = { fg = c.fg },
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

        ['@string.todotxt'] = { italic = false },
        ['@todo.done'] = { fg = c.mix_fg, strikethrough = true },
        ['@todo.priority'] = { fg = c.yellow },
        ['@comment.todotxt'] = { link = '' },
        ['@todo.kv'] = { fg = c.mix_fg, italic = true },
        ['@todo.date'] = { fg = c.mix_fg },
        ['@todo.project'] = { fg = c.violet },
        ['@todo.context'] = { fg = c.orange, bold = true },
        ['@date.late'] = { fg = c.red, bold = true },
        ['@date.today'] = { fg = c.yellow },
        ['@date.early'] = { fg = c.green },

        ['TodoBgFIX'] = paint('red'),
        ['TodoFgFIX'] = { fg = c.red },
        ['TodoBgTODO'] = paint('violet'),
        ['TodoFgTODO'] = { fg = c.violet },
        ['TodoBgHACK'] = paint('red'),
        ['TodoFgHACK'] = { fg = c.red },
        ['TodoBgWARN'] = paint('yellow'),
        ['TodoFgWARN'] = { fg = c.yellow },
        ['TodoBgPERF'] = paint('cyan'),
        ['TodoFgPERF'] = { fg = c.cyan },
        ['TodoBgNOTE'] = paint('violet'),
        ['TodoFgNOTE'] = { fg = c.violet },
        ['TodoBgTEST'] = paint('cyan'),
        ['TodoFgTEST'] = { fg = c.cyan },

        DashboardHeader = { fg = c.mix_fg, bg = c.none }
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
