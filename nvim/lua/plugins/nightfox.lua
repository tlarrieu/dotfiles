return {
  'EdenEast/nightfox.nvim',
  lazy = false,
  opts = {
    options = {
      transparent = true,
      dim_inactive = false,
      styles = {
        strings = 'italic',
        comments = 'italic',
      },
    },
    palettes = {
      dawnfox = {
        green = '#a1bc89',
        blue = '#429cbf',
        yellow = '#d39f02',
      },
    },
    groups = {
      all = {
        ---------------------| base |-----------------------

        Keyword = { fg = 'palette.green', bg = 'none' },
        Conditional = { link = 'Keyword' },
        String = { fg = 'palette.cyan.bright', bg = 'none' },
        ['@property'] = { fg = 'palette.comment', bg = 'none' },
        ['@function'] = { fg = 'palette.blue', bg = 'none' },
        ['@type'] = { fg = 'palette.yellow', bg = 'none' },
        ['@string.regexp'] = { fg = 'palette.pink', bg = 'none' },
        ['@string.escape'] = { fg = 'palette.magenta.bright', bg = 'none', style = 'bold' },

        ['@key'] = { fg = 'palette.comment', bg = 'none', style = 'italic' },

        -- MsgArea
        MsgArea = { link = 'MsgAreaMsg' },
        MsgAreaCmd = { fg = 'palette.fg1', style = 'NONE' },
        MsgAreaMsg = { link = 'Comment' },

        -- quickfix
        qfText = { link = '@normal' },
        qfLineNr = { fg = 'palette.comment' },
        QuickFixLine = { link = 'Search' },

        -- folds
        Folded = { link = 'Comment' },
        FoldColumn = { link = 'SignColumn' },
        CursorLineNr = { link = 'CursorLine' },

        -- search
        Search = { fg = 'palette.bg1', bg = 'palette.green.dim', style = 'bold' },
        IncSearch = { fg = 'palette.bg1', bg = 'palette.green.bright', style = 'bold' },
        CurSearch = { link = 'IncSearch' },
        ExchangeRegion = { fg = 'palette.bg1', bg = 'palette.pink.bright' },

        -- diagnostics
        DiagnosticPass = { fg = 'palette.bg1', bg = 'palette.green.bright' },
        DiagnosticMixed = { fg = 'palette.bg1', bg = 'palette.yellow.bright' },
        DiagnosticFail = { fg = 'palette.bg1', bg = 'palette.red.bright' },

        -- floats
        NormalFloat = { fg = 'none', bg = 'palette.bg0' },
        FloatBorder = { fg = 'palette.bg0', bg = 'palette.bg0' },
        FloatTitle = { fg = 'palette.fg0', bg = 'palette.bg0', style = 'bold' },
        FloatFooter = { fg = 'palette.fg1', bg = 'palette.bg1' },

        -- winseparator
        WinSeparator = { fg = 'palette.bg0', bg = 'palette.bg0' },

        -- pmenu
        Pmenu = { fg = 'palette.fg1', bg = 'palette.bg0' },
        PmenuSel = { bg = 'palette.sel0' },

        -- markup
        ['@markup.strong'] = { fg = 'none', style = 'bold' },
        ['@markup.italic'] = { fg = 'none', style = 'italic' },
        ['@markup.underline'] = { fg = 'none', style = 'underline' },
        ['@markup.quote'] = { fg = 'palette.comment', style = 'italic' },
        ['@markup.link'] = { fg = 'palette.magenta', style = 'italic' },
        ['@markup.link.url'] = { link = '@markup.link' },
        ['@markup.link.label'] = { link = '@markup.link' },
        ['@markup.raw.markdown_inline'] = { fg = 'none', bg = 'none' },
        ['@markup.heading.1'] = { fg = 'palette.pink' },
        ['@markup.heading.2'] = { fg = 'palette.green' },
        ['@markup.heading.3'] = { fg = 'palette.blue' },
        ['@markup.heading.4'] = { fg = 'palette.yellow' },
        ['@markup.heading.5'] = { fg = 'palette.cyan' },
        ['@markup.heading.6'] = { fg = 'palette.magenta' },

        ---------------| Language specific |----------------

        -- bash
        ['@variable.parameter.bash'] = { link = '@normal' },

        -- lua
        ['@variable.member.lua'] = { link = '@normal' },
        ['@variable.parameter.lua'] = { link = '@normal' },
        ['@keyword.luadoc'] = { link = '@constant' },
        ['@keyword.import.luadoc'] = { link = '@keyword.luadoc' },
        ['@keyword.return.luadoc'] = { link = '@keyword.luadoc' },
        ['@variable.member.luadoc'] = { link = '@key' },
        ['@variable.parameter.luadoc'] = { link = '@key' },
        ['@function.macro.luadoc'] = { link = '@type' },

        -- make
        ['@function.builtin.make'] = { link = 'makeConfig' },

        -- ruby
        ['@variable.key.ruby'] = { link = '@key' },
        ['@variable.member.ruby'] = { fg = 'palette.magenta', bg = 'none' },
        ['@variable.parameter.ruby'] = { link = '@normal' },
        ['@string.special.symbol.ruby'] = { link = '@string.ruby' },
        ['@operator.ruby'] = { fg = 'palette.comment', bg = 'none' },
        ['@punctuation.special.ruby'] = { fg = 'palette.comment', bg = 'none' },

        -- SQL
        ['@variable.sql'] = { fg = 'palette.fg1', bg = 'none', style = 'italic' },
        ['@variable.member.sql'] = { fg = 'palette.fg0', bg = 'none' },
        ['@type.sql'] = { fg = 'palette.yellow', bg = 'none' },

        -- yaml
        ['@property.yaml'] = { link = '@key' },

        -- go
        ['@variable.parameter.go'] = { fg = 'palette.fg0' },
        ['@variable.member.go'] = { fg = 'palette.fg0' },

        -- css / scss
        ['@constructor.css'] = { fg = 'palette.yellow' },
        ['@constructor.scss'] = { link = '@constructor.css' },
        ['@field.css'] = { fg = 'palette.fg0' },
        ['@field.scss'] = { link = '@field.css' },
        ['@operator.css'] = { link = '@tag.css' },
        ['@operator.scss'] = { link = '@tag.css' },
        ['@property.css'] = { fg = 'palette.magenta' },
        ['@property.scss'] = { link = '@property.css' },
        ['@tag.css'] = { fg = 'palette.orange' },
        ['@tag.scss'] = { link = '@tag.css' },
        ['@type.css'] = { fg = 'palette.magenta' },
        ['@type.scss'] = { link = '@type.css' },

        -- rasi
        ['@namespace.rasi'] = { link = '@constructor.css' },
        ['@field.rasi'] = { link = '@field.css' },
        ['@variable.rasi'] = { link = '@property.css' },

        -- kitty
        kittySt = { link = 'String' },

        ----------------------| plugins |----------------------

        Directory = { fg = 'palette.blue', bg = 'none' },
        OilDir = { link = 'Directory' },
        OilDirIcon = { link = 'OilDir' },

        HarpoonLine = { link = 'Search' },

        TreesitterContext = { bg = 'palette.bg0', style = 'italic' },
        TreesitterContextBottom = { bg = 'none', link = 'TreesitterContext' },
        TreesitterContextLineNumber = { fg = 'palette.fg0', bg = 'palette.bg0', style = 'italic' },
        TreesitterContextSeparator = { fg = 'palette.bg0', bg = 'palette.bg0' },

        TelescopeNormal = { link = 'NormalFloat' },
        TelescopeBorder = { link = 'FloatBorder' },
        TelescopeTitle = { fg = 'palette.fg3', bg = 'none' },
        TelescopePreviewBorder = { link = 'FloatBorder' },
        TelescopePreviewTitle = { fg = 'palette.fg3', style = 'bold' },
        TelescopePromptNormal = { fg = 'palette.bg1', bg = 'palette.fg1' },
        TelescopePromptBorder = { link = 'TelescopePromptTitle' },
        TelescopePromptTitle = { fg = 'palette.fg1', bg = 'palette.fg1' },
        TelescopePromptPrefix = { fg = 'palette.bg1', bg = 'palette.fg1' },
        TelescopePromptCounter = { link = 'TelescopePromptPrefix' },
        TelescopeSelection = { link = 'CursorLine' },
        TelescopeSelectionCaret = { link = 'TelescopeSelection' },
        TelescopeMatching = { link = 'Incsearch' },
        TelescopeMultiSelection = { fg = 'palette.yellow' },
        TelescopeMultiIcon = { link = 'TelescopeMultiSelection' },
        TelescopeResultsDiffAdd = { fg = 'palette.green' },
        TelescopeResultsDiffDelete = { fg = 'palette.red' },
        TelescopeResultsDiffChange = { fg = 'palette.yellow' },

        LazySpecial = { fg = 'palette.fg1' },

        MasonHeader = { link = 'lazyH1' },
        MasonHighlight = { fg = 'palette.green', bg = 'none' },
        MasonHighlightBlock = { fg = 'palette.bg1', bg = 'palette.green.bright' },
        MasonHighlightBlockBold = { link = 'LazyButtonActive' },
        MasonMutedBlock = { link = 'LazyButton' },

        LualineAdded = { fg = 'palette.green' },
        LualineRemoved = { fg = 'palette.red' },
        LualineModified = { fg = 'palette.yellow' },
        LualineTablineActive = { fg = 'palette.bg1', bg = 'palette.blue' },
        LualineTablineActiveAlt = { fg = 'palette.fg1', bg = 'palette.bg1', style = 'bold' },
        LualineTablineInactive = { fg = 'palette.fg1', bg = 'palette.bg0' },
        LualineExecutable = { fg = 'palette.green', bg = 'none' },

        FidgetGroup = { fg = 'palette.orange', bg = 'none', style = 'bold,italic' },

        MarkSignHL = { fg = 'palette.fg0', bg = 'palette.bg0' },
        MarkSignNumHL = { link = 'MarkSignHL' },

        MarkviewCode = { fg = 'none', bg = 'palette.bg0' },
        MarkviewCodeLabel = { fg = 'palette.bg0', bg = 'palette.yellow.bright', style = 'bold' },
        MarkviewInlineCode = { fg = 'none', bg = 'palette.bg0' },
        MarkviewHyperlink = { fg = 'palette.magenta', bg = 'none', style = 'italic' },
        MarkviewImage = { fg = 'palette.blue', bg = 'none', style = 'italic' },
        MarkviewBlockQuoteDefault = { fg = 'palette.fg0', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteError = { fg = 'palette.red', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteNote = { fg = 'palette.blue', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteOk = { fg = 'palette.green', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteSpecial = { fg = 'palette.yellow', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteWarn = { fg = 'palette.yellow', bg = 'none', style = 'NONE' },
        MarkviewHeading1 = { fg = 'palette.pink', bg = 'palette.bg0', style = 'underline' },
        MarkviewHeading2 = { fg = 'palette.green', bg = 'none' },
        MarkviewHeading3 = { fg = 'palette.blue', bg = 'none' },
        MarkviewHeading4 = { fg = 'palette.yellow', bg = 'none' },
        MarkviewHeading5 = { fg = 'palette.cyan', bg = 'none' },
        MarkviewHeading6 = { fg = 'palette.magenta', bg = 'none' },
        MarkviewListItemMinus = { fg = 'palette.pink', bg = 'none' },
        MarkviewListItemStar = { fg = 'palette.green', bg = 'none' },
        MarkviewListItemPlus = { fg = 'palette.blue', bg = 'none' },
        MarkviewPalette0 = { fg = 'none', bg = 'palette.bg0' },
        MarkviewPalette1 = { fg = 'palette.bg1', bg = 'palette.pink' },
        MarkviewPalette2 = { fg = 'palette.bg1', bg = 'palette.green' },
        MarkviewPalette3 = { fg = 'palette.bg1', bg = 'palette.blue' },
        MarkviewPalette4 = { fg = 'palette.bg1', bg = 'palette.yellow' },
        MarkviewPalette5 = { fg = 'palette.bg1', bg = 'palette.cyan' },
        MarkviewPalette6 = { fg = 'palette.bg1', bg = 'palette.magenta' },
        MarkviewPalette1Sign = { fg = 'palette.pink', bg = 'none' },
        MarkviewPalette2Sign = { fg = 'palette.green', bg = 'none' },
        MarkviewPalette3Sign = { fg = 'palette.blue', bg = 'none' },
        MarkviewPalette4Sign = { fg = 'palette.yellow', bg = 'none' },
        MarkviewPalette5Sign = { fg = 'palette.cyan', bg = 'none' },
        MarkviewPalette6Sign = { fg = 'palette.magenta', bg = 'none' },
        MarkviewCheckboxChecked = { fg = 'palette.green', bg = 'none' },
        MarkviewCheckboxUnchecked = { fg = 'palette.yellow', bg = 'none' },
        MarkviewCheckboxStriked = { fg = 'palette.fg0', bg = 'none', style = 'strikethrough' },
        MarkviewGradient0 = { fg = '#cccdc1', bg = 'none' },
        MarkviewGradient1 = { fg = '#c4c8bd', bg = 'none' },
        MarkviewGradient2 = { fg = '#bdc3b9', bg = 'none' },
        MarkviewGradient3 = { fg = '#b6bfb5', bg = 'none' },
        MarkviewGradient4 = { fg = '#afbab1', bg = 'none' },
        MarkviewGradient5 = { fg = '#a9b5ae', bg = 'none' },
        MarkviewGradient6 = { fg = '#a2b0aa', bg = 'none' },
        MarkviewGradient7 = { fg = '#9daaa7', bg = 'none' },
        MarkviewGradient8 = { fg = '#97a5a3', bg = 'none' },
        MarkviewGradient9 = { fg = '#92a0a0', bg = 'none' },

        fugitiveHeading = { link = 'Include' },
        fugitiveStagedHeading = { fg = 'palette.green' },
        fugitiveUnstagedHeading = { fg = 'palette.orange' },
        ['@markup.heading.gitcommit'] = { fg = 'palette.green', bg = 'none' },
        ['@text.reference.gitcommit'] = { fg = 'palette.magenta', bg = 'none' },
        ['@text.uri.gitcommit'] = { fg = 'palette.fg1', bg = 'none' },
        ['@string.special.path.gitcommit'] = { fg = 'palette.fg0', bg = 'none' },
        ['@keyword.gitcommit'] = { fg = 'palette.yellow', bg = 'none' },
        ['@markup.heading.git_config'] = { fg = 'palette.yellow', bg = 'none' },

        GitSignsAdd = { fg = 'palette.green', bg = 'palette.bg0' },
        GitSignsAddNr = { link = 'GitSignsAdd' },
        GitSignsAddLn = { fg = 'none', },
        GitSignsDelete = { fg = 'palette.red', bg = 'palette.bg0' },
        GitSignsDeleteNr = { link = 'GitSignsDelete' },
        GitSignsTopDelete = { link = 'GitSignsDelete' },
        GitSignsTopDeleteNr = { link = 'GitSignsTopDelete' },
        GitSignsChange = { fg = 'palette.yellow', bg = 'palette.bg0' },
        GitSignsChangeNr = { link = 'GitSignsChange' },
        GitSignsChangeLn = { fg = 'none', },
        GitSignsChangeDelete = { fg = 'palette.magenta', bg = 'palette.bg0' },
        GitSignsChangeDeleteNr = { link = 'GitSignsChangeDelete' },
        GitSignsChangeDeleteLn = { fg = 'none', },
        GitSignsStagedAdd = { fg = 'palette.comment', bg = 'palette.bg1' },
        GitSignsStagedAddNr = { link = 'GitSignsStagedAdd' },
        GitSignsStagedAddLn = { fg = 'none', bg = 'palette.bg1' },
        GitSignsStagedDelete = { fg = 'palette.comment', bg = 'palette.bg1' },
        GitSignsStagedDeleteNr = { link = 'GitSignsStagedDelete' },
        GitSignsStagedTopDelete = { link = 'GitSignsStagedDelete' },
        GitSignsStagedTopDeleteNr = { link = 'GitSignsStagedDeleteNr' },
        GitSignsStagedChange = { fg = 'palette.comment', bg = 'palette.bg1' },
        GitSignsStagedChangeNr = { link = 'GitSignsStagedChange' },
        GitSignsStagedChangeLn = { fg = 'none', bg = 'palette.bg0' },
        GitSignsStagedChangeDelete = { link = 'GitSignsStagedChange' },
        GitSignsStagedChangeDeleteNr = { link = 'GitSignsStagedChangeNr' },
        GitSignsStagedChangeDeleteLn = { link = 'GitSignsStagedChangeLn' },
        GitSignsCurrentLineBlame = { fg = 'palette.comment', bg = 'palette.bg0', style = 'underline,italic' },

        CmpGhostText = { fg = 'palette.white.dim' },
        CmpItemAbbrMatch = { style = 'bold' },
        CmpItemKindVariable = { fg = 'palette.magenta' },
        CmpItemKindSnippet = { fg = 'palette.orange' },
        CmpItemKindCopilot = { fg = 'palette.white.dim' },

        ['@field.ledger'] = { fg = 'palette.blue' },
        ['@number.ledger'] = { fg = 'palette.green' },
        ['@number.negative.ledger'] = { fg = 'palette.red' },
        ['@markup.raw.ledger'] = { fg = 'palette.fg1' },
        ['@string.special.ledger'] = { fg = 'palette.yellow', style = 'bold' },

        AvanteTitle = { fg = 'palette.bg1', bg = 'palette.fg0' },
        AvanteReversedTitle = { fg = 'palette.fg0', bg = 'palette.bg0' },
        AvanteSubtitle = { link = 'AvanteTitle' },
        AvanteReversedSubtitle = { link = 'AvanteReversedTitle' },
        AvanteThirdTitle = { link = 'AvanteTitle' },
        AvanteReversedThirdTitle = { link = 'AvanteReversedTitle' },
        AvantePopupHint = { fg = 'palette.fg0', bg = 'palette.bg0', style = 'italic' },
        AvanteTaskFailed = { fg = 'palette.red' },
        AvanteThinking = { fg = 'palette.pink' },
        AvanteTaskRunning = { fg = 'palette.pink' },
        AvanteTaskCompleted = { fg = 'palette.green' },
        AvanteStateSpinnerFailed = { fg = 'palette.bg1', bg = 'palette.red.bright' },
        AvanteStateSpinnerThinking = { fg = 'palette.bg1', bg = 'palette.magenta.bright' },
        AvanteStateSpinnerSearching = { fg = 'palette.bg1', bg = 'palette.magenta.bright' },
        AvanteStateSpinnerSucceeded = { fg = 'palette.bg1', bg = 'palette.green.bright' },
        AvanteStateSpinnerCompacting = { fg = 'palette.bg1', bg = 'palette.magenta.bright' },
        AvanteStateSpinnerGenerating = { fg = 'palette.bg1', bg = 'palette.blue.bright' },
        AvanteStateSpinnerToolCalling = { fg = 'palette.bg1', bg = 'palette.cyan.bright' },
        AvanteToBeDeletedWOStrikethrough = { link = 'DiffDelete' },
        AvanteConflictIncoming = { fg = 'none', bg = 'palette.green.bright' },
        AvantePromptInput = { link = 'NormalFloat' },
        AvantePromptInputBorder = { link = 'FloatBorder' },

        TodoBgFIX = { fg = 'palette.bg1', bg = 'palette.red' },
        TodoFgFIX = { fg = 'palette.red' },
        TodoBgTODO = { fg = 'palette.bg1', bg = 'palette.magenta' },
        TodoFgTODO = { fg = 'palette.magenta' },
        TodoBgHACK = { fg = 'palette.bg1', bg = 'palette.red' },
        TodoFgHACK = { fg = 'palette.red', bg = 'none' },
        TodoBgWARN = { fg = 'palette.bg1', bg = 'palette.yellow' },
        TodoFgWARN = { fg = 'palette.yellow' },
        TodoBgPERF = { fg = 'palette.bg1', bg = 'palette.cyan' },
        TodoFgPERF = { fg = 'palette.cyan' },
        TodoBgNOTE = { fg = 'palette.bg1', bg = 'palette.magenta' },
        TodoFgNOTE = { fg = 'palette.magenta' },
        TodoBgTEST = { fg = 'palette.bg1', bg = 'palette.cyan' },
        TodoFgTEST = { fg = 'palette.cyan' },

      },
    },
  },
}
