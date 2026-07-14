return function(palette)
  -- bash
  vim.api.nvim_set_hl(0, '@string.special.path.bash', { fg = palette.magenta.base })

  -- query
  vim.api.nvim_set_hl(0, '@function.call.query', { fg = palette.blue.base })
  vim.api.nvim_set_hl(0, '@comment.query', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, '@keyword.directive.query', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, '@variable.query', { fg = palette.magenta.base })

  -- latex
  vim.api.nvim_set_hl(0, '@string.special.path.latex', { fg = palette.blue.base })
  vim.api.nvim_set_hl(0, '@markup.math.latex', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, '@function.latex', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, '@function.linebreak.latex', { link = '@operator' })

  -- ledger
  vim.api.nvim_set_hl(0, '@variable.member.ledger', { link = '@property' })
  vim.api.nvim_set_hl(0, '@number.ledger', { fg = palette.green.base })
  vim.api.nvim_set_hl(0, '@number.negative.ledger', { fg = palette.red.base })
  vim.api.nvim_set_hl(0, '@markup.raw.ledger', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, '@string.special.ledger', { fg = palette.magenta.base, bold = true })

  -- lua
  vim.api.nvim_set_hl(0, '@constructor.lua', { link = '@punctuation.bracket' })
  vim.api.nvim_set_hl(0, '@keyword.operator.lua', { link = '@keyword' })

  vim.api.nvim_set_hl(0, '@comment.luadoc', { link = '@comment.documentation.lua' })
  vim.api.nvim_set_hl(0, '@keyword.luadoc', { fg = palette.fg.dim, bold = true })
  vim.api.nvim_set_hl(0, '@keyword.function.luadoc', { link = '@type' })
  vim.api.nvim_set_hl(0, '@keyword.import.luadoc', { link = '@keyword.luadoc' })
  vim.api.nvim_set_hl(0, '@keyword.return.luadoc', { link = '@keyword.luadoc' })

  -- make
  vim.api.nvim_set_hl(0, '@function.builtin.make', { link = 'makeConfig' })
  vim.api.nvim_set_hl(0, '@function.make', { fg = palette.blue.base, bg = 'none' })
  vim.api.nvim_set_hl(0, '@operator.make', { fg = palette.fg.dim, bg = 'none' })
  vim.api.nvim_set_hl(0, 'makeSpecial', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'makeCommands', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, 'makeTarget', { fg = palette.blue.base })
  vim.api.nvim_set_hl(0, 'makeSpecTarget', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'makePreCondit', { link = '@keyword.conditional' })
  vim.api.nvim_set_hl(0, 'makeStatement', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, 'makeDefine', { link = '@keyword' })

  -- just
  vim.api.nvim_set_hl(0, '@function.just', { fg = palette.blue.base })
  vim.api.nvim_set_hl(0, '@attribute.builtin.just', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, '@attribute.default', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, '@variable.parameter.just', { fg = palette.fg.dim, italic = true })
  vim.api.nvim_set_hl(0, '@variable.just', { fg = palette.magenta.base })

  -- go
  vim.api.nvim_set_hl(0, '@function.gotmpl', { fg = palette.blue.base, bg = 'none' })
  vim.api.nvim_set_hl(0, '@function.builtin.gotmpl', { fg = palette.fg.dim, bg = 'none' })
  vim.api.nvim_set_hl(0, '@variable.member.gotmpl', { fg = palette.fg.dim, bg = 'none' })

  -- ruby
  vim.api.nvim_set_hl(0, '@comment.directive', { fg = palette.fg.dimmer, bg = palette.bg.base })
  -- vim.api.nvim_set_hl(0, '@keyword.directive.define', {})
  vim.api.nvim_set_hl(0, '@keyword.directive', { link = '@comment.directive' })
  vim.api.nvim_set_hl(0, '@string.special.symbol.ruby', { link = '@string.ruby' })
  vim.api.nvim_set_hl(0, '@operator.ternary.ruby', { link = '@keyword.conditional.ruby' })
  vim.api.nvim_set_hl(0, '@punctuation.special.ruby', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, '@function.builtin.ruby', { link = '@keyword' })

  -- SQL
  vim.api.nvim_set_hl(0, '@keyword.sql', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, '@keyword.operator.sql', { link = '@keyword.sql' })
  vim.api.nvim_set_hl(0, '@variable.member.sql', { link = '@variable' })

  -- yaml
  vim.api.nvim_set_hl(0, '@property.yaml', { fg = palette.fg.dim, italic = true })
  vim.api.nvim_set_hl(0, '@variable.member.yaml', { fg = palette.green.base })

  -- CSS
  vim.api.nvim_set_hl(0, '@attribute.css', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, '@tag.attribute.css', { link = '@attribute.css' })
  vim.api.nvim_set_hl(0, '@field.css', { link = '@attribute.css' })
  vim.api.nvim_set_hl(0, '@property.css', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, '@character.special.css', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, '@keyword.directive.css', { fg = palette.blue.base })
  vim.api.nvim_set_hl(0, '@constructor.css', { fg = palette.yellow.base })
  vim.api.nvim_set_hl(0, '@tag.css', { link = '@type' })
  vim.api.nvim_set_hl(0, '@type.css', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, '@constant.css', { link = '@type.css' })
  vim.api.nvim_set_hl(0, '@function.css', { link = '@function.call' })

  -- xresources
  vim.api.nvim_set_hl(0, '@character.special.xresources', { link = '@variable' })
  vim.api.nvim_set_hl(0, '@constant.macro.xresources', { link = '@variable' })
  vim.api.nvim_set_hl(0, '@markup.raw.xresources', { link = 'String' })
  vim.api.nvim_set_hl(0, '@keyword.import.xresources', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, '@keyword.directive.define.xresources', { link = '@keyword.import.xresources' })

  -- rasi
  vim.api.nvim_set_hl(0, '@namespace.rasi', { link = '@constructor.css' })
  vim.api.nvim_set_hl(0, '@field.rasi', { link = '@field.css' })
  vim.api.nvim_set_hl(0, '@variable.rasi', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, '@keyword.rasi', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, '@string.special.rasi', { link = '@keyword.rasi' })
  vim.api.nvim_set_hl(0, '@constant.rasi', { fg = palette.yellow.base })
  vim.api.nvim_set_hl(0, '@character.special.rasi', { link = '@constant.rasi' })
  vim.api.nvim_set_hl(0, '@punctuation.special.rasi', { fg = palette.magenta.base })

  -- kitty -> links do not work here for some reason
  vim.api.nvim_set_hl(0, 'kittyString', { fg = palette.green.base })
  vim.api.nvim_set_hl(0, 'kittyKeyword', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, 'kittyMap', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'kittyMapName', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'kittyParameter', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, 'kittyKey', { fg = palette.magenta.base })

  -- zathurarc
  vim.api.nvim_set_hl(0, '@variable.builtin.zathurarc', { link = '@variable' })

  -- vimdoc
  vim.api.nvim_set_hl(0, '@markup.raw.vimdoc', { fg = palette.fg.dim })
  vim.api.nvim_set_hl(0, '@markup.raw.block.vimdoc', { link = '@markup.raw.vimdoc' })
  vim.api.nvim_set_hl(0, '@comment.note.vimdoc', { fg = palette.bg.base, bg = palette.magenta.base })

  -- man pages
  vim.api.nvim_set_hl(0, 'manHeader', { link = 'Title' })
  vim.api.nvim_set_hl(0, 'manFooter', { link = 'manHeader' })
  vim.api.nvim_set_hl(0, 'manOptionDesc', { fg = palette.magenta.base })
  vim.api.nvim_set_hl(0, 'manSectionHeading', { link = 'MarkViewHeading1' })
  vim.api.nvim_set_hl(0, 'manSubHeading', { link = 'MarkViewHeading2' })

  -- edifact
  vim.api.nvim_set_hl(0, 'edifactTag', { fg = palette.accent.base })
  vim.api.nvim_set_hl(0, 'edifactData', { fg = palette.fg.base })
  vim.api.nvim_set_hl(0, 'edifactColon', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'edifactPlusSign', { link = 'edifactColon' })
  vim.api.nvim_set_hl(0, 'edifactAsterisk', { link = 'edifactColon' })
  vim.api.nvim_set_hl(0, 'edifactApostrophe', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'edifactEscape', { link = 'Special' })
  vim.api.nvim_set_hl(0, 'edifactError', { link = 'Error' })
  vim.api.nvim_set_hl(0, 'edifactTagUNA', { fg = palette.fg.dimmer })
  vim.api.nvim_set_hl(0, 'edifactTagSEQ', { fg = palette.bg.base, bg = palette.accent.base })
  vim.api.nvim_set_hl(0, 'edifactTagIND', { fg = palette.accent.base, bg = palette.accent.dimmer, })
end
