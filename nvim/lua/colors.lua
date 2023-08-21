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
  on_highlights = function(highlights, colors)
    highlights.TelescopeBorder = { fg = colors.bg2, bg = colors.bg2 }
    highlights.TelescopePromptTitle = { fg = colors.fg2, bg = colors.fg2 }
    highlights.TelescopePromptNormal = { fg = colors.bg2, bg = colors.fg2 }
    highlights.TelescopePromptPrefix = { fg = colors.bg2, bg = colors.fg2 }
    highlights.TelescopePromptCounter = { fg = colors.bg2, bg = colors.fg2 }
    highlights.TelescopePromptBorder = { fg = colors.fg2, bg = colors.fg2 }

    highlights.TelescopeMatching = { bg = colors.bg1, fg = none }
    highlights.TelescopeNormal = { fg = colors.fg0, bg = colors.bg2 }
    highlights.TelescopeSelection = { link = "diffAdded" }

    highlights.Tabline = { link = 'Normal' }
    highlights.TablineFill = { link = 'Normal' }
    highlights.TablineSel = { fg = colors.purple, bg = colors.none, bold = true }

    highlights.Comment = { fg = colors.fg2 }
    highlights.Folded = { fg = colors.fg1, bg = colors.bg1, bold = true }
    highlights.HighlightedyankRegion = { link = 'Folded' }

    highlights.VertSplit = { bg = colors.bg1 }
    highlights.NormalNC = { bg = colors.bg1 }
    highlights.SignColumn = { bg = colors.bg1 }

    highlights.MarkSignHL = { bg = colors.bg1 }
    highlights.MarkSignNumHL = { bg = colors.bg1 }
    highlights.MarkVirtTextHL = { fg = colors.color5, bg = colors.color7, underline = true }

    highlights.LineNr = { fg = colors.purple, bg = colors.bg1 }
    highlights.LineNrAbove = { fg = colors.fg2, bg = colors.bg1 }
    highlights.LineNrBelow = { fg = colors.fg2, bg = colors.bg1 }

    highlights.GitGutterAdd = { fg = colors.green, bg = colors.bg1 }
    highlights.GitGutterChange = { fg = colors.yellow, bg = colors.bg1 }
    highlights.GitGutterDelete = { fg = colors.red, bg = colors.bg1 }

    highlights.DiffAdd = { fg = colors.green, bg = colors.none }
    highlights.DiffChange = { fg = colors.yellow, bg = colors.none }
    highlights.DiffDelete = { fg = colors.red, bg = colors.none }

    highlights.QuickFixLine = { fg = colors.yellow, bg = colors.none }

    highlights.NeomakeVirtualtextError = { link = 'ErrorMsg' }
    highlights.NeomakeVirtualtextWarning = { link = 'WarningMsg' }
    highlights.NeomakeVirtualtextInfo = { link = 'WarningMsg' }
    highlights.NeomakeVirtualtextMessage = { link = 'WarningMsg' }
  end,
}

vim.cmd [[ colorscheme NeoSolarized ]]
