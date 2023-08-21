require('NeoSolarized').setup {
  style = "light",
  transparent = false,
  on_highlights = function(hi, c)
    hi.TelescopeBorder = { fg = c.bg2, bg = c.bg2 }
    hi.TelescopePromptTitle = { fg = c.fg2, bg = c.fg2 }
    hi.TelescopePromptNormal = { fg = c.bg2, bg = c.fg2 }
    hi.TelescopePromptPrefix = { fg = c.bg2, bg = c.fg2 }
    hi.TelescopePromptCounter = { fg = c.bg2, bg = c.fg2 }
    hi.TelescopePromptBorder = { fg = c.fg2, bg = c.fg2 }

    hi.TelescopeMatching = { link = 'Folded' }
    hi.TelescopeNormal = { bg = c.bg2 }
    hi.TelescopeResultsNormal = { fg = c.fg2, bg = c.bg2 }
    hi.TelescopeSelection = { fg = c.fg0, bg = c.bg1 }

    hi.Tabline = { fg = c.fg2, bg = c.bg1 }
    hi.TablineSel = { fg = c.purple, bg = c.bg }
    hi.TablineFill = { fg = c.fg2, bg = c.bg }

    hi.Comment = { fg = c.fg2 }
    hi.Folded = { fg = c.fg1, bg = c.bg1 }

    hi.VertSplit = { bg = c.bg1 }
    hi.NormalNC = { bg = c.bg1 }
    hi.SignColumn = { bg = c.bg1 }

    hi.MarkSignHL = { bg = c.bg1 }
    hi.MarkSignNumHL = { bg = c.bg1 }
    hi.MarkVirtTextHL = { fg = c.color5, bg = c.color7 }

    hi.LineNr = { fg = c.purple, bg = c.bg1 }
    hi.LineNrAbove = { fg = c.fg2, bg = c.bg1 }
    hi.LineNrBelow = { fg = c.fg2, bg = c.bg1 }

    hi.GitGutterAdd = { fg = c.green, bg = c.bg1 }
    hi.GitGutterChange = { fg = c.yellow, bg = c.bg1 }
    hi.GitGutterDelete = { fg = c.red, bg = c.bg1 }

    hi.DiffAdd = { fg = c.green, bg = c.none }
    hi.DiffChange = { fg = c.yellow, bg = c.none }
    hi.DiffDelete = { fg = c.red, bg = c.none }

    hi.QuickFixLine = { fg = c.yellow, bg = c.none }

    hi.NeomakeVirtualtextError = { link = 'ErrorMsg' }
    hi.NeomakeVirtualtextWarning = { link = 'WarningMsg' }
    hi.NeomakeVirtualtextInfo = { link = 'WarningMsg' }
    hi.NeomakeVirtualtextMessage = { link = 'WarningMsg' }
  end,
}

local group = vim.api.nvim_create_augroup("text_yank", {})
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function() vim.highlight.on_yank({ higroup="Folded", timeout=200 }) end,
  group = group,
})

vim.cmd [[ colorscheme NeoSolarized ]]
