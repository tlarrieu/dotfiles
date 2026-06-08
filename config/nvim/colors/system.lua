vim.g.colors_name = 'system'

vim.api.nvim_create_autocmd('Signal', {
  pattern = { 'SIGUSR1' },
  callback = function() vim.cmd.colorscheme('system') end,
  nested = true,
})

local file_for = function(mode)
  return vim.fs.joinpath(
    vim.fn.stdpath('config'),
    'lua',
    'colors',
    'palettes',
    mode .. '.lua'
  )
end

local import = function(mode) return loadfile(file_for(mode))() end

vim.cmd('highlight clear')
vim.o.background = require('mode').current()
local palette, hl = import(vim.o.background), vim.api.nvim_set_hl

------------------| base |-----------------------

hl(0, 'Normal', { fg = palette.fg.base, bg = palette.bg.base })
hl(0, 'NormalNC', { link = 'Normal' })
hl(0, 'NonText', { fg = palette.bg.border })
hl(0, 'EndOfBuffer', { fg = palette.bg.base })
hl(0, 'Conceal', { fg = palette.bg.border })
hl(0, 'SpecialKey', { link = 'NonText' })

hl(0, 'Underlined', { underline = true })
hl(0, 'Bold', { bold = true })
hl(0, 'Italic', { italic = true })

hl(0, 'Visual', { bg = palette.sel.base })
hl(0, 'VisualNOS', { link = 'Visual' })

hl(0, 'Cursor', { fg = palette.bg.base, bg = palette.accent.base })
hl(0, 'lCursor', { link = 'Cursor' })
hl(0, 'CursorIM', { link = 'Cursor' })
hl(0, 'TermCursor', { link = 'Cursor' })
hl(0, 'TermCursorNC', { link = 'Cursor' })

hl(0, 'SpellRare', {})
hl(0, 'SpellLocal', {})
hl(0, 'SpellBad', { sp = palette.red.base, undercurl = true })
hl(0, 'SpellCap', { sp = palette.yellow.base, undercurl = true })

hl(0, 'MatchParen', { fg = palette.blue.base, bg = palette.blue.dim })

hl(0, 'Comment', { fg = palette.blue.base, italic = true })
hl(0, 'Documentation', { fg = palette.blue.base, bg = palette.blue.dimmer, italic = true })

hl(0, 'Constant', { fg = palette.fg.base })
hl(0, 'String', { fg = palette.green.base })
hl(0, 'Character', { link = 'String' })
hl(0, 'Boolean', { link = 'String' })
hl(0, 'Number', { link = 'String' })
hl(0, 'Float', { link = 'Number' })

hl(0, 'Identifier', { fg = palette.fg.base })
hl(0, 'Function', { link = 'Identifier' })

hl(0, 'Statement', { fg = palette.fg.base })
hl(0, 'Keyword', { fg = palette.fg.dimmer })
hl(0, 'Exception', { link = 'Keyword' })
hl(0, 'Conditional', { link = 'Keyword' })
hl(0, 'Repeat', { link = 'Conditional' })
hl(0, 'Label', { link = 'Conditional' })
hl(0, 'Operator', { fg = palette.fg.dimmer })

hl(0, 'PreProc', { fg = palette.fg.dim })
hl(0, 'Include', { link = 'PreProc' })
hl(0, 'Define', { link = 'PreProc' })
hl(0, 'Macro', { link = 'PreProc' })
hl(0, 'PreCondit', { link = 'PreProc' })

hl(0, 'Type', { fg = palette.yellow.base })
hl(0, 'StorageClass', { link = 'Type' })
hl(0, 'Structure', { link = 'Type' })
hl(0, 'Typedef', { link = 'Type' })

hl(0, 'Special', { fg = palette.orange.base })
hl(0, 'SpecialChar', { link = 'Special' })
hl(0, 'Tag', { link = 'Special' })
hl(0, 'Delimiter', { link = 'Special' })
hl(0, 'SpecialComment', { link = 'Special' })
hl(0, 'Debug', { link = 'Special' })

hl(0, 'Error', { fg = palette.red.base })
hl(0, 'Todo', { fg = palette.bg.base, bg = palette.yellow.base, bold = true })

hl(0, 'Added', { fg = palette.green.base })
hl(0, 'Changed', { fg = palette.yellow.base })
hl(0, 'Removed', { fg = palette.red.base })

hl(0, 'Title', { fg = palette.fg.dim, bold = true })
hl(0, 'Whitespace', { fg = palette.fg.dimmer })

hl(0, '@comment', { link = 'Comment' })
hl(0, '@comment.documentation', { link = 'Documentation' })
hl(0, '@comment.error', { fg = palette.bg.base, bg = palette.red.base })
hl(0, '@comment.warning', { fg = palette.bg.base, bg = palette.yellow.base })
hl(0, '@comment.todo', { fg = palette.bg.base, bg = palette.blue.base })
hl(0, '@comment.note', { fg = palette.bg.base, bg = palette.magenta.base })

hl(0, '@boolean', { link = 'Boolean' })

hl(0, '@number', { link = 'Number' })
hl(0, '@number.float', { link = 'Float' })

hl(0, '@string', { link = 'String' })
hl(0, '@string.special', { link = 'Special' })
hl(0, '@string.special.url', { link = '@markup.link' })
hl(0, '@string.special.symbol', { link = 'Special' })
hl(0, '@string.special.path', { fg = palette.blue.base })
hl(0, '@string.escape', { fg = palette.magenta.bright, bold = true })
hl(0, '@string.regexp', { fg = palette.green.base })
hl(0, '@operator.regex', { fg = palette.green.dim, bold = true })
hl(0, '@string.documentation', { link = 'Documentation' })

hl(0, '@character', { link = 'Character' })
hl(0, '@character.special', { fg = palette.fg.dim })

hl(0, '@type', { link = 'Type' })
hl(0, '@type.builtin', { link = '@type' })

hl(0, '@module', { fg = palette.yellow.base })
hl(0, '@module.builtin', { fg = palette.fg.base })

hl(0, '@property', { fg = palette.fg.dim })
hl(0, '@attribute', { link = '@property' })
hl(0, '@variable', { fg = palette.fg.base })
hl(0, '@variable.key', { fg = palette.fg.dim, italic = true })
hl(0, '@variable.parameter', { link = '@variable' })
hl(0, '@variable.member', { link = '@variable' })
hl(0, '@variable.builtin', { fg = palette.pink.base })

hl(0, '@function', { fg = palette.fg.dim, underline = true, bold = true })
hl(0, '@function.macro', { link = '@function' })
hl(0, '@function.call', { fg = palette.fg.base })
hl(0, '@function.method', { link = '@function' })
hl(0, '@function.method.call', { link = '@function.call' })
hl(0, '@function.method.call.class', { italic = true })
hl(0, '@function.method.call.flow', { fg = palette.magenta.base })
hl(0, '@function.builtin', { link = '@function.call' })
hl(0, '@constructor', { link = '@function' })

hl(0, '@class', { fg = palette.yellow.base, underline = true, bold = true })
hl(0, '@constant', { fg = palette.fg.base })
hl(0, '@constant.builtin', { link = '@variable.builtin' })
hl(0, '@constant.assignment', { fg = palette.fg.base, underline = true })
hl(0, '@constant.macro', { link = 'Macro' })

hl(0, '@operator', { fg = palette.fg.dimmer })

hl(0, '@label', { link = 'Label' })

hl(0, '@tag', { fg = palette.fg.dimmer })
hl(0, '@tag.attribute', { fg = palette.fg.dim })
hl(0, '@tag.delimiter', { link = '@operator' })

hl(0, '@punctuation.special', { fg = palette.fg.dim })
hl(0, '@punctuation.delimiter', { link = '@operator' })
hl(0, '@punctuation.bracket', { link = '@operator' })

hl(0, '@keyword', { fg = palette.fg.dimmer })
hl(0, '@keyword.import', { link = '@keyword' })
hl(0, '@keyword.operator', { link = '@keyword' })
hl(0, '@keyword.function', { link = '@keyword' })
hl(0, '@keyword.exception', { link = '@keyword' })
hl(0, '@keyword.return', { fg = palette.red.base, bg = palette.red.dimmer })
hl(0, '@keyword.next', { link = '@keyword.return' })
hl(0, '@keyword.break', { link = '@keyword.return' })
hl(0, '@keyword.raise', { link = '@keyword.return' })
hl(0, '@keyword.exit', { link = '@keyword.return' })
hl(0, '@keyword.conditional', { fg = palette.magenta.base, bg = palette.magenta.dimmer })
hl(0, '@keyword.conditional.ternary', { link = '@keyword.conditional' })
hl(0, '@keyword.repeat', { link = '@keyword.conditional' })
-- hl(0, '@keyword.coroutine' ,{})
hl(0, '@keyword.storage', { link = 'StorageClass' })
hl(0, '@keyword.debug', { fg = palette.bg.base, bg = palette.red.base })

hl(0, '@markup', { fg = palette.fg.base })
hl(0, '@markup.strong', { fg = 'none', bold = true })
hl(0, '@markup.italic', { fg = 'none', italic = true })
hl(0, '@markup.underline', { fg = 'none', underline = true })
hl(0, '@markup.quote', { fg = palette.fg.dim, italic = true })
hl(0, '@markup.link', { fg = palette.magenta.base, italic = true })
hl(0, '@markup.link.url', { link = '@markup.link' })
hl(0, '@markup.link.label', { link = '@markup.link' })
hl(0, '@markup.raw.markdown_inline', { fg = 'none', bg = 'none' })
hl(0, '@markup.raw.block', { fg = palette.yellow.base, bg = 'none' })
hl(0, '@markup.heading.1', { fg = palette.pink.base })
hl(0, '@markup.heading.2', { fg = palette.green.base })
hl(0, '@markup.heading.3', { fg = palette.blue.base })
hl(0, '@markup.heading.4', { fg = palette.yellow.base })
hl(0, '@markup.heading.5', { fg = palette.cyan.base })
hl(0, '@markup.heading.6', { fg = palette.magenta.base })
hl(0, '@markup.list', { fg = palette.cyan.dim })
hl(0, '@markup.list.checked', { fg = palette.green.base })
hl(0, '@markup.list.unchecked', { fg = palette.yellow.base })
hl(0, '@markup.strikethrough', { fg = palette.fg.base, strikethrough = true })
hl(0, '@markup.heading', { link = 'Title' })
-- hl(0, '@markup.math', { fg = palette.fg.dim })
-- hl(0, '@markup.environment', {})
hl(0, '@markup.raw', { fg = palette.fg.base, bg = palette.bg.dim, italic = true })
hl(0, '@diff.plus', { link = "diffAdded" })
hl(0, '@diff.minus', { link = "diffRemoved" })
hl(0, '@diff.delta', { link = "diffChanged" })

-- search
hl(0, 'Search', { fg = palette.fg.base, bg = palette.sel.dim })
hl(0, 'IncSearch', { fg = palette.fg.base, bg = palette.accent.dim })
hl(0, 'Substitute', { link = 'IncSearch' })
hl(0, 'CurSearch', { link = 'IncSearch' })

-- snippets
hl(0, 'SnippetTabstop', { fg = palette.fg.dimmer, bg = palette.bg.dark, italic = true })
hl(0, 'SnippetTabstopActive', { fg = palette.pink.base, bg = palette.pink.dim, bold = true })

-- Lines
hl(0, 'LineNr', { fg = palette.fg.dimmer })
hl(0, 'CursorLine', { bg = palette.bg.dimmer })
hl(0, 'CursorLineNr', { fg = palette.fg.dimmer, bg = palette.bg.dimmer })

-- signcolumn
hl(0, 'SignColumn', { fg = palette.fg.dimmer })
hl(0, 'SignColumnSB', { link = 'SignColumn' })

-- color column
hl(0, 'ColorColumn', { bg = palette.bg.dimmer })
hl(0, 'CursorColumn', { link = 'CursorLine' })

-- tabline
hl(0, 'TabLine', { fg = palette.fg.dimmer, bg = palette.bg.dim })
hl(0, 'TabLineFill', { bg = palette.bg.dark })
hl(0, 'TabLineSel', { fg = palette.fg.base, bg = palette.bg.dimmer })

-- statusline
hl(0, 'StatusLine', { fg = palette.fg.dim, bg = palette.bg.dark })
hl(0, 'StatusLineNC', { link = 'StatusLine' })

-- MsgArea
hl(0, 'MsgArea', { link = 'MsgAreaMsg' })
hl(0, 'MsgAreaCmd', { fg = palette.fg.base })
hl(0, 'MsgAreaMsg', { fg = palette.fg.dimmer })
hl(0, 'MsgSeparator', { link = 'WinSeparator' })
hl(0, 'MoreMsg', { fg = palette.fg.dim, bg = 'none', bold = true })
hl(0, 'Question', { link = 'MoreMsg' })
hl(0, 'ErrorMsg', { fg = palette.red.base })
hl(0, 'WarningMsg', { fg = palette.yellow.base })
hl(0, 'ModeMsg', { fg = palette.yellow.base, bold = true })

-- quickfix
hl(0, 'qfText', { link = '@normal' })
hl(0, 'qfLineNr', { link = 'LineNr' })
hl(0, 'qfSeparator1', { fg = palette.fg.dimmer })
hl(0, 'qfSeparator2', { link = 'qfSeparator1' })
hl(0, 'qfFileName', { fg = palette.blue.base })
hl(0, 'QuickFixLine', { bg = palette.sel.base })

-- folds
hl(0, 'Folded', { fg = palette.fg.dim })
hl(0, 'FoldColumn', { link = 'SignColumn' })

-- diagnostics
hl(0, 'DiagnosticPass', { fg = palette.green.base, bg = palette.green.dim })
hl(0, 'DiagnosticMixed', { fg = palette.yellow.base, bg = palette.yellow.dim })
hl(0, 'DiagnosticFail', { fg = palette.red.base, bg = palette.red.dim })
hl(0, 'DiagnosticPending', { fg = palette.blue.base, bg = palette.blue.dim })
hl(0, 'DiagnosticUnnecessary', { fg = palette.fg.dim, italic = true })
hl(0, 'DiagnosticError', { fg = palette.red.base })
hl(0, 'DiagnosticWarn', { fg = palette.yellow.base })
hl(0, 'DiagnosticInfo', { fg = palette.blue.base })
hl(0, 'DiagnosticHint', { fg = palette.fg.dim })
hl(0, 'DiagnosticOk', { fg = palette.green.base })
hl(0, 'DiagnosticSignError', { link = 'DiagnosticError' })
hl(0, 'DiagnosticSignWarn', { link = 'DiagnosticWarn' })
hl(0, 'DiagnosticSignInfo', { link = 'DiagnosticInfo' })
hl(0, 'DiagnosticSignHint', { link = 'DiagnosticHint' })
hl(0, 'DiagnosticSignOk', { link = 'DiagnosticOk' })
hl(0, 'DiagnosticVirtualTextError', { fg = palette.red.base, bg = palette.red.dim })
hl(0, 'DiagnosticVirtualTextWarn', { fg = palette.yellow.base, bg = palette.yellow.dim })
hl(0, 'DiagnosticVirtualTextInfo', { fg = palette.blue.base, bg = palette.blue.dim })
hl(0, 'DiagnosticVirtualTextHint', { fg = palette.fg.dim, bg = palette.bg.dim })
hl(0, 'DiagnosticVirtualTextOk', { fg = palette.green.base, bg = palette.green.dim })
hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = palette.red.base })
hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = palette.yellow.base })
hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = palette.blue.base })
hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = palette.fg.dim })
hl(0, 'DiagnosticUnderlineOk', { undercurl = true, sp = palette.green.base })

-- LSP
hl(0, 'LspReferenceText', { fg = palette.pink.base, bg = palette.pink.dimmer })
hl(0, 'LspSignatureActiveParameter', { fg = 'none', bg = palette.sel1.base, sp = palette.blue.base, underline = true })
hl(0, 'LspReferenceRead', { bg = palette.sel.dim })
hl(0, 'LspReferenceWrite', { bg = palette.sel.dim })
hl(0, 'LspCodeLens', { fg = palette.fg.dim })
hl(0, 'LspCodeLensSeparator', { fg = palette.fg.dimmer })
hl(0, 'LspInlayHint', { fg = palette.blue.base, bg = 'NONE' })

-- floats
hl(0, 'NormalFloat', { fg = 'none', bg = palette.bg.dark })
hl(0, 'FloatBorder', { fg = palette.bg.dark, bg = palette.bg.dark })
hl(0, 'FloatTitle', { fg = palette.fg.dim, bg = palette.bg.dark, bold = true })
hl(0, 'FloatFooter', { fg = palette.fg.base, bg = palette.bg.base })

-- windows
hl(0, 'WinSeparator', { link = 'WinSeparatorThin' })
hl(0, 'WinSeparatorThin', { fg = palette.bg.dark, bg = 'none' })
hl(0, 'WinSeparatorThick', { fg = palette.bg.dark, bg = palette.bg.dark })
hl(0, 'WinBar', { fg = palette.fg.dim })
hl(0, 'WinBarNC', { fg = palette.fg.dimmer })
hl(0, 'VertSplit', { link = 'WinSeparator' })

-- pmenu
hl(0, 'Pmenu', { fg = palette.fg.base, bg = palette.bg.dark })
hl(0, 'PmenuSel', { bg = palette.sel.dim })
hl(0, 'PmenuSbar', { link = 'Pmenu' })
hl(0, 'PmenuThumb', { bg = palette.sel.base })
hl(0, 'WildMenu', { link = 'Pmenu' })

------------| Language specific |----------------

-- bash
hl(0, '@string.special.path.bash', { fg = palette.pink.base })

-- query
hl(0, '@function.call.query', { fg = palette.blue.base })
hl(0, '@comment.query', { fg = palette.fg.dimmer })
hl(0, '@keyword.directive.query', { fg = palette.fg.dim })
hl(0, '@variable.query', { fg = palette.pink.base })

-- latex
hl(0, '@string.special.path.latex', { fg = palette.blue.base })
hl(0, '@markup.math.latex', { fg = palette.magenta.base })
hl(0, '@function.latex', { fg = palette.pink.base })
hl(0, '@function.linebreak.latex', { link = '@operator' })

-- lua
hl(0, '@constructor.lua', { link = '@punctuation.bracket' })
hl(0, '@keyword.operator.lua', { link = '@keyword' })
hl(0, '@comment.documentation.lua', { fg = palette.fg.dimmer, bg = palette.bg.dimmer })

hl(0, '@comment.luadoc', { link = '@comment.documentation.lua' })
hl(0, '@keyword.luadoc', { fg = palette.fg.dim, bold = true })
hl(0, '@keyword.function.luadoc', { link = '@type' })
hl(0, '@keyword.import.luadoc', { link = '@keyword.luadoc' })
hl(0, '@keyword.return.luadoc', { link = '@keyword.luadoc' })

-- make
hl(0, '@function.builtin.make', { link = 'makeConfig' })
hl(0, '@function.make', { fg = palette.blue.base, bg = 'none' })
hl(0, '@operator.make', { fg = palette.fg.dim, bg = 'none' })
hl(0, 'makeSpecial', { fg = palette.fg.dimmer })
hl(0, 'makeCommands', { fg = palette.fg.base })
hl(0, 'makeTarget', { fg = palette.blue.base })
hl(0, 'makeSpecTarget', { fg = palette.fg.dimmer })
hl(0, 'makePreCondit', { link = '@keyword.conditional' })
hl(0, 'makeStatement', { fg = palette.magenta.base })
hl(0, 'makeDefine', { link = '@keyword' })

-- just
hl(0, '@function.just', { fg = palette.blue.base })
hl(0, '@attribute.builtin.just', { fg = palette.fg.dimmer })
hl(0, '@attribute.default', { fg = palette.pink.base })
hl(0, '@variable.parameter.just', { fg = palette.fg.dim, italic = true })
hl(0, '@variable.just', { fg = palette.magenta.base })

-- go
hl(0, '@function.gotmpl', { fg = palette.blue.base, bg = 'none' })
hl(0, '@function.builtin.gotmpl', { fg = palette.fg.dim, bg = 'none' })
hl(0, '@variable.member.gotmpl', { fg = palette.fg.dim, bg = 'none' })

-- ruby
hl(0, '@comment.directive', { fg = palette.fg.dimmer, bg = palette.bg.base })
-- hl(0, '@keyword.directive.define', {})
hl(0, '@keyword.directive', { link = '@comment.directive' })
hl(0, '@string.special.symbol.ruby', { link = '@string.ruby' })
hl(0, '@operator.ternary.ruby', { link = '@keyword.conditional.ruby' })
hl(0, '@punctuation.special.ruby', { fg = palette.fg.dim })
hl(0, '@function.builtin.ruby', { link = '@keyword' })

-- SQL
hl(0, '@keyword.sql', { fg = palette.magenta.base })
hl(0, '@keyword.operator.sql', { link = '@keyword.sql' })
hl(0, '@variable.member.sql', { link = '@variable' })

-- yaml
hl(0, '@property.yaml', { link = '@variable.key' })
hl(0, '@variable.member.yaml', { fg = palette.green.base })

-- CSS
hl(0, '@attribute.css', { fg = palette.fg.dim })
hl(0, '@tag.attribute.css', { link = '@attribute.css' })
hl(0, '@field.css', { link = '@attribute.css' })
hl(0, '@property.css', { fg = palette.fg.dimmer })
hl(0, '@character.special.css', { fg = palette.fg.dim })
hl(0, '@keyword.directive.css', { fg = palette.blue.base })
hl(0, '@constructor.css', { fg = palette.orange.base })
hl(0, '@tag.css', { link = '@type' })
hl(0, '@type.css', { fg = palette.magenta.base })
hl(0, '@constant.css', { link = '@type.css' })
hl(0, '@function.css', { link = '@function.call' })

-- xresources
hl(0, '@character.special.xresources', { link = '@variable' })
hl(0, '@constant.macro.xresources', { link = '@variable' })
hl(0, '@markup.raw.xresources', { link = 'String' })
hl(0, '@keyword.import.xresources', { fg = palette.fg.base })
hl(0, '@keyword.directive.define.xresources', { link = '@keyword.import.xresources' })

-- rasi
hl(0, '@namespace.rasi', { link = '@constructor.css' })
hl(0, '@field.rasi', { link = '@field.css' })
hl(0, '@variable.rasi', { fg = palette.magenta.base })
hl(0, '@keyword.rasi', { fg = palette.pink.base })
hl(0, '@string.special.rasi', { link = '@keyword.rasi' })
hl(0, '@constant.rasi', { fg = palette.yellow.base })
hl(0, '@character.special.rasi', { link = '@constant.rasi' })
hl(0, '@punctuation.special.rasi', { fg = palette.magenta.base })

-- kitty -> links do not work here for some reason
hl(0, 'kittyString', { fg = palette.green.base })
hl(0, 'kittyKeyword', { fg = palette.fg.base })
hl(0, 'kittyMap', { fg = palette.fg.dimmer })
hl(0, 'kittyMapName', { fg = palette.fg.dimmer })
hl(0, 'kittyParameter', { fg = palette.fg.base })
hl(0, 'kittyKey', { fg = palette.pink.base })

-- zathurarc
hl(0, '@variable.builtin.zathurarc', { link = '@variable' })

-- vimdoc
hl(0, '@markup.raw.vimdoc', { fg = palette.fg.dim })
hl(0, '@markup.raw.block.vimdoc', { link = '@markup.raw.vimdoc' })
hl(0, '@comment.note.vimdoc', { fg = palette.bg.base, bg = palette.magenta.base })

-- man pages
hl(0, 'manHeader', { link = 'Title' })
hl(0, 'manFooter', { link = 'manHeader' })
hl(0, 'manOptionDesc', { fg = palette.magenta.base })
hl(0, 'manSectionHeading', { link = 'MarkViewHeading1' })
hl(0, 'manSubHeading', { link = 'MarkViewHeading2' })

-- edifact
hl(0, 'edifactTag', { link = 'Type' })
hl(0, 'edifactData', { fg = palette.green.base })
hl(0, 'edifactColon', { fg = palette.fg.dimmer })
hl(0, 'edifactPlusSign', { link = 'edifactColon' })
hl(0, 'edifactAsterisk', { link = 'edifactColon' })
hl(0, 'edifactApostrophe', { fg = palette.fg.dimmer })
hl(0, 'edifactEscape', { link = 'Special' })
hl(0, 'edifactError', { link = 'Error' })
hl(0, 'edifactTagUNA', { fg = palette.fg.dimmer })
hl(0, 'edifactTagSEQ', { fg = palette.fg.dim, bg = palette.bg.dimmer, bold = true })
hl(0, 'edifactTagIND', { fg = palette.fg.dimmer })

-- -------------------| plugins |----------------------

hl(0, 'Directory', { fg = palette.blue.base, bg = 'none' })
hl(0, 'OilLink', { fg = palette.yellow.base })
hl(0, 'OilFileHidden', { fg = palette.fg.dimmer, italic = true })
hl(0, 'OilLinkHidden', { fg = palette.yellow.base, italic = true })
hl(0, 'OilLinkTarget', { fg = palette.fg.dimmer })
hl(0, 'OilLinkTargetHidden', { fg = palette.fg.dimmer, italic = true })
hl(0, 'OilOrphanLinkTargetHidden', { fg = palette.red.base, italic = true })
hl(0, 'OilDir', { fg = palette.blue.base })
hl(0, 'OilDirHidden', { fg = palette.blue.base, italic = true })
hl(0, 'OilDirIcon', { link = 'OilDir' })
hl(0, 'OilCreate', { link = 'Added' })
hl(0, 'OilDelete', { link = 'Removed' })
hl(0, 'OilTrash', { link = 'OilDelete' })
hl(0, 'OilPurge', { link = 'OilDelete' })
hl(0, 'OilChange', { link = 'Changed' })
hl(0, 'OilMove', { link = 'OilChange' })

hl(0, 'HarpoonLine', { link = 'QuickFixLine' })

hl(0, 'DropBarIconUISeparator', { fg = palette.fg.dimmer })
hl(0, 'DropBarIconUISeparatorNC', { fg = palette.fg.dimmer })
hl(0, 'DropBarIconUIIndicator', { link = 'DropBarIconUISeparator' })
hl(0, 'DropBarCurrentContext', { bg = palette.sel.base })
hl(0, 'DropBarCurrentIcon', { link = 'DropBarCurrentContext' })
hl(0, 'DropBarCurrentName', { link = 'DropBarCurrentContext' })
hl(0, 'DropBarCurrentHover', { link = 'DropBarCurrentContext' })
hl(0, 'DropBarKindDefault', { fg = palette.fg.dim })
hl(0, 'DropBarKindFile', { fg = palette.fg.dim, bold = true })
hl(0, 'DropBarIconKindTerminal', { link = 'DropBarIconKindDefault' })
hl(0, 'DropBarIconKindDefault', { fg = palette.fg.dim })
hl(0, 'DropBarIconKindFolder', { link = 'DropBarIconKindDefault' })
hl(0, 'DropBarIconKindObject', { link = 'DropBarIconKindDefault' })
hl(0, 'DropBarIconKindEnum', { link = 'DropBarIconKindType' })
hl(0, 'DropBarIconKindCall', { link = 'DropBarIconKindDefault' })
hl(0, 'DropBarIconKindNull', { link = 'DropBarIconKindDefault' })
hl(0, 'DropBarIconKindConstant', { link = 'DropBarIconKindDefault' })
hl(0, 'DropBarIconKindStatement', { link = 'DropBarIconKindDefault' })
hl(0, 'DropBarIconKindFunction', { link = 'DropBarIconKindDefault' })
hl(0, 'DropBarIconKindMethod', { link = 'DropBarIconKindFunction' })
hl(0, 'DropBarIconKindMarkdownH1', { link = '@markup.heading.1' })
hl(0, 'DropBarIconKindMarkdownH2', { link = '@markup.heading.2' })
hl(0, 'DropBarIconKindMarkdownH3', { link = '@markup.heading.3' })
hl(0, 'DropBarIconKindMarkdownH4', { link = '@markup.heading.4' })
hl(0, 'DropBarIconKindMarkdownH5', { link = '@markup.heading.5' })
hl(0, 'DropBarIconKindMarkdownH6', { link = '@markup.heading.6' })
hl(0, 'DropBarMenuHoverSymbol', { fg = palette.fg.dim, bold = true })
hl(0, 'DropBarMenuCurrentContext', { bg = palette.sel1.base })
hl(0, 'DropBarMenuHoverIcon', { bg = palette.sel.base })
hl(0, 'DropBarMenuHoverEntry', { link = 'DropBarMenuHoverIcon' })
hl(0, 'DropBarModified', { fg = palette.pink.base, bold = true })

hl(0, 'TelescopeNormal', { fg = palette.fg.dim, bg = palette.bg.dark })
hl(0, 'TelescopePreviewNormal', { fg = palette.fg.base, bg = palette.bg.dark })
hl(0, 'TelescopeBorder', { link = 'FloatBorder' })
hl(0, 'TelescopeTitle', { fg = palette.fg.dim, bg = 'none', bold = true })
hl(0, 'TelescopePreviewBorder', { link = 'FloatBorder' })
hl(0, 'TelescopePreviewTitle', { fg = palette.fg.dim, bold = true })
hl(0, 'TelescopePromptNormal', { fg = palette.bg.base, bg = palette.fg.base })
hl(0, 'TelescopePromptBorder', { link = 'TelescopePromptTitle' })
hl(0, 'TelescopePromptTitle', { fg = palette.fg.base, bg = palette.fg.base })
hl(0, 'TelescopePromptPrefix', { fg = palette.bg.base, bg = palette.fg.base })
hl(0, 'TelescopePromptCounter', { link = 'TelescopePromptPrefix' })
hl(0, 'TelescopeSelection', { bg = palette.sel1.base })
hl(0, 'TelescopeSelectionCaret', { link = 'TelescopeSelection' })
hl(0, 'TelescopeMatching', { fg = palette.accent.base })
hl(0, 'TelescopeMultiSelection', { bg = palette.sel.base, bold = true })
hl(0, 'TelescopeMultiIcon', { link = 'TelescopeMultiSelection' })
hl(0, 'TelescopeResultsComment', { fg = palette.fg.dimmer, italic = true })
hl(0, 'TelescopeResultsDiffAdd', { link = 'Added' })
hl(0, 'TelescopeResultsDiffDelete', { link = 'Removed' })
hl(0, 'TelescopeResultsDiffChange', { link = 'Changed' })
hl(0, 'TelescopeResultsIdentifier', { fg = palette.magenta.base, italic = true })

hl(0, 'MasonHeader', { fg = palette.green.base, bg = palette.green.dim })
hl(0, 'MasonHighlight', { fg = palette.green.base, bg = 'none' })
hl(0, 'MasonHighlightBlock', { fg = palette.bg.base, bg = palette.green.bright })
hl(0, 'MasonHighlightBlockBold', { link = 'MasonHeader' })
hl(0, 'MasonMutedBlock', { fg = palette.fg.dimmer, bg = palette.bg.base })

hl(0, 'LualineAdded', { fg = palette.green.base })
hl(0, 'LualineRemoved', { fg = palette.red.base })
hl(0, 'LualineModified', { fg = palette.yellow.base })
hl(0, 'LualineTablineActive', { fg = palette.bg.base, bg = palette.blue.base })
hl(0, 'LualineTablineActiveAlt', { fg = palette.fg.base, bg = palette.bg.base, bold = true, underline = true })
hl(0, 'LualineTablineInactive', { fg = palette.fg.base, bg = palette.bg.dark })
hl(0, 'LualineExecutable', { fg = palette.green.base, bg = 'none' })
hl(0, 'LualineSuccess', { fg = palette.green.base, bg = 'none' })
hl(0, 'LualineNotice', { fg = palette.fg.dimmer, bg = 'none' })
hl(0, 'LualineError', { fg = palette.red.base, bg = 'none' })
hl(0, 'LualineWarning', { fg = palette.yellow.base, bg = 'none' })
hl(0, 'LualineMacroRecording', { fg = palette.red.base, bg = 'none' })

hl(0, 'FidgetTitle', { link = 'Title' })
hl(0, 'FidgetTask', { link = 'LineNr' })
hl(0, 'FidgetGroup', { fg = palette.pink.base, bold = true })
hl(0, 'FidgetNormal', { fg = palette.fg.base, bg = palette.bg.dark })
hl(0, 'FidgetBorder', { link = 'FidgetNormal' })
hl(0, 'FidgetProgress', { fg = palette.orange.base })
hl(0, 'FidgetDone', { fg = palette.green.base })
hl(0, 'FidgetGroupSeparator', { fg = palette.fg.dimmer })
hl(0, 'NotifyDEBUGTitle', { fg = palette.magenta.base })
hl(0, 'NotifyINFOTitle', { fg = palette.blue.base })
hl(0, 'NotifyWARNTitle', { fg = palette.yellow.base })
hl(0, 'NotifyERRORTitle', { fg = palette.red.base })
hl(0, 'NotifyTRACETitle', { fg = palette.fg.dim })
hl(0, 'NotifyERRORBorder', { fg = palette.red.base })
hl(0, 'NotifyWARNBorder', { fg = palette.yellow.base })
hl(0, 'NotifyINFOBorder', { fg = palette.blue.base })
hl(0, 'NotifyDEBUGBorder', { fg = palette.cyan.base })
hl(0, 'NotifyTRACEBorder', { fg = palette.bg.border })
hl(0, 'NotifyERRORIcon', { link = 'NotifyERRORTitle' })
hl(0, 'NotifyWARNIcon', { link = 'NotifyWARNTitle' })
hl(0, 'NotifyINFOIcon', { link = 'NotifyINFOTitle' })
hl(0, 'NotifyDEBUGIcon', { link = 'NotifyDEBUGTitle' })
hl(0, 'NotifyTRACEIcon', { link = 'NotifyTRACETitle' })
hl(0, 'NotifyBackground', { link = 'NormalFloat' })

hl(0, 'MarkSignHL', { fg = palette.pink.base, bg = palette.pink.dim })
hl(0, 'MarkSignNumHL', { fg = palette.fg.dim, bg = palette.pink.dim })
hl(0, 'MarkVirtTextHL', { fg = palette.pink.base, bg = palette.pink.dim })

hl(0, 'MarkviewCode', { fg = 'none', bg = palette.bg.dimmer })
hl(0, 'MarkviewCodeLabel', { fg = palette.bg.dimmer, bg = palette.yellow.base, bold = true })
hl(0, 'MarkviewInlineCode', { fg = 'none', bg = palette.bg.dimmer })
hl(0, 'MarkviewHyperlink', { fg = palette.magenta.base, bg = 'none', italic = true })
hl(0, 'MarkviewImage', { fg = palette.blue.base, bg = 'none', italic = true })
hl(0, 'MarkviewBlockQuoteDefault', { fg = palette.fg.dim, bg = 'none' })
hl(0, 'MarkviewBlockQuoteError', { fg = palette.red.base, bg = 'none' })
hl(0, 'MarkviewBlockQuoteNote', { fg = palette.blue.base, bg = 'none' })
hl(0, 'MarkviewBlockQuoteOk', { fg = palette.green.base, bg = 'none' })
hl(0, 'MarkviewBlockQuoteSpecial', { fg = palette.yellow.base, bg = 'none' })
hl(0, 'MarkviewBlockQuoteWarn', { fg = palette.yellow.base, bg = 'none' })
hl(0, 'MarkviewFatHeading1', { fg = palette.pink.base, bg = palette.pink.dim })
hl(0, 'MarkviewFatHeading2', { fg = palette.green.base, bg = palette.green.dim })
hl(0, 'MarkviewHeading1', { fg = palette.pink.base, bg = palette.pink.dim })
hl(0, 'MarkviewHeading2', { fg = palette.green.base, bg = 'none' })
hl(0, 'MarkviewHeading3', { fg = palette.blue.base, bg = 'none' })
hl(0, 'MarkviewHeading4', { fg = palette.yellow.base, bg = 'none' })
hl(0, 'MarkviewHeading5', { fg = palette.cyan.base, bg = 'none' })
hl(0, 'MarkviewHeading6', { fg = palette.magenta.base, bg = 'none' })
hl(0, 'MarkviewListItemMinus', { fg = palette.pink.dim, bg = 'none' })
hl(0, 'MarkviewListItemStar', { fg = palette.green.dim, bg = 'none' })
hl(0, 'MarkviewListItemPlus', { fg = palette.cyan.dim, bg = 'none' })
hl(0, 'MarkviewPalette0', { fg = 'none', bg = palette.bg.dark })
hl(0, 'MarkviewPalette1', { fg = palette.bg.base, bg = palette.pink.base })
hl(0, 'MarkviewPalette2', { fg = palette.bg.base, bg = palette.green.base })
hl(0, 'MarkviewPalette3', { fg = palette.bg.base, bg = palette.blue.base })
hl(0, 'MarkviewPalette4', { fg = palette.bg.base, bg = palette.yellow.base })
hl(0, 'MarkviewPalette5', { fg = palette.bg.base, bg = palette.cyan.base })
hl(0, 'MarkviewPalette6', { fg = palette.bg.base, bg = palette.magenta.base })
hl(0, 'MarkviewPalette1Sign', { fg = palette.pink.base, bg = 'none' })
hl(0, 'MarkviewPalette2Sign', { fg = palette.green.base, bg = 'none' })
hl(0, 'MarkviewPalette3Sign', { fg = palette.blue.base, bg = 'none' })
hl(0, 'MarkviewPalette4Sign', { fg = palette.yellow.base, bg = 'none' })
hl(0, 'MarkviewPalette5Sign', { fg = palette.cyan.base, bg = 'none' })
hl(0, 'MarkviewPalette6Sign', { fg = palette.magenta.base, bg = 'none' })
hl(0, 'MarkviewCheckboxChecked', { fg = palette.green.base, bg = 'none' })
hl(0, 'MarkviewCheckboxUnchecked', { fg = palette.yellow.base, bg = 'none' })
hl(0, 'MarkviewCheckboxStriked', { fg = palette.fg.dim, bg = 'none', strikethrough = true })
hl(0, 'MarkviewGradient0', { fg = '#cccdc1', bg = 'none' })
hl(0, 'MarkviewGradient1', { fg = '#c4c8bd', bg = 'none' })
hl(0, 'MarkviewGradient2', { fg = '#bdc3b9', bg = 'none' })
hl(0, 'MarkviewGradient3', { fg = '#b6bfb5', bg = 'none' })
hl(0, 'MarkviewGradient4', { fg = '#afbab1', bg = 'none' })
hl(0, 'MarkviewGradient5', { fg = '#a9b5ae', bg = 'none' })
hl(0, 'MarkviewGradient6', { fg = '#a2b0aa', bg = 'none' })
hl(0, 'MarkviewGradient7', { fg = '#9daaa7', bg = 'none' })
hl(0, 'MarkviewGradient8', { fg = '#97a5a3', bg = 'none' })
hl(0, 'MarkviewGradient9', { fg = '#92a0a0', bg = 'none' })

hl(0, 'NeogitNormal', { fg = palette.fg.dim })
hl(0, 'NeogitNotificationInfo', { fg = palette.blue.base })
hl(0, 'NeogitNotificationWarning', { fg = palette.yellow.base })
hl(0, 'NeogitNotificationError', { fg = palette.red.base })
hl(0, 'NeogitFloatBorder', { link = 'WinSeparatorThin' })
hl(0, 'NeogitWinSeparator', { link = 'WinSeparatorThin' })
hl(0, 'NeogitFloatHeader', { fg = palette.bg.base, bg = palette.fg.base })
hl(0, 'NeogitFloatHeaderHighlight', { fg = palette.bg.base, bg = palette.fg.base, bold = true })
hl(0, 'NeogitCommitViewHeader', { link = 'NeogitFloatHeader' })
hl(0, 'NeogitActiveItem', { bg = palette.sel.base })
hl(0, 'NeogitPopupBranchName', { link = 'NeogitBranch' })
hl(0, 'NeogitPopupSectionTitle', { fg = palette.fg.dimmer, bold = true })
hl(0, 'NeogitPopupActionKey', { fg = palette.pink.base })
hl(0, 'NeogitPopupOptionKey', { fg = palette.fg.dimmer })
hl(0, 'NeogitPopupSwitchKey', { link = 'NeogitPopupOptionKey' })
hl(0, 'NeogitPopupConfigKey', { link = 'NeogitPopupOptionKey' })
hl(0, 'NeogitPopupSwitchEnabled', { fg = palette.yellow.base })
hl(0, 'NeogitPopupConfigEnabled', { link = 'NeogitPopupSwitchEnabled' })
hl(0, 'NeogitPopupOptionEnabled', { link = 'NeogitPopupSwitchEnabled' })
hl(0, 'NeogitPopupActionDisabled', { fg = palette.fg.dimmer, italic = true })
hl(0, 'NeogitPopupSwitchDisabled', { fg = palette.fg.dimmer, italic = true })
hl(0, 'NeogitPopupConfigDisabled', { link = 'NeogitPopupSwitchDisabled' })
hl(0, 'NeogitPopupOptionDisabled', { link = 'NeogitPopupSwitchDisabled' })
hl(0, 'NeogitChangeNewfile', { fg = palette.green.base })
hl(0, 'NeogitChangeModified', { fg = palette.yellow.base })
hl(0, 'NeogitChangeCopied', { fg = palette.green.base })
hl(0, 'NeogitChangeAdded', { fg = palette.green.base })
hl(0, 'NeogitChangeDeleted', { fg = palette.red.base })
hl(0, 'NeogitChangeRenamed', { fg = palette.fg.dimmer })
hl(0, 'NeogitChangeUntrackeduntracked', { fg = palette.fg.dimmer })
hl(0, 'NeogitStashes', { fg = palette.fg.dim, bold = true })
hl(0, 'NeogitObjectId', { fg = palette.magenta.dim, italic = true })
hl(0, 'NeogitBranch', { link = '@git.branch' })
hl(0, 'NeogitRemote', { link = 'NeogitBranch' })
hl(0, 'NeogitBranchHead', { link = 'NeogitBranch' })
hl(0, 'NeogitTagName', { fg = palette.pink.base, bg = palette.pink.dim })
hl(0, 'NeogitStatusHead', { fg = palette.fg.dimmer, bg = 'none', bold = true })
hl(0, 'NeogitSubtleText', { fg = palette.fg.dim, italic = true })
hl(0, 'NeogitFilePath', { fg = palette.blue.base, italic = true })
hl(0, 'NeogitTagDistance', { fg = palette.fg.dimmer, italic = true })
hl(0, 'NeogitSectionHeader', { fg = palette.fg.dimmer, bold = true })
hl(0, 'NeogitStagedchanges', { fg = palette.green.base, bg = palette.green.dimmer, bold = true })
hl(0, 'NeogitUnstagedchanges', { fg = palette.yellow.base, bg = palette.yellow.dimmer, bold = true })
hl(0, 'NeogitUntrackedfiles', { fg = palette.red.base, bg = palette.red.dimmer, bold = true })
hl(0, 'NeogitMerging', { fg = palette.pink.base, bg = palette.pink.dimmer, bold = true })
hl(0, 'NeogitRebasing', { link = 'NeogitMerging' })
hl(0, 'NeogitDiffHeader', { fg = palette.fg.base, bold = true })
hl(0, 'NeogitDiffHeaderHighlight', { fg = palette.fg.base, bold = true })
hl(0, 'NeogitDiffAdditions', { fg = palette.green.base })
hl(0, 'NeogitDiffDeletions', { fg = palette.red.base })
hl(0, 'NeogitDiffAdd', { fg = palette.green.base, bg = palette.bg.dim })
hl(0, 'NeogitDiffAddInLine', { bg = palette.green.dim, italic = true })
hl(0, 'NeogitDiffAddHighlight', { fg = palette.green.base, bg = palette.green.dimmer })
hl(0, 'NeogitDiffAddCursor', { fg = palette.green.base, bg = palette.green.dimmer, bold = true })
hl(0, 'NeogitDiffDelete', { fg = palette.red.base, bg = palette.bg.dim })
hl(0, 'NeogitDiffDeleteInLine', { bg = palette.red.dim, italic = true })
hl(0, 'NeogitDiffDeleteHighlight', { fg = palette.red.base, bg = palette.red.dimmer })
hl(0, 'NeogitDiffDeleteCursor', { fg = palette.red.base, bg = palette.red.dimmer, bold = true })
hl(0, 'NeogitDiffContext', { fg = palette.fg.dimmer, bg = palette.bg.dim })
hl(0, 'NeogitDiffContextHighlight', { fg = palette.fg.dimmer, bg = palette.bg.dim })
hl(0, 'NeogitDiffContextCursor', { fg = palette.fg.dimmer, bg = palette.bg.dim, bold = true })
hl(0, 'NeogitHunkHeader', { fg = palette.blue.base, bg = 'NONE' })
hl(0, 'NeogitHunkHeaderHighlight', { fg = palette.blue.base, bg = palette.blue.dimmer })
hl(0, 'NeogitHunkHeaderCursor', { fg = palette.blue.base, bg = palette.blue.dimmer, bold = true })
hl(0, 'NeogitHunkMergeHeader', { fg = palette.fg.dimmer, bg = palette.sel.base })
hl(0, 'NeogitHunkMergeHeaderHighlight', { fg = palette.fg.dimmer, bg = palette.sel1.base })
hl(0, 'NeogitHunkMergeHeaderCursor', { fg = palette.fg.dimmer, bg = palette.sel1.base, bold = true })
hl(0, 'NeogitGraphAuthor', { fg = palette.fg.dimmer })
hl(0, 'NeogitGraphOrange', { fg = palette.orange.dim })
hl(0, 'NeogitGraphBoldOrange', { fg = palette.orange.dim, bold = true })
hl(0, 'NeogitGraphYellow', { fg = palette.yellow.dim })
hl(0, 'NeogitGraphBoldYellow', { fg = palette.yellow.dim, bold = true })
hl(0, 'NeogitGraphGray', { fg = palette.fg.dim })
hl(0, 'NeogitGraphBoldGray', { fg = palette.fg.dim, bold = true })
hl(0, 'NeogitGraphRed', { fg = palette.red.dim })
hl(0, 'NeogitGraphBoldRed', { fg = palette.red.dim, bold = true })
hl(0, 'NeogitGraphBlue', { fg = palette.blue.dim })
hl(0, 'NeogitGraphBoldBlue', { fg = palette.blue.dim, bold = true })
hl(0, 'NeogitGraphCyan', { fg = palette.cyan.dim })
hl(0, 'NeogitGraphBoldCyan', { fg = palette.cyan.dim, bold = true })
hl(0, 'NeogitGraphGreen', { fg = palette.green.dim })
hl(0, 'NeogitGraphBoldGreen', { fg = palette.green.dim, bold = true })
hl(0, 'NeogitGraphPurple', { fg = palette.magenta.dim })
hl(0, 'NeogitGraphBoldPurple', { fg = palette.magenta.dim, bold = true })
hl(0, 'NeogitGraphWhite', { fg = palette.white.dim })
hl(0, 'NeogitGraphBoldWhite', { fg = palette.white.dim, bold = true })

hl(0, 'CodeDiffMoveTo', { fg = palette.blue.base })
hl(0, 'CodeDiffMoveFrom', { link = 'CodeDiffMoveTo' })

hl(0, '@comment.gitcommit', { fg = palette.fg.dimmer, bg = 'none' })
hl(0, '@markup.heading.gitcommit', { fg = palette.fg.base, bg = 'none' })
hl(0, '@text.reference.gitcommit', { link = '@markup.link.gitcommit' })
hl(0, '@text.uri.gitcommit', { fg = palette.fg.base, bg = 'none' })
hl(0, '@string.special.path.gitcommit', { fg = palette.magenta.base, bg = 'none' })
hl(0, '@keyword.gitcommit', { fg = palette.orange.base, bg = 'none' })
hl(0, '@markup.heading.git_config', { fg = palette.yellow.base })
hl(0, '@string.special.path.git_config', { link = '@string' })
hl(0, '@comment.git', { fg = palette.fg.dimmer })
hl(0, '@git.subject', { fg = palette.fg.base, bold = true })
hl(0, '@git.message', { fg = palette.fg.dim })
hl(0, '@git.branch', { fg = palette.magenta.base, bg = palette.magenta.dimmer })
hl(0, '@git.title.committed', { fg = palette.green.base, bg = 'none', bold = true })
hl(0, '@git.title.not_committed', { fg = palette.yellow.base, bg = 'none', bold = true })
hl(0, '@git.title.untracked', { fg = palette.red.base, bg = 'none', bold = true })
hl(0, '@git.change.deleted', { fg = palette.fg.dim, bg = 'none' })
hl(0, '@git.change.modified', { fg = palette.fg.dim, bg = 'none' })
hl(0, '@git.change.new', { fg = palette.fg.dim, bg = 'none' })
hl(0, '@git.change.renamed', { fg = palette.fg.dim, bg = 'none' })
hl(0, '@git.change.deleted.filepath', { fg = palette.red.base, bg = 'none' })
hl(0, '@git.change.modified.filepath', { fg = palette.yellow.base, bg = 'none' })
hl(0, '@git.change.new.filepath', { fg = palette.green.base, bg = 'none' })
hl(0, '@git.change.renamed.filepath', { fg = palette.orange.base, bg = 'none' })
hl(0, '@keyword.git_rebase.pick', { fg = palette.green.base })
hl(0, '@keyword.git_rebase.reword', { fg = palette.blue.base })
hl(0, '@keyword.git_rebase.edit', { fg = palette.blue.base })
hl(0, '@keyword.git_rebase.squash', { fg = palette.orange.base })
hl(0, '@keyword.git_rebase.fixup', { fg = palette.orange.base })
hl(0, '@keyword.git_rebase.exec', { fg = palette.pink.base })
hl(0, '@keyword.git_rebase.break', { fg = palette.pink.base })
hl(0, '@keyword.git_rebase.drop', { fg = palette.red.base })
hl(0, '@keyword.git_rebase.label', { fg = palette.pink.base })
hl(0, '@keyword.git_rebase.reset', { fg = palette.pink.base })
hl(0, '@keyword.git_rebase.merge', { fg = palette.pink.base })
hl(0, '@keyword.git_rebase.update-ref', { fg = palette.pink.base })
hl(0, '@keyword.git_rebase.invalid', { fg = palette.red.base, bg = palette.red.dim, undercurl = true })
hl(0, '@constant.git_rebase', { fg = palette.magenta.base, italic = true })
hl(0, '@none.git_rebase', { fg = palette.fg.dim })
hl(0, '@string.special.path.gitignore', { link = '@normal' })
hl(0, '@punctuation.delimiter.gitignore', { fg = palette.fg.dimmer })
hl(0, '@character.special.gitignore', { link = '@normal' })

hl(0, 'DiffAdd', { bg = palette.green.dim })
hl(0, 'DiffDelete', { fg = palette.red.dim, bg = palette.red.dim })
hl(0, 'DiffChange', { bg = palette.yellow.dim })
hl(0, 'DiffText', { bg = palette.blue.dim })
hl(0, 'diffAdded', { link = 'DiffAdd' })
hl(0, 'diffRemoved', { link = 'DiffDelete' })
hl(0, 'diffChanged', { link = 'DiffChange' })
hl(0, 'diffOldFile', { fg = palette.yellow.base })
hl(0, 'diffNewFile', { fg = palette.blue.base })
hl(0, 'diffFile', { fg = palette.blue.base })
hl(0, 'diffLine', { link = 'DiffText' })
hl(0, 'diffIndexLine', { link = 'DiffText' })

hl(0, 'GitSignsAdd', { fg = palette.green.base, bg = palette.green.dim })
hl(0, 'GitSignsAddNr', { link = 'GitSignsAdd' })
hl(0, 'GitSignsAddLn', { fg = 'none' })
hl(0, 'GitSignsAddInline', { fg = 'none', bg = palette.green.base })
hl(0, 'GitSignsAddInlineNr', { link = 'GitSignsAddInline' })
hl(0, 'GitSignsAddInlineLn', { fg = 'none' })
hl(0, 'GitSignsDelete', { fg = palette.red.base, bg = palette.red.dim })
hl(0, 'GitSignsDeleteNr', { link = 'GitSignsDelete' })
hl(0, 'GitSignsTopDelete', { link = 'GitSignsDelete' })
hl(0, 'GitSignsTopDeleteNr', { link = 'GitSignsTopDelete' })
hl(0, 'GitSignsDeleteInline', { fg = 'none', bg = palette.red.base })
hl(0, 'GitSignsDeleteInlineNr', { link = 'GitSignsDeleteInline' })
hl(0, 'GitSignsDeleteInlineLn', { fg = 'none' })
hl(0, 'GitSignsChange', { fg = palette.yellow.base, bg = palette.yellow.dim })
hl(0, 'GitSignsChangeNr', { link = 'GitSignsChange' })
hl(0, 'GitSignsChangeLn', { fg = 'none' })
hl(0, 'GitSignsChangeInline', { fg = 'none', bg = palette.yellow.base })
hl(0, 'GitSignsChangeInlineNr', { link = 'GitSignsChangeInline' })
hl(0, 'GitSignsChangeInlineLn', { fg = 'none' })
hl(0, 'GitSignsChangeDelete', { fg = palette.magenta.base, bg = palette.magenta.dim })
hl(0, 'GitSignsChangeDeleteNr', { link = 'GitSignsChangeDelete' })
hl(0, 'GitSignsChangeDeleteLn', { fg = 'none' })
hl(0, 'GitSignsStagedAdd', { fg = palette.fg.dim, bg = palette.bg.base })
hl(0, 'GitSignsStagedAddNr', { link = 'GitSignsStagedAdd' })
hl(0, 'GitSignsStagedAddLn', { fg = 'none', bg = palette.bg.base })
hl(0, 'GitSignsStagedDelete', { fg = palette.fg.dim, bg = palette.bg.base })
hl(0, 'GitSignsStagedDeleteNr', { link = 'GitSignsStagedDelete' })
hl(0, 'GitSignsStagedTopDelete', { link = 'GitSignsStagedDelete' })
hl(0, 'GitSignsStagedTopDeleteNr', { link = 'GitSignsStagedDeleteNr' })
hl(0, 'GitSignsStagedChange', { fg = palette.fg.dim, bg = palette.bg.base })
hl(0, 'GitSignsStagedChangeNr', { link = 'GitSignsStagedChange' })
hl(0, 'GitSignsStagedChangeLn', { fg = 'none', bg = palette.bg.dark })
hl(0, 'GitSignsStagedChangeDelete', { link = 'GitSignsStagedChange' })
hl(0, 'GitSignsStagedChangeDeleteNr', { link = 'GitSignsStagedChangeNr' })
hl(0, 'GitSignsStagedChangeDeleteLn', { link = 'GitSignsStagedChangeLn' })
hl(0, 'GitSignsCurrentLineBlame', { fg = palette.fg.dim, bg = palette.bg.dark, italic = true })

hl(0, 'CmpGhostText', { fg = palette.fg.dimmer })
hl(0, 'CmpDocumentation', { fg = palette.fg.base, bg = palette.bg.dark })
hl(0, 'CmpDocumentationBorder', { fg = palette.sel.dim, bg = palette.bg.dark })
hl(0, 'CmpItemMenu', { link = 'Comment' })
hl(0, 'CmpItemAbbr', { fg = palette.fg.base })
hl(0, 'CmpItemAbbrMatch', { fg = palette.green.base })
hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpItemAbbrMatch' })
hl(0, 'CmpItemAbbrDeprecated', { fg = palette.fg.dim, strikethrough = true })
hl(0, 'CmpItemKind', { fg = palette.fg.dim })
hl(0, 'CmpItemKindText', { fg = palette.fg.dimmer })
hl(0, 'CmpItemKindSnippet', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindCopilot', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindVariable', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindEnum', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindEnumMember', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindFile', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindField', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindProperty', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindModule', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindDirectory', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindFolder', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindKeyword', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindFunction', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindMethod', { link = 'CmpItemKind' })
hl(0, 'CmpItemKindConstant', { link = "Constant" })
hl(0, 'CmpItemKindReference', { link = "Keyword" })
hl(0, 'CmpItemKindValue', { link = "Keyword" })
hl(0, 'CmpItemKindConstructor', { link = "Function" })
hl(0, 'CmpItemKindInterface', { link = "Constant" })
hl(0, 'CmpItemKindEvent', { link = "Constant" })
hl(0, 'CmpItemKindUnit', { link = "Constant" })
hl(0, 'CmpItemKindClass', { link = "Type" })
hl(0, 'CmpItemKindStruct', { link = "Type" })
hl(0, 'CmpItemKindTypeParameter', { link = "Identifier" })
hl(0, 'CmpItemKindOperator', { link = "Operator" })
hl(0, 'CmpItemKindDefault', { link = 'CmpItemKind' })

hl(0, '@variable.member.ledger', { link = '@property' })
hl(0, '@number.ledger', { fg = palette.green.base })
hl(0, '@number.negative.ledger', { fg = palette.red.base })
hl(0, '@markup.raw.ledger', { fg = palette.fg.dimmer })
hl(0, '@string.special.ledger', { fg = palette.pink.base, bold = true })

hl(0, 'TodoBgFIX', { fg = palette.bg.base, bg = palette.red.base })
hl(0, 'TodoFgFIX', { fg = palette.red.base })
hl(0, 'TodoBgTODO', { fg = palette.bg.base, bg = palette.magenta.base })
hl(0, 'TodoFgTODO', { fg = palette.magenta.base })
hl(0, 'TodoBgHACK', { fg = palette.bg.base, bg = palette.red.base })
hl(0, 'TodoFgHACK', { fg = palette.red.base, bg = 'none' })
hl(0, 'TodoBgWARN', { fg = palette.bg.base, bg = palette.yellow.base })
hl(0, 'TodoFgWARN', { fg = palette.yellow.base })
hl(0, 'TodoBgPERF', { fg = palette.bg.base, bg = palette.cyan.base })
hl(0, 'TodoFgPERF', { fg = palette.cyan.base })
hl(0, 'TodoBgNOTE', { fg = palette.bg.base, bg = palette.magenta.base })
hl(0, 'TodoFgNOTE', { fg = palette.magenta.base })
hl(0, 'TodoBgTEST', { fg = palette.bg.base, bg = palette.cyan.base })
hl(0, 'TodoFgTEST', { fg = palette.cyan.base })

hl(0, 'ExchangeRegion', { fg = palette.bg.base, bg = palette.orange.base })

hl(0, 'Cursorword', { fg = palette.bg.base, bg = palette.pink.base })

local _, lualine = pcall(require, 'lualine')
if lualine then
  lualine.setup({
    options = {
      theme = {
        normal = {
          a = { fg = palette.bg.base, bg = palette.accent.base },
          b = { fg = palette.fg.base, bg = palette.accent.dim },
          c = { fg = palette.fg.dim, bg = palette.bg.dim },
        },
        insert = {
          a = { fg = palette.bg.base, bg = palette.green.base },
          b = { fg = palette.fg.base, bg = palette.green.dim },
          c = { fg = palette.fg.dim, bg = palette.bg.dim },
        },
        command = {
          a = { fg = palette.bg.base, bg = palette.fg.base },
          b = { fg = palette.fg.base, bg = palette.fg.dim },
          c = { fg = palette.fg.dim, bg = palette.bg.dim },
        },
        visual = {
          a = { fg = palette.bg.base, bg = palette.blue.base },
          b = { fg = palette.fg.base, bg = palette.blue.dim },
          c = { fg = palette.fg.dim, bg = palette.bg.dim },
        },
        replace = {
          a = { fg = palette.bg.base, bg = palette.red.base },
          b = { fg = palette.fg.base, bg = palette.red.dim },
          c = { fg = palette.fg.dim, bg = palette.bg.dim },
        },
        terminal = {
          a = { fg = palette.bg.base, bg = palette.fg.base },
          b = { fg = palette.fg.base, bg = palette.fg.dim },
          c = { fg = palette.fg.dim, bg = palette.bg.dim },
        },
        inactive = {
          a = { fg = palette.bg.base, bg = palette.accent.base },
          b = { fg = palette.fg.base, bg = palette.accent.dim },
          c = { fg = palette.fg.dim, bg = palette.bg.dim },
        }
      }
    }
  })
end

local _, devicons = pcall(require, 'nvim-web-devicons')
if devicons then devicons.set_default_icon('', palette.fg.dim, 0) end
