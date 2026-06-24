return function(palette)
  vim.api.nvim_set_hl(0, 'Normal', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, 'NormalNC', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'NonText', { fg = palette.bg.dimmer })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { fg = palette.bg.base })
  vim.api.nvim_set_hl(0, 'Conceal', { link = 'NonText' })
  vim.api.nvim_set_hl(0, 'SpecialKey', { fg = palette.fg.dimmer })

  vim.api.nvim_set_hl(0, 'Underlined', { underline = true })
  vim.api.nvim_set_hl(0, 'Bold', { bold = true })
  vim.api.nvim_set_hl(0, 'Italic', { italic = true })

  vim.api.nvim_set_hl(0, 'Visual', { bg = palette.sel.base })
  vim.api.nvim_set_hl(0, 'VisualNOS', { link = 'Visual' })

  vim.api.nvim_set_hl(0, 'Cursor', { fg = palette.bg.base, bg = palette.accent.base })
  vim.api.nvim_set_hl(0, 'lCursor', { link = 'Cursor' })
  vim.api.nvim_set_hl(0, 'CursorIM', { link = 'Cursor' })
  vim.api.nvim_set_hl(0, 'TermCursor', { link = 'Cursor' })
  vim.api.nvim_set_hl(0, 'TermCursorNC', { link = 'Cursor' })

  vim.api.nvim_set_hl(0, 'SpellRare', {})
  vim.api.nvim_set_hl(0, 'SpellLocal', {})
  vim.api.nvim_set_hl(0, 'SpellBad', { sp = palette.red.base, undercurl = true })
  vim.api.nvim_set_hl(0, 'SpellCap', { sp = palette.yellow.base, undercurl = true })

  vim.api.nvim_set_hl(0, 'MatchParen', { fg = palette.blue.base, bg = palette.blue.dim })

  vim.api.nvim_set_hl(0, 'Comment', { fg = palette.blue.base, italic = true })
  vim.api.nvim_set_hl(0, 'Documentation', { fg = palette.blue.base, bg = palette.blue.dimmer, italic = true })

  vim.api.nvim_set_hl(0, 'Constant', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, 'String', { fg = palette.green.base })
  vim.api.nvim_set_hl(0, 'Character', { link = 'String' })
  vim.api.nvim_set_hl(0, 'Boolean', { link = 'String' })
  vim.api.nvim_set_hl(0, 'Number', { link = 'String' })
  vim.api.nvim_set_hl(0, 'Float', { link = 'Number' })

  vim.api.nvim_set_hl(0, 'Identifier', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, 'Function', { link = 'Identifier' })

  vim.api.nvim_set_hl(0, 'Statement', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, 'Keyword', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'Exception', { link = 'Keyword' })
  vim.api.nvim_set_hl(0, 'Conditional', { link = 'Keyword' })
  vim.api.nvim_set_hl(0, 'Repeat', { link = 'Conditional' })
  vim.api.nvim_set_hl(0, 'Label', { link = 'Conditional' })
  vim.api.nvim_set_hl(0, 'Operator', { fg = palette.fg.dimmer })

  vim.api.nvim_set_hl(0, 'PreProc', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, 'Include', { link = 'PreProc' })
  vim.api.nvim_set_hl(0, 'Define', { link = 'PreProc' })
  vim.api.nvim_set_hl(0, 'Macro', { link = 'PreProc' })
  vim.api.nvim_set_hl(0, 'PreCondit', { link = 'PreProc' })

  vim.api.nvim_set_hl(0, 'Type', { fg = palette.yellow.base })
  vim.api.nvim_set_hl(0, 'StorageClass', { link = 'Type' })
  vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })
  vim.api.nvim_set_hl(0, 'Typedef', { link = 'Type' })

  vim.api.nvim_set_hl(0, 'Special', { fg = palette.orange.base })
  vim.api.nvim_set_hl(0, 'SpecialChar', { link = 'Special' })
  vim.api.nvim_set_hl(0, 'Tag', { link = 'Special' })
  vim.api.nvim_set_hl(0, 'Delimiter', { link = 'Special' })
  vim.api.nvim_set_hl(0, 'SpecialComment', { link = 'Special' })
  vim.api.nvim_set_hl(0, 'Debug', { link = 'Special' })

  vim.api.nvim_set_hl(0, 'Error', { fg = palette.red.base })
  vim.api.nvim_set_hl(0, 'Todo', { fg = palette.bg.base, bg = palette.yellow.base, bold = true })

  vim.api.nvim_set_hl(0, 'Added', { fg = palette.green.base })
  vim.api.nvim_set_hl(0, 'Changed', { fg = palette.yellow.base })
  vim.api.nvim_set_hl(0, 'Removed', { fg = palette.red.base })

  vim.api.nvim_set_hl(0, 'Title', { fg = palette.fg.dim, bold = true })
  vim.api.nvim_set_hl(0, 'Whitespace', { fg = palette.fg.dimmer })

  vim.api.nvim_set_hl(0, '@comment', { link = 'Comment' })
  vim.api.nvim_set_hl(0, '@comment.documentation', { link = 'Documentation' })
  vim.api.nvim_set_hl(0, '@comment.error', { fg = palette.bg.base, bg = palette.red.base })
  vim.api.nvim_set_hl(0, '@comment.warning', { fg = palette.bg.base, bg = palette.yellow.base })
  vim.api.nvim_set_hl(0, '@comment.todo', { fg = palette.bg.base, bg = palette.blue.base })
  vim.api.nvim_set_hl(0, '@comment.note', { fg = palette.bg.base, bg = palette.magenta.base })

  vim.api.nvim_set_hl(0, '@boolean', { link = 'Boolean' })

  vim.api.nvim_set_hl(0, '@number', { link = 'Number' })
  vim.api.nvim_set_hl(0, '@number.float', { link = 'Float' })

  vim.api.nvim_set_hl(0, '@string', { link = 'String' })
  vim.api.nvim_set_hl(0, '@string.special', { link = 'Special' })
  vim.api.nvim_set_hl(0, '@string.special.url', { link = '@markup.link' })
  vim.api.nvim_set_hl(0, '@string.special.symbol', { link = 'Special' })
  vim.api.nvim_set_hl(0, '@string.special.path', { fg = palette.blue.base })
  vim.api.nvim_set_hl(0, '@string.escape', { fg = palette.magenta.bright, bold = true })
  vim.api.nvim_set_hl(0, '@string.regexp', { fg = palette.green.base })
  vim.api.nvim_set_hl(0, '@operator.regex', { fg = palette.green.dim, bold = true })
  vim.api.nvim_set_hl(0, '@string.documentation', { link = 'Documentation' })

  vim.api.nvim_set_hl(0, '@character', { link = 'Character' })
  vim.api.nvim_set_hl(0, '@character.special', { fg = palette.fg.dim })

  vim.api.nvim_set_hl(0, '@type', { link = 'Type' })
  vim.api.nvim_set_hl(0, '@type.builtin', { link = '@type' })

  vim.api.nvim_set_hl(0, '@module', { fg = palette.yellow.base })
  vim.api.nvim_set_hl(0, '@module.builtin', { fg = palette.fg.base })

  vim.api.nvim_set_hl(0, '@property', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, '@attribute', { link = '@property' })
  vim.api.nvim_set_hl(0, '@variable', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, '@variable.key', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, '@variable.parameter', { link = '@variable' })
  vim.api.nvim_set_hl(0, '@variable.member', { link = '@variable' })
  vim.api.nvim_set_hl(0, '@variable.builtin', { fg = palette.pink.base })

  vim.api.nvim_set_hl(0, '@function', { fg = palette.fg.dim, underline = true, bold = true })
  vim.api.nvim_set_hl(0, '@function.macro', { link = '@function' })
  vim.api.nvim_set_hl(0, '@function.call', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, '@function.method', { link = '@function' })
  vim.api.nvim_set_hl(0, '@function.method.call', { link = '@function.call' })
  vim.api.nvim_set_hl(0, '@function.method.call.class', { italic = true })
  vim.api.nvim_set_hl(0, '@function.method.call.flow', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, '@function.builtin', { link = '@function.call' })
  vim.api.nvim_set_hl(0, '@constructor', { link = '@function' })

  vim.api.nvim_set_hl(0, '@class', { fg = palette.yellow.base, underline = true, bold = true })
  vim.api.nvim_set_hl(0, '@constant', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, '@constant.builtin', { link = '@variable.builtin' })
  vim.api.nvim_set_hl(0, '@constant.assignment', { fg = palette.fg.base, underline = true })
  vim.api.nvim_set_hl(0, '@constant.macro', { link = 'Macro' })

  vim.api.nvim_set_hl(0, '@operator', { fg = palette.fg.dimmer })

  vim.api.nvim_set_hl(0, '@label', { link = 'Label' })

  vim.api.nvim_set_hl(0, '@tag', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, '@tag.attribute', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, '@tag.delimiter', { link = '@operator' })

  vim.api.nvim_set_hl(0, '@punctuation.special', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = '@operator' })
  vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = '@operator' })

  vim.api.nvim_set_hl(0, '@keyword', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, '@keyword.import', { link = '@keyword' })
  vim.api.nvim_set_hl(0, '@keyword.operator', { link = '@keyword' })
  vim.api.nvim_set_hl(0, '@keyword.function', { link = '@keyword' })
  vim.api.nvim_set_hl(0, '@keyword.exception', { link = '@keyword' })
  vim.api.nvim_set_hl(0, '@keyword.return', { fg = palette.red.base, bg = palette.red.dimmer })
  vim.api.nvim_set_hl(0, '@keyword.next', { link = '@keyword.return' })
  vim.api.nvim_set_hl(0, '@keyword.break', { link = '@keyword.return' })
  vim.api.nvim_set_hl(0, '@keyword.raise', { link = '@keyword.return' })
  vim.api.nvim_set_hl(0, '@keyword.exit', { link = '@keyword.return' })
  vim.api.nvim_set_hl(0, '@keyword.conditional', { fg = palette.magenta.base, bg = palette.magenta.dimmer })
  vim.api.nvim_set_hl(0, '@keyword.conditional.ternary', { link = '@keyword.conditional' })
  vim.api.nvim_set_hl(0, '@keyword.repeat', { link = '@keyword.conditional' })
  -- vim.api.nvim_set_hl(0, '@keyword.coroutine' ,{})
  vim.api.nvim_set_hl(0, '@keyword.storage', { link = 'StorageClass' })
  vim.api.nvim_set_hl(0, '@keyword.debug', { fg = palette.bg.base, bg = palette.red.base })

  vim.api.nvim_set_hl(0, '@markup', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, '@markup.strong', { fg = 'none', bold = true })
  vim.api.nvim_set_hl(0, '@markup.italic', { fg = 'none', italic = true })
  vim.api.nvim_set_hl(0, '@markup.underline', { fg = 'none', underline = true })
  vim.api.nvim_set_hl(0, '@markup.quote', { fg = palette.fg.dim, italic = true })
  vim.api.nvim_set_hl(0, '@markup.link', { fg = palette.magenta.base, italic = true })
  vim.api.nvim_set_hl(0, '@markup.link.url', { link = '@markup.link' })
  vim.api.nvim_set_hl(0, '@markup.link.label', { link = '@markup.link' })
  vim.api.nvim_set_hl(0, '@markup.raw.markdown_inline', { fg = 'none', bg = 'none' })
  vim.api.nvim_set_hl(0, '@markup.raw.block', { fg = palette.yellow.base, bg = 'none' })
  vim.api.nvim_set_hl(0, '@markup.heading.1', { fg = palette.pink.base })
  vim.api.nvim_set_hl(0, '@markup.heading.2', { fg = palette.green.base })
  vim.api.nvim_set_hl(0, '@markup.heading.3', { fg = palette.blue.base })
  vim.api.nvim_set_hl(0, '@markup.heading.4', { fg = palette.yellow.base })
  vim.api.nvim_set_hl(0, '@markup.heading.5', { fg = palette.cyan.base })
  vim.api.nvim_set_hl(0, '@markup.heading.6', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, '@markup.list', { fg = palette.cyan.dim })
  vim.api.nvim_set_hl(0, '@markup.list.checked', { fg = palette.green.base })
  vim.api.nvim_set_hl(0, '@markup.list.unchecked', { fg = palette.yellow.base })
  vim.api.nvim_set_hl(0, '@markup.strikethrough', { fg = palette.fg.base, strikethrough = true })
  vim.api.nvim_set_hl(0, '@markup.heading', { link = 'Title' })
  -- vim.api.nvim_set_hl(0, '@markup.math', { fg = p.fg.dim })
  -- vim.api.nvim_set_hl(0, '@markup.environment', {})
  vim.api.nvim_set_hl(0, '@markup.raw', { fg = palette.fg.base, bg = palette.bg.dim, italic = true })
  vim.api.nvim_set_hl(0, '@diff.plus', { link = 'diffAdded' })
  vim.api.nvim_set_hl(0, '@diff.minus', { link = 'diffRemoved' })
  vim.api.nvim_set_hl(0, '@diff.delta', { link = 'diffChanged' })

  -- search
  vim.api.nvim_set_hl(0, 'Search', { fg = palette.fg.base, bg = palette.sel.dim })
  vim.api.nvim_set_hl(0, 'IncSearch', { fg = palette.fg.base, bg = palette.sel.base })
  vim.api.nvim_set_hl(0, 'Substitute', { link = 'IncSearch' })
  vim.api.nvim_set_hl(0, 'CurSearch', { link = 'IncSearch' })

  -- snippets
  vim.api.nvim_set_hl(0, 'SnippetTabstop', { fg = palette.fg.dimmer, bg = palette.bg.dim, italic = true })
  vim.api.nvim_set_hl(0, 'SnippetTabstopActive', { fg = palette.accent.base, bg = palette.accent.dim, bold = true })

  -- Lines
  vim.api.nvim_set_hl(0, 'LineNr', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = palette.bg.dimmer })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = palette.fg.dimmer, bg = palette.bg.dimmer })

  -- signcolumn
  vim.api.nvim_set_hl(0, 'SignColumn', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'SignColumnSB', { link = 'SignColumn' })

  -- color column
  vim.api.nvim_set_hl(0, 'ColorColumn', { bg = palette.bg.dimmer })
  vim.api.nvim_set_hl(0, 'CursorColumn', { link = 'CursorLine' })

  -- tabline
  vim.api.nvim_set_hl(0, 'TabLine', { fg = palette.fg.dimmer, bg = palette.bg.dim })
  vim.api.nvim_set_hl(0, 'TabLineFill', { bg = palette.bg.dim })
  vim.api.nvim_set_hl(0, 'TabLineSel', { fg = palette.fg.base, bg = palette.bg.dimmer })

  -- statusline
  vim.api.nvim_set_hl(0, 'StatusLine', { fg = palette.fg.dim, bg = palette.bg.dim })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { link = 'StatusLine' })

  -- MsgArea
  vim.api.nvim_set_hl(0, 'MsgArea', { fg = palette.fg.base, bg = palette.bg.dim })
  vim.api.nvim_set_hl(0, 'MsgSeparator', { link = 'WinSeparator' })
  vim.api.nvim_set_hl(0, 'MoreMsg', { fg = palette.fg.base, bg = palette.bg.dim, bold = true })
  vim.api.nvim_set_hl(0, 'ModeMsg', { fg = palette.yellow.base, bold = true })
  vim.api.nvim_set_hl(0, 'Question', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, 'OkMsg', { fg = palette.green.base })
  vim.api.nvim_set_hl(0, 'ErrorMsg', { fg = palette.red.base })
  vim.api.nvim_set_hl(0, 'WarningMsg', { fg = palette.yellow.base })

  -- quickfix
  vim.api.nvim_set_hl(0, 'qfText', { link = '@normal' })
  vim.api.nvim_set_hl(0, 'qfLineNr', { link = 'LineNr' })
  vim.api.nvim_set_hl(0, 'qfSeparator1', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'qfSeparator2', { link = 'qfSeparator1' })
  vim.api.nvim_set_hl(0, 'qfFileName', { fg = palette.blue.base })
  vim.api.nvim_set_hl(0, 'QuickFixLine', { bg = palette.sel.base })

  -- folds
  vim.api.nvim_set_hl(0, 'Folded', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, 'FoldColumn', { link = 'SignColumn' })

  -- diagnostics
  vim.api.nvim_set_hl(0, 'DiagnosticPass', { fg = palette.green.base, bg = palette.green.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticMixed', { fg = palette.yellow.base, bg = palette.yellow.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticFail', { fg = palette.red.base, bg = palette.red.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticPending', { fg = palette.blue.base, bg = palette.blue.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { fg = palette.fg.dim, italic = true })
  vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = palette.red.base })
  vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = palette.yellow.base })
  vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = palette.blue.base })
  vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticOk', { fg = palette.green.base })
  vim.api.nvim_set_hl(0, 'DiagnosticSignError', { link = 'DiagnosticError' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { link = 'DiagnosticWarn' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { link = 'DiagnosticInfo' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { link = 'DiagnosticHint' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignOk', { link = 'DiagnosticOk' })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = palette.red.base, bg = palette.red.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { fg = palette.yellow.base, bg = palette.yellow.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { fg = palette.blue.base, bg = palette.blue.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', { fg = palette.fg.dim, bg = palette.bg.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextOk', { fg = palette.green.base, bg = palette.green.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = palette.red.base })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = palette.yellow.base })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = palette.blue.base })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = palette.fg.dim })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineOk', { undercurl = true, sp = palette.green.base })

  -- LSP
  vim.api.nvim_set_hl(0, 'LspReferenceText', { fg = palette.accent.base, bg = palette.accent.dimmer })
  vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter',
    { fg = 'none', bg = palette.sel.base, sp = palette.blue.base, underline = true })
  vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = palette.sel.dim })
  vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = palette.sel.dim })
  vim.api.nvim_set_hl(0, 'LspCodeLens', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, 'LspCodeLensSeparator', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = palette.blue.base, bg = 'NONE' })

  -- floats
  vim.api.nvim_set_hl(0, 'NormalFloat', { fg = 'none', bg = palette.bg.dim })
  vim.api.nvim_set_hl(0, 'FloatBorder', { fg = palette.bg.dim, bg = palette.bg.dim })
  vim.api.nvim_set_hl(0, 'FloatTitle', { fg = palette.fg.dim, bg = palette.bg.dim, bold = true })
  vim.api.nvim_set_hl(0, 'FloatFooter', { fg = palette.fg.base, bg = palette.bg.base })

  -- windows
  vim.api.nvim_set_hl(0, 'WinSeparator', { link = 'WinSeparatorThin' })
  vim.api.nvim_set_hl(0, 'WinSeparatorThin', { fg = palette.bg.dim, bg = 'none' })
  vim.api.nvim_set_hl(0, 'WinSeparatorThick', { fg = palette.bg.dim, bg = palette.bg.dim })
  vim.api.nvim_set_hl(0, 'WinBar', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, 'WinBarNC', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'VertSplit', { link = 'WinSeparator' })

  -- pmenu
  vim.api.nvim_set_hl(0, 'Pmenu', { fg = palette.fg.base, bg = palette.bg.dim })
  vim.api.nvim_set_hl(0, 'PmenuSel', { bg = palette.sel.base })
  vim.api.nvim_set_hl(0, 'PmenuSbar', { link = 'Pmenu' })
  vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = palette.sel.dim })
  vim.api.nvim_set_hl(0, 'WildMenu', { link = 'Pmenu' })
end
