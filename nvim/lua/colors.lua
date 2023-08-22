vim.o.background = 'light'

require('solarized').setup {
  theme = 'neo',
  transparent = true,
  styles = {
    comments = { italic = false, bold = false },
    functions = { bold = true },
    variables = { italic = false },
  },
  highlights = function (c, helper)
    local telescope_accent = c.base0

    return {
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

      Tabline = { fg = c.base0, bg = c.base02 },
      TablineSel = { fg = c.magenta, bg = c.base03 },
      TablineFill = { link = 'Tabline' },

      Search = { bg = c.base02 },
      CurSearch = { fg = c.base02, bg = c.green },
      IncSearch = { fg = c.base02, bg = c.magenta },
      IlluminatedWordText = { fg = c.base02, bg = c.blue },

      SpellBad = { fg = c.red, undercurl = true },
      SpellLocal = { fg = c.blue, undercurl = true },
      SpellCap = { link = 'SpellLocal' },
      SpellRare = { link = 'SpellLocal' },

      NormalNC = { bg = c.base02 },
      SignColumn = { link = 'NormalNC' },
      WinSeparator = { link = 'NormalNC' },

      StatusLine = { link = 'Normal' },
      StatusLineNC = { link = 'Tabline' },

      CursorLine = { link = 'CursorColumn' },

      MarkSignHL = { bg = c.base02 },
      MarkSignNumHL = { link = 'MarkSignHL' },
      MarkVirtTextHL = { link = 'MarkSignHL' },

      LineNr = { fg = c.magenta, bg = c.base02 },
      LineNrAbove = { fg = c.base0, bg = c.base02 },
      LineNrBelow = { link = 'LineNrAbove' },

      GitGutterAdd = { fg = c.green, bg = c.base02 },
      GitGutterChange = { fg = c.yellow, bg = c.base02 },
      GitGutterDelete = { fg = c.red, bg = c.base02 },

      DiffAdd = { fg = c.green, bg = c.none },
      DiffChange = { fg = c.yellow, bg = c.none },
      DiffDelete = { fg = c.red, bg = c.none },

      QuickFixLine = { fg = c.yellow, bg = c.none },

      NeomakeVirtualtextError = { link = 'ErrorMsg' },
      NeomakeVirtualtextWarning = { link = 'WarningMsg' },
      NeomakeVirtualtextInfo = { link = 'WarningMsg' },
      NeomakeVirtualtextMessage = { link = 'WarningMsg' },
    }
  end
}

vim.cmd.colorscheme 'solarized'

local group = vim.api.nvim_create_augroup("text_yank", {})
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function() vim.highlight.on_yank({ higroup="Folded", timeout=200 }) end,
    group = group,
  })
