return {
  'EdenEast/nightfox.nvim',
  lazy = false,
  opts = {
    options = {
      transparent = false,
      dim_inactive = false,
      styles = {
        strings = 'italic',
        comments = 'italic',
      },
    },
    palettes = {
      dawnfox = {
        black   = { base = '#575279', dim = '#c9c3ca' },
        blue    = { base = '#3385a5', dim = '#bed3d7' },
        cyan    = { base = '#56949f', dim = '#c9d7d6' },
        green   = { base = '#82a561', dim = '#c7ceb6' },
        magenta = { base = '#907aa9', dim = '#ccc1cb' },
        orange  = { base = '#ea9d34', dim = '#f5dab6' },
        pink    = { base = '#d7827e', dim = '#f0d2cc' },
        red     = { base = '#b4637a', dim = '#d6babd' },
        white   = { base = '#e5e9f0', dim = '#e5e2e1' },
        yellow  = { base = '#d3a634', dim = '#eeddb6' },

        comment = '#797593',

        fg      = {
          base   = '#575279',
          dim    = '#797593',
          dimmer = '#9d9aa5',
        },

        bg0     = '#f2e9e1', -- Dark bg (status line and float)
        bg1     = '#faf4ed', -- Default bg
        bg2     = '#fffaf3', -- Lighter bg (colorcolm folds)
        bg3     = '#dbdee0', -- Lighter bg (cursor line)
        bg4     = '#bdbfc9', -- Conceal, border fg

        fg0     = '#797593', -- Lighter fg
        fg1     = '#575279', -- Default fg
        fg2     = '#625c87', -- Darker fg (status line)
        fg3     = '#a8a3b3', -- Darker fg (line numbers, fold colums)

        sel0    = '#dfdad9', -- Popup bg, visual selection bg
        sel1    = '#cecacd', -- Popup sel bg, search bg
      },
      nordfox = {
        black   = { base = '#3b4252', dim = '#313744' },
        blue    = { base = '#81a1c1', dim = '#3f4a5a' },
        cyan    = { base = '#9fbec6', dim = '#45505b' },
        green   = { base = '#a3be8c', dim = '#45504f' },
        magenta = { base = '#a289bf', dim = '#454559' },
        orange  = { base = '#d89715', dim = '#504837' },
        pink    = { base = '#d8847f', dim = '#50444d' },
        red     = { base = '#bf616a', dim = '#4b3d48' },
        white   = { base = '#e5e9f0', dim = '#535863' },
        yellow  = { base = '#ebcb8b', dim = '#54524f' },

        comment = '#60728a',

        fg      = {
          base   = '#b0b1b2',
          dim    = '#60728a',
          dimmer = '#4a5468',
        },

        bg0     = '#232831', -- Dark bg (status line and float)
        bg1     = '#2e3440', -- Default bg
        bg2     = '#39404f', -- Lighter bg (colorcolm folds)
        bg3     = '#444c5e', -- Lighter bg (cursor line)
        bg4     = '#5a657d', -- Conceal, border fg

        fg0     = '#c7cdd9', -- Lighter fg
        fg1     = '#b0b1b2', -- Default fg
        fg2     = '#abb1bb', -- Darker fg (status line)
        fg3     = '#7e8188', -- Darker fg (line numbers, fold colums)

        sel0    = '#3e4a5b', -- Popup bg, visual selection bg
        sel1    = '#4f6074', -- Popup sel bg, search bg
      },
    },
    groups = {
      all = {
        -- ------------------| base |-----------------------

        SpellRare = { style = 'NONE' },
        SpellLocal = { style = 'NONE' },

        MatchParen = { fg = 'palette.blue', bg = 'palette.blue.dim' },

        Comment = { fg = 'palette.cyan', style = 'italic' },
        Documentation = { fg = 'palette.cyan', bg = 'palette.cyan.dim', style = 'italic' },

        Constant = { fg = 'palette.fg.base' },
        String = { fg = 'palette.green', style = 'NONE' },
        Character = { link = 'String' },
        Boolean = { link = 'String' },
        Number = { link = 'String' },
        Float = { link = 'Number' },

        Identifier = { fg = 'palette.fg.base' },
        Function = { link = 'Identifier', },

        Statement = { fg = 'palette.fg.base' },
        Keyword = { fg = 'palette.fg.dimmer' },
        Exception = { link = 'Keyword' },
        Conditional = { link = 'Keyword' },
        Repeat = { link = 'Conditional' },
        Label = { link = 'Conditional' },
        Operator = { fg = 'palette.fg.dimmer' },

        PreProc = { fg = 'palette.fg.dim' },
        Include = { link = 'PreProc' },
        Define = { link = 'PreProc' },
        Macro = { link = 'PreProc' },
        PreCondit = { link = 'PreProc' },

        Type = { fg = 'palette.yellow' },
        StorageClass = { link = 'Type' },
        Structure = { link = 'Type' },
        Typedef = { link = 'Type' },

        Special = { fg = 'palette.orange', },
        SpecialChar = { link = 'Special' },
        Tag = { link = 'Special' },
        Delimiter = { link = 'Special' },
        SpecialComment = { link = 'Special' },
        Debug = { link = 'Special' },

        Error = { fg = 'palette.red' },
        Todo = { fg = 'palette.bg1', bg = 'palette.yellow', style = 'bold' },

        Added = { fg = 'palette.green' },
        Changed = { fg = 'palette.yellow' },
        Removed = { fg = 'palette.red' },

        Title = { fg = 'palette.fg.dim', style = 'bold' },
        Whitespace = { fg = 'palette.fg.dimmer' },

        ['@comment'] = { link = 'Comment' },
        ['@comment.documentation'] = { link = 'Documentation' },


        ['@string.special.url'] = { link = '@markup.link' },

        ['@character.special'] = { fg = 'palette.fg.dim' },

        ['@string.escape'] = { fg = 'palette.magenta.bright', style = 'bold' },
        ['@string.regexp'] = { fg = 'palette.green', style = 'NONE' },
        ['@operator.regex'] = { fg = 'palette.green.dim', style = 'bold' },

        ['@type.builtin'] = { link = 'Type' },

        ['@module'] = { fg = 'palette.blue' },
        ['@module.builtin'] = { fg = 'palette.fg.base' },

        ['@property'] = { fg = 'palette.fg.dim' },
        ['@variable'] = { fg = 'palette.fg.base' },
        ['@variable.key'] = { fg = 'palette.fg.dim', style = 'italic' },
        ['@variable.parameter'] = { link = '@variable' },
        ['@variable.member'] = { link = '@variable' },
        ['@variable.builtin'] = { fg = 'palette.pink' },

        ['@function'] = { fg = 'palette.fg.base', style = 'underline,bold' },
        ['@function.call'] = { fg = 'palette.fg.base', style = 'NONE' },
        ['@function.method.call'] = { link = '@function.call' },
        ['@function.builtin'] = { link = '@function.call' },

        ['@class'] = { fg = 'palette.yellow', style = 'underline,bold' },
        ['@constant'] = { fg = 'palette.fg.base', },
        ['@constant.builtin'] = { link = '@variable.builtin' },
        ['@constant.assignment'] = { fg = 'palette.fg.base', style = 'underline,bold' },

        ['@operator'] = { fg = 'palette.fg.dimmer' },

        ['@tag.attribute'] = { fg = 'palette.fg.dim' },
        ['@tag.delimiter'] = { link = '@operator' },

        ['@punctuation.special'] = { fg = 'palette.fg.dim' },
        ['@punctuation.delimiter'] = { link = '@operator' },
        ['@punctuation.bracket'] = { link = '@operator' },

        ['@keyword'] = { fg = 'palette.fg.dimmer' },
        ['@keyword.operator'] = { link = '@keyword' },
        ['@keyword.function'] = { link = '@keyword' },
        ['@keyword.exception'] = { link = '@keyword' },
        ['@keyword.return'] = { fg = 'palette.red', bg = 'palette.red.dim' },
        ['@keyword.next'] = { link = '@keyword.return' },
        ['@keyword.break'] = { link = '@keyword.return' },
        ['@keyword.raise'] = { link = '@keyword.return' },
        ['@keyword.conditional'] = { fg = 'palette.magenta', bg = 'palette.magenta.dim' },
        ['@keyword.repeat'] = { link = '@keyword.conditional' },

        -- MsgArea
        MsgArea = { link = 'MsgAreaMsg' },
        MsgAreaCmd = { fg = 'palette.fg.base', style = 'NONE' },
        MsgAreaMsg = { fg = 'palette.fg.dimmer' },
        MsgSeparator = { link = 'WinSeparator' },
        MoreMsg = { fg = 'palette.fg.dim', bg = 'none', style = 'bold' },

        -- quickfix
        qfText = { link = '@normal' },
        qfLineNr = { fg = 'palette.fg.dim' },
        QuickFixLine = { fg = 'palette.green' },

        -- folds
        Folded = { fg = 'palette.fg.dim' },
        FoldColumn = { link = 'SignColumn' },
        CursorLineNr = { link = 'CursorLine' },

        -- diagnostics
        DiagnosticPass = { fg = 'palette.green', bg = 'palette.green.dim' },
        DiagnosticMixed = { fg = 'palette.yellow', bg = 'palette.yellow.dim' },
        DiagnosticFail = { fg = 'palette.red', bg = 'palette.red.dim' },
        DiagnosticPending = { fg = 'palette.blue', bg = 'palette.blue.dim' },
        DiagnosticUnnecessary = { fg = 'palette.fg.dim', style = 'italic' },
        DiagnosticVirtualTextHint = { fg = 'palette.fg.dim', bg = 'palette.bg0' },
        DiagnosticVirtualTextInfo = { fg = 'palette.blue', bg = 'palette.blue.dim' },

        -- LSP
        LspSignatureActiveParameter = { fg = 'none', bg = 'palette.sel1', sp = 'palette.blue', style = 'underline' },

        -- floats
        NormalFloat = { fg = 'none', bg = 'palette.bg0' },
        FloatBorder = { fg = 'palette.bg0', bg = 'palette.bg0' },
        FloatTitle = { fg = 'palette.fg0', bg = 'palette.bg0', style = 'bold' },
        FloatFooter = { fg = 'palette.fg.base', bg = 'palette.bg1' },

        -- winseparator
        WinSeparator = { link = 'WinSeparatorThin' },
        WinSeparatorThin = { fg = 'palette.bg0', bg = 'none' },
        WinSeparatorThick = { fg = 'palette.bg0', bg = 'palette.bg0' },

        -- pmenu
        Pmenu = { fg = 'palette.fg.base', bg = 'palette.bg0' },
        PmenuSel = { bg = 'palette.sel0' },

        -- markup
        ['@markup.strong'] = { fg = 'none', style = 'bold' },
        ['@markup.italic'] = { fg = 'none', style = 'italic' },
        ['@markup.underline'] = { fg = 'none', style = 'underline' },
        ['@markup.quote'] = { fg = 'palette.fg.dim', style = 'italic' },
        ['@markup.link'] = { fg = 'palette.magenta', style = 'italic' },
        ['@markup.link.url'] = { link = '@markup.link' },
        ['@markup.link.label'] = { link = '@markup.link' },
        ['@markup.raw.markdown_inline'] = { fg = 'none', bg = 'none' },
        ['@markup.raw.block'] = { fg = 'palette.yellow', bg = 'none' },
        ['@markup.heading.1'] = { fg = 'palette.pink' },
        ['@markup.heading.2'] = { fg = 'palette.green' },
        ['@markup.heading.3'] = { fg = 'palette.blue' },
        ['@markup.heading.4'] = { fg = 'palette.yellow' },
        ['@markup.heading.5'] = { fg = 'palette.cyan' },
        ['@markup.heading.6'] = { fg = 'palette.magenta' },

        -- ------------| Language specific |----------------

        -- query
        ['@function.call.query'] = { fg = 'palette.blue' },
        ['@comment.query'] = { fg = 'palette.fg.dimmer' },
        ['@keyword.directive.query'] = { fg = 'palette.fg.dim' },
        ['@variable.query'] = { fg = 'palette.pink' },

        -- lua
        ['@constructor.lua'] = { link = '@punctuation.bracket' },
        ['@keyword.operator.lua'] = { link = '@keyword' },
        ['@comment.documentation.lua'] = { fg = 'palette.fg.dimmer', bg = 'palette.bg0' },

        ['@comment.luadoc'] = { link = '@comment.documentation.lua' },
        ['@keyword.luadoc'] = { fg = 'palette.fg.dim', style = 'bold' },
        ['@keyword.function.luadoc'] = { link = '@type' },
        ['@keyword.import.luadoc'] = { link = '@keyword.luadoc' },
        ['@keyword.return.luadoc'] = { link = '@keyword.luadoc' },

        -- make
        ['@function.builtin.make'] = { link = 'makeConfig' },
        ['@function.make'] = { fg = 'palette.blue', bg = 'none', style = 'NONE' },
        ['@operator.make'] = { fg = 'palette.fg.dim', bg = 'none' },
        ['makeSpecial'] = { fg = 'palette.fg.dimmer' },
        ['makeCommands'] = { fg = 'palette.fg.base' },
        ['makeTarget'] = { fg = 'palette.blue' },
        ['makeSpecTarget'] = { fg = 'palette.fg.dimmer' },
        ['makePreCondit'] = { link = '@keyword.conditional' },
        ['makeStatement'] = { fg = 'palette.magenta' },
        ['makeDefine'] = { link = '@keyword' },

        -- ruby
        ['@comment.directive'] = { fg = 'palette.fg.dimmer', bg = 'palette.bg1' },
        ['@string.special.symbol.ruby'] = { link = '@string.ruby' },
        ['@operator.ternary.ruby'] = { link = '@keyword.conditional.ruby' },
        ['@punctuation.special.ruby'] = { fg = 'palette.fg.dim' },
        ['@function.builtin.ruby'] = { link = '@keyword' },

        -- SQL
        ['@keyword.sql'] = { fg = 'palette.magenta' },
        ['@keyword.operator.sql'] = { link = '@keyword.sql' },
        ['@variable.member.sql'] = { link = '@variable' },

        -- yaml
        ['@property.yaml'] = { link = '@variable' },

        -- CSS
        ['@attribute.css'] = { fg = 'palette.fg.dim' },
        ['@tag.attribute.css'] = { link = '@attribute.css' },
        ['@field.css'] = { link = '@attribute.css' },
        ['@property.css'] = { fg = 'palette.fg.dimmer' },
        ['@character.special.css'] = { fg = 'palette.fg.dim' },
        ['@keyword.directive.css'] = { fg = 'palette.blue' },
        ['@constructor.css'] = { fg = 'palette.orange' },
        ['@tag.css'] = { link = '@type' },
        ['@type.css'] = { fg = 'palette.magenta' },
        ['@constant.css'] = { link = '@type.css' },
        ['@function.css'] = { link = '@function.call' },

        -- xresources
        ['@character.special.xresources'] = { link = '@variable' },
        ['@constant.macro.xresources'] = { link = '@variable' },
        ['@markup.raw.xresources'] = { link = 'String' },
        ['@keyword.import.xresources'] = { fg = 'palette.fg.base' },
        ['@keyword.directive.define.xresources'] = { link = '@keyword.import.xresources' },

        -- rasi
        ['@namespace.rasi'] = { link = '@constructor.css' },
        ['@field.rasi'] = { link = '@field.css' },
        ['@variable.rasi'] = { fg = 'palette.magenta' },
        ['@keyword.rasi'] = { fg = 'palette.pink' },
        ['@constant.rasi'] = { fg = 'palette.yellow' },
        ['@punctuation.special.rasi'] = { fg = 'palette.magenta' },

        -- kitty
        kittySt = { link = 'String' },
        kittyKeyword = { fg = 'palette.fg.base' },

        -- zathurarc
        ['@variable.builtin.zathurarc'] = { link = '@variable' },

        -- man pages
        manHeader = { link = 'Title' },
        manFooter = { link = 'manHeader' },
        manOptionDesc = { fg = 'palette.magenta' },
        manSectionHeading = { link = 'MarkViewHeading1' },
        manSubHeading = { link = 'MarkViewHeading2' },

        -- -------------------| plugins |----------------------

        Directory = { fg = 'palette.blue', bg = 'none' },
        OilDir = { link = 'Directory' },
        OilDirHidden = { link = 'OilDir' },
        OilDirIcon = { link = 'OilDir' },
        OilCreate = { link = 'Added' },
        OilDelete = { link = 'Removed' },
        OilTrash = { link = 'OilDelete' },
        OilPurge = { link = 'OilDelete' },
        OilChange = { link = 'Changed' },
        OilMove = { link = 'OilChange' },

        HarpoonLine = { link = 'QuickFixLine' },

        TreesitterContext = { bg = 'palette.bg0', style = 'italic' },
        TreesitterContextBottom = { link = 'TreesitterContext' },
        TreesitterContextLineNumber = { fg = 'palette.fg0', bg = 'palette.bg0', style = 'italic' },
        TreesitterContextSeparator = { fg = 'palette.bg0', bg = 'palette.bg0' },

        TelescopeNormal = { link = 'NormalFloat' },
        TelescopeBorder = { link = 'FloatBorder' },
        TelescopeTitle = { fg = 'palette.fg3', bg = 'none', style = 'bold' },
        TelescopePreviewBorder = { link = 'FloatBorder' },
        TelescopePreviewTitle = { fg = 'palette.fg3', style = 'bold' },
        TelescopePromptNormal = { fg = 'palette.bg1', bg = 'palette.fg.base' },
        TelescopePromptBorder = { link = 'TelescopePromptTitle' },
        TelescopePromptTitle = { fg = 'palette.fg.base', bg = 'palette.fg.base' },
        TelescopePromptPrefix = { fg = 'palette.bg1', bg = 'palette.fg.base' },
        TelescopePromptCounter = { link = 'TelescopePromptPrefix' },
        TelescopeSelection = { link = 'CursorLine' },
        TelescopeSelectionCaret = { link = 'TelescopeSelection' },
        TelescopeMatching = { fg = 'palette.green' },
        TelescopeMultiSelection = { fg = 'palette.orange' },
        TelescopeMultiIcon = { link = 'TelescopeMultiSelection' },
        TelescopeResultsComment = { fg = 'palette.fg.dimmer', style = 'italic' },
        TelescopeResultsDiffAdd = { link = 'Added' },
        TelescopeResultsDiffDelete = { link = 'Removed' },
        TelescopeResultsDiffChange = { link = 'Changed' },
        TelescopeResultsIdentifier = { fg = 'palette.magenta', style = 'italic' },

        LazyH1 = { fg = 'palette.green', bg = 'palette.green.dim' },
        LazySpecial = { fg = 'palette.fg.dim' },
        LazyDimmed = { fg = 'palette.fg.dimmer' },
        LazyComment = { fg = 'palette.fg.dimmer' },
        LazyCommit = { link = 'fugitiveHash' },
        LazyCommitType = { fg = 'palette.blue', style = 'bold' },
        LazyButton = { fg = 'palette.fg2', bg = 'palette.bg1' },
        LazyButtonActive = { link = 'LazyH1' },
        LazyProgressDone = { fg = 'palette.green' },
        LazyReasonCmd = { fg = 'palette.blue' },
        LazyReasonEvent = { fg = 'palette.yellow' },
        LazyReasonFt = { fg = 'palette.cyan' },
        LazyReasonKeys = { fg = 'palette.pink' },
        LazyReasonPlugin = { fg = 'palette.red' },
        LazyReasonRequire = { fg = 'palette.magenta' },
        LazyReasonSource = { fg = 'palette.green' },
        LazyReasonStart = { fg = 'palette.green' },

        MasonHeader = { link = 'lazyH1' },
        MasonHighlight = { fg = 'palette.green', bg = 'none' },
        MasonHighlightBlock = { fg = 'palette.bg1', bg = 'palette.green.bright' },
        MasonHighlightBlockBold = { link = 'LazyButtonActive' },
        MasonMutedBlock = { link = 'LazyButton' },

        LualineAdded = { fg = 'palette.green' },
        LualineRemoved = { fg = 'palette.red' },
        LualineModified = { fg = 'palette.yellow' },
        LualineTablineActive = { fg = 'palette.bg1', bg = 'palette.blue' },
        LualineTablineActiveAlt = { fg = 'palette.fg.base', bg = 'palette.bg1', style = 'bold,underline' },
        LualineTablineInactive = { fg = 'palette.fg.base', bg = 'palette.bg0' },
        LualineExecutable = { fg = 'palette.green', bg = 'none' },
        LualineError = { fg = 'palette.red', bg = 'none' },
        LualineWarning = { fg = 'palette.yellow', bg = 'none' },

        FidgetGroup = { fg = 'palette.orange', bg = 'palette.bg0', style = 'bold,italic' },
        FidgetNormal = { fg = 'palette.fg.base', bg = 'palette.bg0' },
        FidgetBorder = { link = 'FidgetNormal' },
        NotifyDEBUGTitle = { fg = 'palette.magenta' },
        NotifyINFOTitle = { fg = 'palette.blue' },
        NotifyWARNTitle = { fg = 'palette.yellow' },
        NotifyERRORTitle = { fg = 'palette.red' },

        MarkSignHL = { fg = 'palette.fg0', bg = 'palette.bg0' },
        MarkSignNumHL = { link = 'MarkSignHL' },

        MarkviewCode = { fg = 'none', bg = 'palette.bg0' },
        MarkviewCodeLabel = { fg = 'palette.bg0', bg = 'palette.yellow', style = 'bold' },
        MarkviewInlineCode = { fg = 'none', bg = 'palette.bg0' },
        MarkviewHyperlink = { fg = 'palette.magenta', bg = 'none', style = 'italic' },
        MarkviewImage = { fg = 'palette.blue', bg = 'none', style = 'italic' },
        MarkviewBlockQuoteDefault = { fg = 'palette.fg0', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteError = { fg = 'palette.red', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteNote = { fg = 'palette.blue', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteOk = { fg = 'palette.green', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteSpecial = { fg = 'palette.yellow', bg = 'none', style = 'NONE' },
        MarkviewBlockQuoteWarn = { fg = 'palette.yellow', bg = 'none', style = 'NONE' },
        MarkviewHeading1 = { fg = 'palette.pink', bg = 'palette.pink.dim' },
        MarkviewHeading2 = { fg = 'palette.green', bg = 'none' },
        MarkviewHeading3 = { fg = 'palette.blue', bg = 'none' },
        MarkviewHeading4 = { fg = 'palette.yellow', bg = 'none' },
        MarkviewHeading5 = { fg = 'palette.cyan', bg = 'none' },
        MarkviewHeading6 = { fg = 'palette.magenta', bg = 'none' },
        MarkviewListItemMinus = { fg = 'palette.pink.dim', bg = 'none' },
        MarkviewListItemStar = { fg = 'palette.green.dim', bg = 'none' },
        MarkviewListItemPlus = { fg = 'palette.cyan.dim', bg = 'none' },
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
        MarkviewCheckboxStriked = { fg = 'palette.fg.dim', bg = 'none', style = 'strikethrough' },
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

        fugitiveHeader = { fg = 'palette.green', bg = 'none', style = 'bold' },
        fugitiveSection = { fg = 'palette.fg.dim' },
        fugitiveHelpTag = { fg = 'palette.blue', bg = 'none' },
        fugitiveSymbolicRef = { link = '@git.branch' },
        fugitiveStagedModifier = { fg = 'palette.green' },
        fugitiveUnstagedModifier = { fg = 'palette.yellow' },
        fugitiveUntrackedModifier = { fg = 'palette.red' },
        fugitiveHeading = { fg = 'palette.magenta', style = 'bold' },
        fugitiveStagedHeading = { fg = 'palette.green', style = 'bold' },
        fugitiveUnstagedHeading = { fg = 'palette.yellow', style = 'bold' },
        fugitiveUntrackedHeading = { fg = 'palette.red', style = 'bold' },
        fugitiveHash = { fg = 'palette.magenta', style = 'italic' },
        gvSha = { link = 'fugitiveHash' },
        gvDate = { fg = 'palette.green' },
        gvAuthor = { fg = 'palette.fg.dimmer' },
        gvMessage = { fg = 'palette.fg.dim', style = 'italic' },
        gvTag = { fg = 'palette.pink', style = 'bold' },
        gvMeta = { link = 'gvTag' },
        ['@comment.gitcommit'] = { fg = 'palette.fg.dimmer', bg = 'none' },
        ['@markup.heading.gitcommit'] = { fg = 'palette.fg.base', bg = 'none' },
        ['@text.reference.gitcommit'] = { link = '@markup.link.gitcommit' },
        ['@text.uri.gitcommit'] = { fg = 'palette.fg.base', bg = 'none' },
        ['@string.special.path.gitcommit'] = { fg = 'palette.magenta', bg = 'none' },
        ['@keyword.gitcommit'] = { fg = 'palette.orange', bg = 'none' },
        ['@markup.heading.git_config'] = { fg = 'palette.yellow' },
        ['@string.special.path.git_config'] = { link = '@string' },
        ['@git.branch'] = { fg = 'palette.magenta', bg = 'palette.magenta.dim' },
        ['@git.title.committed'] = { fg = 'palette.green', bg = 'none', style = 'bold' },
        ['@git.title.not_committed'] = { fg = 'palette.yellow', bg = 'none', style = 'bold' },
        ['@git.title.untracked'] = { fg = 'palette.red', bg = 'none', style = 'bold' },
        ['@git.change.deleted'] = { fg = 'palette.fg.dim', bg = 'none' },
        ['@git.change.modified'] = { fg = 'palette.fg.dim', bg = 'none' },
        ['@git.change.new'] = { fg = 'palette.fg.dim', bg = 'none' },
        ['@git.change.renamed'] = { fg = 'palette.fg.dim', bg = 'none' },
        ['@git.change.deleted.filepath'] = { fg = 'palette.red', bg = 'none' },
        ['@git.change.modified.filepath'] = { fg = 'palette.yellow', bg = 'none' },
        ['@git.change.new.filepath'] = { fg = 'palette.green', bg = 'none' },
        ['@git.change.renamed.filepath'] = { fg = 'palette.orange', bg = 'none' },
        ['@keyword.git_rebase.pick'] = { fg = 'palette.green' },
        ['@keyword.git_rebase.reword'] = { fg = 'palette.blue' },
        ['@keyword.git_rebase.edit'] = { fg = 'palette.blue' },
        ['@keyword.git_rebase.squash'] = { fg = 'palette.orange' },
        ['@keyword.git_rebase.fixup'] = { fg = 'palette.orange' },
        ['@keyword.git_rebase.exec'] = { fg = 'palette.pink' },
        ['@keyword.git_rebase.break'] = { fg = 'palette.pink' },
        ['@keyword.git_rebase.drop'] = { fg = 'palette.red' },
        ['@keyword.git_rebase.label'] = { fg = 'palette.pink' },
        ['@keyword.git_rebase.reset'] = { fg = 'palette.pink' },
        ['@keyword.git_rebase.merge'] = { fg = 'palette.pink' },
        ['@keyword.git_rebase.update-ref'] = { fg = 'palette.pink' },
        ['@keyword.git_rebase.invalid'] = { fg = 'palette.red', bg = 'palette.red.dim', style = 'undercurl' },
        ['@constant.git_rebase'] = { link = 'fugitiveHash' },
        ['@none.git_rebase'] = { fg = 'palette.fg.dim' },
        ['@string.special.path.gitignore'] = { link = '@normal' },
        ['@punctuation.delimiter.gitignore'] = { fg = 'palette.fg.dimmer' },
        ['@character.special.gitignore'] = { link = '@normal' },

        DiffAdd = { bg = 'palette.green.dim' },
        DiffDelete = { fg = 'palette.red.dim', bg = 'palette.red.dim' },
        DiffChange = { bg = 'palette.yellow.dim' },
        DiffText = { bg = 'palette.blue.dim' },

        GitSignsAdd = { fg = 'palette.green', bg = 'palette.green.dim' },
        GitSignsAddNr = { link = 'GitSignsAdd' },
        GitSignsAddLn = { fg = 'none', },
        GitSignsAddInline = { fg = 'none', bg = 'palette.green' },
        GitSignsAddInlineNr = { link = 'GitSignsAddInline' },
        GitSignsAddInlineLn = { fg = 'none', },
        GitSignsDelete = { fg = 'palette.red', bg = 'palette.red.dim' },
        GitSignsDeleteNr = { link = 'GitSignsDelete' },
        GitSignsTopDelete = { link = 'GitSignsDelete' },
        GitSignsTopDeleteNr = { link = 'GitSignsTopDelete' },
        GitSignsDeleteInline = { fg = 'none', bg = 'palette.red' },
        GitSignsDeleteInlineNr = { link = 'GitSignsDeleteInline' },
        GitSignsDeleteInlineLn = { fg = 'none', },
        GitSignsChange = { fg = 'palette.yellow', bg = 'palette.yellow.dim' },
        GitSignsChangeNr = { link = 'GitSignsChange' },
        GitSignsChangeLn = { fg = 'none', },
        GitSignsChangeInline = { fg = 'none', bg = 'palette.yellow' },
        GitSignsChangeInlineNr = { link = 'GitSignsChangeInline' },
        GitSignsChangeInlineLn = { fg = 'none', },
        GitSignsChangeDelete = { fg = 'palette.magenta', bg = 'palette.magenta.dim' },
        GitSignsChangeDeleteNr = { link = 'GitSignsChangeDelete' },
        GitSignsChangeDeleteLn = { fg = 'none', },
        GitSignsStagedAdd = { fg = 'palette.fg.dim', bg = 'palette.bg1' },
        GitSignsStagedAddNr = { link = 'GitSignsStagedAdd' },
        GitSignsStagedAddLn = { fg = 'none', bg = 'palette.bg1' },
        GitSignsStagedDelete = { fg = 'palette.fg.dim', bg = 'palette.bg1' },
        GitSignsStagedDeleteNr = { link = 'GitSignsStagedDelete' },
        GitSignsStagedTopDelete = { link = 'GitSignsStagedDelete' },
        GitSignsStagedTopDeleteNr = { link = 'GitSignsStagedDeleteNr' },
        GitSignsStagedChange = { fg = 'palette.fg.dim', bg = 'palette.bg1' },
        GitSignsStagedChangeNr = { link = 'GitSignsStagedChange' },
        GitSignsStagedChangeLn = { fg = 'none', bg = 'palette.bg0' },
        GitSignsStagedChangeDelete = { link = 'GitSignsStagedChange' },
        GitSignsStagedChangeDeleteNr = { link = 'GitSignsStagedChangeNr' },
        GitSignsStagedChangeDeleteLn = { link = 'GitSignsStagedChangeLn' },
        GitSignsCurrentLineBlame = { fg = 'palette.fg.dim', bg = 'palette.bg0', style = 'italic' },

        CmpGhostText = { fg = 'palette.fg.dimmer' },
        CmpItemAbbr = { fg = 'palette.fg.base' },
        CmpItemAbbrMatch = { fg = 'palette.green' },
        CmpItemAbbrMatchFuzzy = { link = 'CmpItemAbbrMatch' },
        CmpItemKind = { fg = 'palette.fg.dim' },
        CmpItemKindText = { fg = 'palette.fg.dimmer' },
        CmpItemKindSnippet = { link = 'CmpItemKind' },
        CmpItemKindCopilot = { link = 'CmpItemKind' },
        CmpItemKindVariable = { link = 'CmpItemKind' },
        CmpItemKindEnum = { link = 'CmpItemKind' },
        CmpItemKindEnumMember = { link = 'CmpItemKind' },
        CmpItemKindFile = { link = 'CmpItemKind' },
        CmpItemKindField = { link = 'CmpItemKind' },
        CmpItemKindProperty = { link = 'CmpItemKind' },
        CmpItemKindModule = { link = 'CmpItemKind' },
        CmpItemKindDirectory = { link = 'CmpItemKind' },
        CmpItemKindFolder = { link = 'CmpItemKind' },
        CmpItemKindKeyword = { link = 'CmpItemKind' },
        CmpItemKindFunction = { link = 'CmpItemKind' },
        CmpItemKindMethod = { link = 'CmpItemKind' },

        ['@keyword.import.ledger'] = { link = '@keyword' },
        ['@variable.member.ledger'] = { link = '@property' },
        ['@number.ledger'] = { fg = 'palette.green' },
        ['@number.negative.ledger'] = { fg = 'palette.red' },
        ['@markup.raw.ledger'] = { fg = 'palette.fg.dimmer' },
        ['@string.special.ledger'] = { fg = 'palette.pink', style = 'bold' },

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

        ExchangeRegion = { fg = 'palette.bg1', bg = 'palette.orange' },

        Cursorword = { fg = 'palette.bg1', bg = 'palette.pink' },
      },
    },
  },
  config = function(_, opts)
    require('nightfox').setup(opts)

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function(args)
        local palette = require('nightfox.palette').load(args.match)
        require('nvim-web-devicons').set_default_icon('', palette.fg.dim, 0)
      end,
      group = vim.api.nvim_create_augroup('nightfox_group', {})
    })
  end,
}
