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
        blue    = { base = '#429cbf', dim = '#e1eff2' },
        cyan    = { base = '#56949f', dim = '#c9d7d6' },
        green   = { base = '#9ab582', dim = '#e6ead7' },
        magenta = { base = '#907aa9', dim = '#e5dcdf' },
        orange  = { base = '#db926d', dim = '#f1d7c7' },
        pink    = { base = '#d685af', dim = '#f3dee1' },
        red     = { base = '#b4637a', dim = '#e5c9cb' },
        white   = { base = '#e5e9f0', dim = '#f4f1ee' },
        yellow  = { base = '#e5bb67', dim = '#f4e3c5' },

        comment = '#9893a5',

        bg0     = '#ebe5df', -- Dark bg (status line and float)
        bg1     = '#faf4ed', -- Default bg
        bg2     = '#e5e2de', -- Lighter bg (colorcolm folds)
        bg3     = '#d8d5d2', -- Lighter bg (cursor line)
        bg4     = '#bdbfc9', -- Conceal, border fg

        fg0     = '#4c4769', -- Lighter fg
        fg1     = '#575279', -- Default fg
        fg2     = '#625c87', -- Darker fg (status line)
        fg3     = '#a8a3b3', -- Darker fg (line numbers, fold colums)

        sel0    = '#d0d8d8', -- Popup bg, visual selection bg
        sel1    = '#b8cece', -- Popup sel bg, search bg
      },
      nordfox = {
        black   = { base = '#3b4252', dim = '#313744' },
        blue    = { base = '#81a1c1', dim = '#3f4a5a' },
        cyan    = { base = '#88c0d0', dim = '#40505d' },
        green   = { base = '#a3be8c', dim = '#45504f' },
        magenta = { base = '#b48ead', dim = '#494656' },
        orange  = { base = '#c9826b', dim = '#4d4449' },
        pink    = { base = '#bf88bc', dim = '#4b4559' },
        red     = { base = '#bf616a', dim = '#4b3d48' },
        white   = { base = '#e5e9f0', dim = '#535863' },
        yellow  = { base = '#ebcb8b', dim = '#54524f' },

        comment = '#60728a',

        bg0     = '#232831', -- Dark bg (status line and float)
        bg1     = '#2e3440', -- Default bg
        bg2     = '#39404f', -- Lighter bg (colorcolm folds)
        bg3     = '#444c5e', -- Lighter bg (cursor line)
        bg4     = '#5a657d', -- Conceal, border fg

        fg0     = '#c7cdd9', -- Lighter fg
        fg1     = '#cdcecf', -- Default fg
        fg2     = '#abb1bb', -- Darker fg (status line)
        fg3     = '#7e8188', -- Darker fg (line numbers, fold colums)

        sel0    = '#3e4a5b', -- Popup bg, visual selection bg
        sel1    = '#4f6074', -- Popup sel bg, search bg
      },
    },
    groups = {
      all = {
        ---------------------| base |-----------------------

        ['@key'] = { fg = 'palette.comment', bg = 'none', style = 'italic' },

        Special = { fg = 'palette.orange', bg = 'none' },
        Number = { fg = 'palette.pink', bg = 'none' },
        PreProc = { fg = 'palette.red', bg = 'none' },
        Conditional = { link = 'Keyword' },
        String = { fg = 'palette.green', bg = 'none' },
        Type = { fg = 'palette.orange', bg = 'none' },
        Keyword = { fg = 'palette.magenta', bg = 'none' },
        MatchParen = { fg = 'palette.blue', bg = 'palette.blue.dim' },
        Title = { fg = 'palette.comment', bg = 'none', style = 'bold' },
        Function = { fg = 'palette.blue', bg = 'none' },
        Identifier = { fg = 'palette.green', bg = 'none' },
        ['@type'] = { fg = 'palette.orange' },
        ['@type.builtin'] = { fg = 'palette.yellow' },
        ['@module'] = { fg = 'palette.cyan' },
        ['@property'] = { link = '@key' },
        ['@variable.parameter'] = { link = '@property' },
        ['@function'] = { fg = 'palette.blue', style = 'underline,bold' },
        ['@function.call'] = { fg = 'palette.blue', style = 'NONE' },
        ['@function.method.call'] = { link = '@function.call' },
        ['@class'] = { fg = 'palette.orange', style = 'underline,bold' },
        ['Constant'] = { fg = 'palette.red' },
        ['@constant'] = { link = 'Constant', },
        ['@constant.builtin'] = { fg = 'palette.orange' },
        ['@constant.assignment'] = { fg = 'palette.red', style = 'underline,bold' },
        ['@string.regexp'] = { fg = 'palette.pink', bg = 'none' },
        ['@string.escape'] = { fg = 'palette.magenta.bright', bg = 'none', style = 'bold' },
        ['@tag.attribute'] = { link = '@key' },
        ['@punctuation.special'] = { fg = 'palette.comment' },
        ['@punctuation.delimiter'] = { fg = 'palette.cyan.dim' },
        ['@punctuation.bracket'] = { fg = 'palette.cyan.dim' },

        -- MsgArea
        MsgArea = { link = 'MsgAreaMsg' },
        MsgAreaCmd = { fg = 'palette.fg1', style = 'NONE' },
        MsgAreaMsg = { link = 'Comment' },
        MsgSeparator = { link = 'WinSeparator' },
        MoreMsg = { fg = 'palette.comment', bg = 'none', style = 'bold' },

        -- quickfix
        qfText = { link = '@normal' },
        qfLineNr = { fg = 'palette.comment' },
        QuickFixLine = { link = 'Search' },

        -- folds
        Folded = { link = 'Comment' },
        FoldColumn = { link = 'SignColumn' },
        CursorLineNr = { link = 'CursorLine' },

        -- diagnostics
        DiagnosticPass = { fg = 'palette.green', bg = 'palette.green.dim' },
        DiagnosticMixed = { fg = 'palette.yellow', bg = 'palette.yellow.dim' },
        DiagnosticFail = { fg = 'palette.red', bg = 'palette.red.dim' },
        DiagnosticPending = { fg = 'palette.blue', bg = 'palette.blue.dim' },
        DiagnosticVirtualTextHint = { fg = 'palette.comment', bg = 'palette.bg0' },
        DiagnosticVirtualTextInfo = { fg = 'palette.blue', bg = 'palette.blue.dim' },

        -- LSP
        LspSignatureActiveParameter = { fg = 'none', bg = 'palette.sel1', sp = 'palette.blue', style = 'underline' },

        -- floats
        NormalFloat = { fg = 'none', bg = 'palette.bg0' },
        FloatBorder = { fg = 'palette.bg0', bg = 'palette.bg0' },
        FloatTitle = { fg = 'palette.fg0', bg = 'palette.bg0', style = 'bold' },
        FloatFooter = { fg = 'palette.fg1', bg = 'palette.bg1' },

        -- winseparator
        WinSeparator = { fg = 'palette.bg0', bg = 'none' },

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
        ['@markup.raw.block'] = { fg = 'palette.yellow', bg = 'none' },
        ['@markup.heading.1'] = { fg = 'palette.pink' },
        ['@markup.heading.2'] = { fg = 'palette.green' },
        ['@markup.heading.3'] = { fg = 'palette.blue' },
        ['@markup.heading.4'] = { fg = 'palette.yellow' },
        ['@markup.heading.5'] = { fg = 'palette.cyan' },
        ['@markup.heading.6'] = { fg = 'palette.magenta' },

        ---------------| Language specific |----------------

        -- vimdoc
        ['@variable.parameter.vimdoc'] = { fg = 'palette.fg3' },

        -- shells
        ['@variable.parameter.bash'] = { link = '@normal' },
        ['@operator.bash'] = { link = 'Keyword' },
        ['@operator.fish'] = { link = 'Keyword' },
        ['@keyword.operator.fish'] = { link = '@operator.fish' },

        -- lua
        ['@constructor.lua'] = { link = '@punctuation.bracket' },
        ['@variable.member.lua'] = { link = '@normal' },
        ['@variable.parameter.lua'] = { link = '@normal' },
        ['@keyword.operator.lua'] = { link = '@keyword' },
        ['@keyword.luadoc'] = { link = '@constant' },
        ['@keyword.function.luadoc'] = { link = '@function.call' },
        ['@type.builtin.luadoc'] = { link = '@type' },
        ['@keyword.import.luadoc'] = { link = '@keyword.luadoc' },
        ['@keyword.return.luadoc'] = { link = '@keyword.luadoc' },
        ['@variable.member.luadoc'] = { link = '@key' },
        ['@variable.parameter.luadoc'] = { link = '@key' },
        ['@function.macro.luadoc'] = { link = '@type' },

        -- make
        ['@function.builtin.make'] = { link = 'makeConfig' },
        ['@function.make'] = { fg = 'palette.blue', bg = 'none', style = 'NONE' },
        ['@operator.make'] = { fg = 'palette.comment', bg = 'none' },
        ['makeSpecTarget'] = { link = 'PreProc' },

        -- ruby
        ['@variable.key.ruby'] = { link = '@key' },
        ['@variable.member.ruby'] = { fg = 'palette.magenta' },
        ['@variable.parameter.ruby'] = { link = '@normal' },
        ['@string.special.symbol.ruby'] = { link = '@string.ruby' },
        ['@operator.ruby'] = { fg = 'palette.comment', bg = 'none' },
        ['@punctuation.special.ruby'] = { fg = 'palette.comment' },

        -- TS
        ['@variable.member.tsx'] = { fg = 'palette.comment' },

        -- SQL
        ['@keyword.sql'] = { fg = 'palette.magenta' },
        ['@keyword.operator.sql'] = { link = '@keyword.sql' },
        ['@variable.sql'] = { fg = 'palette.fg1', bg = 'none', style = 'italic' },
        ['@variable.member.sql'] = { fg = 'palette.fg0', bg = 'none' },
        ['@type.sql'] = { fg = 'palette.orange', bg = 'none' },

        -- yaml
        ['@property.yaml'] = { link = '@key' },

        -- go
        ['@variable.parameter.go'] = { fg = 'palette.fg0' },
        ['@variable.member.go'] = { fg = 'palette.fg0' },

        -- css / scss
        ['@constructor.css'] = { fg = 'palette.orange' },
        ['@constructor.scss'] = { link = '@constructor.css' },
        ['@field.css'] = { fg = 'palette.comment' },
        ['@field.scss'] = { link = '@field.css' },
        ['@operator.css'] = { link = '@tag.css' },
        ['@operator.scss'] = { link = '@tag.css' },
        ['@property.css'] = { fg = 'palette.comment' },
        ['@property.scss'] = { link = '@property.css' },
        ['@tag.css'] = { fg = 'palette.orange' },
        ['@tag.scss'] = { link = '@tag.css' },
        ['@type.css'] = { fg = 'palette.magenta' },
        ['@type.scss'] = { link = '@type.css' },
        ['@variable.parameter.css'] = { fg = 'palette.magenta' },
        ['@variable.parameter.scss'] = { link = '@variable.parameter.css' },
        ['@function.css'] = { link = '@function.call' },
        ['@function.scss'] = { link = '@function.call' },

        -- html
        ['@tag.delimiter.html'] = { fg = 'palette.comment' },

        -- rasi
        ['@namespace.rasi'] = { link = '@constructor.css' },
        ['@field.rasi'] = { link = '@field.css' },
        ['@variable.rasi'] = { fg = 'palette.magenta' },
        ['@keyword.rasi'] = { fg = 'palette.pink' },
        ['@punctuation.special.rasi'] = { fg = 'palette.magenta' },

        -- kitty
        kittySt = { link = 'String' },

        -- man pages
        manHeader = { link = 'Title' },
        manFooter = { link = 'manHeader' },
        manOptionDesc = { fg = 'palette.magenta' },
        manSectionHeading = { link = 'MarkViewHeading1' },
        manSubHeading = { link = 'MarkViewHeading2' },

        ----------------------| plugins |----------------------

        Directory = { fg = 'palette.blue', bg = 'none' },
        OilDir = { link = 'Directory' },
        OilDirIcon = { link = 'OilDir' },
        OilCreate = { fg = 'palette.green' },
        OilDelete = { fg = 'palette.red' },
        OilTrash = { link = 'OilDelete' },
        OilPurge = { link = 'OilDelete' },
        OilChange = { fg = 'palette.yellow' },
        OilMove = { fg = 'palette.yellow' },

        HarpoonLine = { fg = 'palette.green', bg = 'none', style = 'bold' },

        TreesitterContext = { bg = 'palette.bg0', style = 'italic' },
        TreesitterContextBottom = { link = 'TreesitterContext' },
        TreesitterContextLineNumber = { fg = 'palette.fg0', bg = 'palette.bg0', style = 'italic' },
        TreesitterContextSeparator = { fg = 'palette.bg0', bg = 'palette.bg0' },

        TelescopeNormal = { link = 'NormalFloat' },
        TelescopeBorder = { link = 'FloatBorder' },
        TelescopeTitle = { fg = 'palette.fg3', bg = 'none', style = 'bold' },
        TelescopePreviewBorder = { link = 'FloatBorder' },
        TelescopePreviewTitle = { fg = 'palette.fg3', style = 'bold' },
        TelescopePromptNormal = { fg = 'palette.bg1', bg = 'palette.fg1' },
        TelescopePromptBorder = { link = 'TelescopePromptTitle' },
        TelescopePromptTitle = { fg = 'palette.fg1', bg = 'palette.fg1' },
        TelescopePromptPrefix = { fg = 'palette.bg1', bg = 'palette.fg1' },
        TelescopePromptCounter = { link = 'TelescopePromptPrefix' },
        TelescopeSelection = { link = 'CursorLine' },
        TelescopeSelectionCaret = { link = 'TelescopeSelection' },
        TelescopeMatching = { fg = 'palette.green' },
        TelescopeMultiSelection = { fg = 'palette.orange' },
        TelescopeMultiIcon = { link = 'TelescopeMultiSelection' },
        TelescopeResultsDiffAdd = { fg = 'palette.green' },
        TelescopeResultsDiffDelete = { fg = 'palette.red' },
        TelescopeResultsDiffChange = { fg = 'palette.yellow' },
        TelescopeResultsIdentifier = { link = 'Normal' },

        LazyH1 = { fg = 'palette.green', bg = 'palette.green.dim' },
        LazySpecial = { fg = 'palette.comment' },
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
        LualineTablineActiveAlt = { fg = 'palette.fg1', bg = 'palette.bg1', style = 'bold' },
        LualineTablineInactive = { fg = 'palette.fg1', bg = 'palette.bg0' },
        LualineExecutable = { fg = 'palette.green', bg = 'none' },

        FidgetGroup = { fg = 'palette.orange', bg = 'palette.bg0', style = 'bold,italic' },
        FidgetNormal = { fg = 'palette.fg1', bg = 'palette.bg0' },
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
        MarkviewListItemPlus = { fg = 'palette.blue.dim', bg = 'none' },
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
        MarkviewCheckboxStriked = { fg = 'palette.comment', bg = 'none', style = 'strikethrough' },
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
        fugitiveSection = { fg = 'palette.comment' },
        fugitiveHelpTag = { fg = 'palette.blue', bg = 'none' },
        fugitiveSymbolicRef = { link = '@git.branch' },
        fugitiveStagedModifier = { fg = 'palette.green' },
        fugitiveUnstagedModifier = { fg = 'palette.yellow' },
        fugitiveUntrackedModifier = { fg = 'palette.red' },
        fugitiveHeading = { fg = 'palette.magenta', style = 'bold' },
        fugitiveStagedHeading = { fg = 'palette.green', style = 'bold' },
        fugitiveUnstagedHeading = { fg = 'palette.yellow', style = 'bold' },
        fugitiveUntrackedHeading = { fg = 'palette.red', style = 'bold' },
        fugitiveHash = { link = '@constant.git_rebase' },
        gvSha = { link = '@constant.git_rebase' },
        gvDate = { fg = 'palette.green' },
        gvAuthor = { fg = 'palette.blue' },
        gvMessage = { fg = 'palette.comment', style = 'italic' },
        gvTag = { fg = 'palette.orange', style = 'bold' },
        gvMeta = { link = 'gvTag' },
        ['@markup.heading.gitcommit'] = { fg = 'palette.green', bg = 'none' },
        ['@text.reference.gitcommit'] = { link = '@markup.link.gitcommit' },
        ['@text.uri.gitcommit'] = { fg = 'palette.fg1', bg = 'none' },
        ['@string.special.path.gitcommit'] = { fg = 'palette.magenta', bg = 'none' },
        ['@keyword.gitcommit'] = { fg = 'palette.orange', bg = 'none' },
        ['@markup.heading.git_config'] = { fg = 'palette.orange', bg = 'none' },
        ['@git.branch'] = { fg = 'palette.magenta', bg = 'palette.magenta.dim' },
        ['@git.title.committed'] = { fg = 'palette.green', bg = 'none', style = 'bold' },
        ['@git.title.not_committed'] = { fg = 'palette.yellow', bg = 'none', style = 'bold' },
        ['@git.title.untracked'] = { fg = 'palette.red', bg = 'none', style = 'bold' },
        ['@git.change.deleted'] = { fg = 'palette.comment', bg = 'none' },
        ['@git.change.modified'] = { fg = 'palette.comment', bg = 'none' },
        ['@git.change.new'] = { fg = 'palette.comment', bg = 'none' },
        ['@git.change.deleted.filepath'] = { fg = 'palette.red', bg = 'none' },
        ['@git.change.modified.filepath'] = { fg = 'palette.yellow', bg = 'none' },
        ['@git.change.new.filepath'] = { fg = 'palette.green', bg = 'none' },
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
        ['@constant.git_rebase'] = { fg = 'palette.magenta', style = 'italic' },
        ['@none.git_rebase'] = { fg = 'palette.comment' },
        ['@string.special.path.gitignore'] = { fg = 'palette.blue' },
        ['@punctuation.delimiter.gitignore'] = { fg = 'palette.comment' },
        ['@character.special.gitignore'] = { fg = 'palette.orange' },

        DiffAdd = { bg = 'palette.green.dim' },
        DiffDelete = { bg = 'palette.red.dim' },
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
        GitSignsCurrentLineBlame = { fg = 'palette.comment', bg = 'palette.bg0', style = 'italic' },

        CmpGhostText = { fg = 'palette.cyan.dim' },
        CmpItemAbbr = { fg = 'palette.comment' },
        CmpItemAbbrMatch = { fg = 'palette.green' },
        CmpItemAbbrMatchFuzzy = { link = 'CmpItemAbbrMatch' },
        CmpItemKind = { fg = 'palette.comment' },
        CmpItemKindSnippet = { link = 'CmpItemKind' },
        CmpItemKindCopilot = { link = 'CmpItemKind' },
        CmpItemKindVariable = { link = 'CmpItemKind' },
        CmpItemKindEnum = { link = 'CmpItemKind' },
        CmpItemKindEnumMember = { link = 'CmpItemKind' },
        CmpItemKindFile = { link = 'CmpItemKind' },
        CmpItemKindText = { link = 'CmpItemKind' },
        CmpItemKindField = { link = 'CmpItemKind' },
        CmpItemKindProperty = { link = 'CmpItemKind' },
        CmpItemKindModule = { link = 'CmpItemKind' },
        CmpItemKindDirectory = { link = 'CmpItemKind' },
        CmpItemKindFolder = { link = 'CmpItemKind' },
        CmpItemKindKeyword = { link = 'CmpItemKind' },
        CmpItemKindFunction = { link = 'CmpItemKind' },
        CmpItemKindMethod = { link = 'CmpItemKind' },

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

        ExchangeRegion = { fg = 'palette.bg1', bg = 'palette.orange' },

      },
    },
  },
  config = function(_, opts)
    require('nightfox').setup(opts)

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function(args)
        local palette = require('nightfox.palette').load(args.match)
        require('nvim-web-devicons').set_default_icon('', palette.comment, 0)
      end,
      group = vim.api.nvim_create_augroup('nightfox_group', {})
    })
  end,
}
