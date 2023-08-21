require('NeoSolarized').setup {
  style = "light", -- "dark" or "light"
  transparent = false, -- true/false; Enable this to disable setting the background color
  terminal_colors = false, -- Configure the colors used when opening a `:terminal` in Neovim
  enable_italics = false, -- Italics for different hightlight groups (eg. Statement, Condition, Comment, Include, etc.)
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
    functions = { bold = false },
    variables = {},
    string = { italic = false },
    underline = false, -- true/false; for global underline
    undercurl = false, -- true/false; for global undercurl
  },
  -- Add specific hightlight groups
  on_highlights = function(hi, c)
    hi.TelescopeBorder = { fg = c.bg2, bg = c.bg2 }
    hi.TelescopePromptTitle = { fg = c.fg2, bg = c.fg2 }
    hi.TelescopePromptNormal = { fg = c.bg2, bg = c.fg2 }
    hi.TelescopePromptPrefix = { fg = c.bg2, bg = c.fg2 }
    hi.TelescopePromptCounter = { fg = c.bg2, bg = c.fg2 }
    hi.TelescopePromptBorder = { fg = c.fg2, bg = c.fg2 }

    hi.TelescopeMatching = { bg = c.bg1, fg = none }
    hi.TelescopeNormal = { fg = c.fg0, bg = c.bg2 }
    hi.TelescopeSelection = { link = "diffAdded" }

    hi.Tabline = { link = 'Normal' }
    hi.TablineFill = { link = 'Normal' }
    hi.TablineSel = { fg = c.purple, bg = c.bg2 }

    hi.Comment = { fg = c.fg2 }
    hi.Folded = { fg = c.fg1, bg = c.bg1 }
    hi.HighlightedyankRegion = { link = 'Folded' }

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

vim.cmd [[ colorscheme NeoSolarized ]]
