return {
  'maxmx03/solarized.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    theme = 'neo',
    transparent = true,
    styles = {
      comments = { italic = true, bold = false },
      functions = { bold = true },
      variables = { italic = false },
    },
    enables = {
      treesitter = false,
    },
    highlights = function(c, _)
      vim.cmd [[
        sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
        sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
        sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
      ]]

      local telescope_accent = c.base01

      return {
        -- base

        String = { italic = true },

        ['@text.strong'] = { fg = c.none, bold = true },
        ['@text.emphasis'] = { fg = c.none, italic = true },
        ['@text.reference'] = { fg = c.base3, bold = true },

        Cursor = { fg = c.base1, bg = c.base02 },
        TermCursorNC = { link = 'Cursor' },

        Normal = { bg = c.base03 },
        Function = { bold = false },
        ['@variable'] = { link = 'Identifier' },
        NormalFloat = { bg = c.base03 },
        FloatBorder = { fg = c.base00, bg = c.base03 },

        Folded = { link = 'Normal' },
        FoldColumn = { link = 'SignColumn' },

        YankHighlight = { bg = c.base02 },

        Search = { bg = c.base02 },
        CurSearch = { fg = c.base02, bg = c.green },
        IncSearch = { fg = c.base02, bg = c.magenta },

        SpellBad = { fg = c.red, undercurl = true },
        SpellLocal = { fg = c.blue, undercurl = true },
        SpellCap = { link = 'SpellLocal' },
        SpellRare = { link = 'SpellLocal' },

        Error = { undercurl = true },
        DiagnosticUnderlineError = { undercurl = true, bg = c.base02 },

        DiagnosticSignError = { fg = c.red, bg = c.base02 },
        DiagnosticSignWarn = { fg = c.yellow, bg = c.base02 },
        DiagnosticSignInfo = { fg = c.blue, bg = c.base02 },
        DiagnosticSignHint = { fg = c.base0, bg = c.base02 },

        NormalNC = { bg = c.base02 },
        SignColumn = { link = 'NormalNC' },
        WinSeparator = { fg = c.base01, bg = c.base02 },

        StatusLine = { link = 'Normal' },
        StatusLineNC = { link = 'Tabline' },

        CursorLine = { link = 'CursorColumn' },

        LineNr = { fg = c.magenta, bg = c.base02 },
        LineNrAbove = { fg = c.base0, bg = c.base02 },
        LineNrBelow = { link = 'LineNrAbove' },

        DiffAdd = { fg = c.green, bg = c.none },
        DiffChange = { fg = c.yellow, bg = c.none },
        DiffDelete = { fg = c.red, bg = c.none },

        QuickFixLine = { fg = c.yellow, bg = c.none },

        Pmenu = { fg = c.blue, bg = c.base02 },
        PmenuSel = { fg = c.base02, bg = c.magenta },
        PmenuThumb = { fg = c.base02, bg = c.base00 },

        -- plugins

        LazyNormal = { bg = c.base03 },
        MasonNormal = { bg = c.base03 },

        TelescopeBorder = { fg = c.base03, bg = c.base03 },
        TelescopeTitle = { link = 'TelescopeBorder' },

        TelescopePromptTitle = { fg = telescope_accent, bg = telescope_accent },
        TelescopePromptBorder = { link = 'TelescopePromptTitle' },
        TelescopePromptNormal = { fg = c.base02, bg = telescope_accent },
        TelescopePromptPrefix = { link = 'TelescopePromptNormal' },
        TelescopePromptCounter = { link = 'TelescopePromptNormal' },

        TelescopeMatching = { link = 'Search' },
        TelescopeNormal = { bg = c.base03 },
        TelescopeResultsNormal = { fg = c.base1, bg = c.base03 },
        TelescopeSelection = { fg = c.base0, bg = c.base02 },
        TelescopeMultiIcon = { link = 'TelescopeNormal' },

        -- Those are definitions that we use inside actual neorg configuration
        NeorgDone = { fg = c.base01, bg = c.base03, italic = false },
        NeorgPending = { fg = c.green, bg = c.base03, italic = false },
        NeorgOnHold = { fg = c.yellow, bg = c.base03, italic = false },
        NeorgUndone = { fg = c.red, bg = c.base03, italic = false },
        NeorgCancelled = { link = 'NeorgDone' },
        NeorgHeading4 = { fg = c.cyan, italic = false },

        CmpItemAbbrMatch = { fg = c.base0, bg = c.base02, underline = true, bold = true },
        CmpItemKindEnum = { bold = false },
        CmpItemKindFile = { bold = false },
        CmpItemKindText = { bold = false },
        CmpItemKindUnit = { bold = false },
        CmpItemKindClass = { bold = false },
        CmpItemKindColor = { bold = false },
        CmpItemKindEvent = { bold = false },
        CmpItemKindField = { bold = false },
        CmpItemKindValue = { bold = false },
        CmpItemKindFolder = { bold = false },
        CmpItemKindMethod = { bold = false },
        CmpItemKindModule = { bold = false },
        CmpItemKindStruct = { bold = false },
        CmpItemKindDefault = { bold = false },
        CmpItemKindKeyword = { bold = false },
        CmpItemKindSnippet = { bold = false },
        CmpItemKindConstant = { bold = false },
        CmpItemKindFunction = { bold = false },
        CmpItemKindOperator = { bold = false },
        CmpItemKindProperty = { bold = false },
        CmpItemKindVariable = { bold = false },
        CmpItemKindInterface = { bold = false },
        CmpItemKindReference = { bold = false },
        CmpItemKindEnumMember = { bold = false },
        CmpItemKindConstructor = { bold = false },
        CmpGhostText = { fg = c.base01, bg = c.base02 },

        NoiceCursor = { fg = c.base02, bg = c.base01 },
        NoicePopupBorder = { fg = c.base00, bg = c.base03 },
        NoiceConfirmBorder = { fg = c.base00, bg = c.base03 },
        NoiceFormatConfirm = { fg = c.base00, bg = c.base03 },
        NoiceFormatConfirmDefault = { link = 'IncSearch' },
        NoiceCmdlinePopup = { bg = c.base03 },
        NoiceCmdlineIcon = { fg = c.blue, bg = c.base03 },
        NoiceCmdlineIconSearch = { fg = c.yellow, bg = c.base03 },
        NoiceCmdlinePopupBorder = { link = 'NoicePopupBorder' },
        NoiceCmdlinePopupBorderSearch = { link = 'NoicePopupBorder' },

        NotifyBackground = { bg = c.base03 },
        NotifyINFOBody = { link = 'NotifyBackground' },
        NotifyWARNBody = { link = 'NotifyINFOBody' },
        NotifyERRORBody = { link = 'NotifyINFOBody' },
        NotifyDEBUGBody = { link = 'NotifyINFOBody' },
        NotifyTRACEBUGBody = { link = 'NotifyINFOBody' },

        IlluminatedWordText = { fg = c.base02, bg = c.blue },

        MarkSignHL = { bg = c.base02 },
        MarkSignNumHL = { link = 'MarkSignHL' },
        MarkVirtTextHL = { link = 'MarkSignHL' },

        GitGutterAdd = { fg = c.green, bg = c.base02 },
        GitGutterChange = { fg = c.yellow, bg = c.base02 },
        GitGutterDelete = { fg = c.red, bg = c.base02 },
      }
    end
  },
  config = function(_, opts)
    require('solarized').setup(opts)

    vim.o.background = 'light'
    vim.cmd.colorscheme 'solarized'

    local group = vim.api.nvim_create_augroup("text_yank", {})
    vim.api.nvim_create_autocmd('TextYankPost', {
      pattern = '*',
      callback = function() vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 }) end,
      group = group,
    })
  end
}
