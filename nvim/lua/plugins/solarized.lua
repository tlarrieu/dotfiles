return {
  'maxmx03/solarized.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    theme = 'neo',
    transparent = true,
    styles = {
      comments = { italic = true, bold = false },
      functions = { bold = true },
      variables = { italic = false },
    },
    enables = {
      treesitter = false,
    },
    highlights = function(c, _)
      vim.cmd [[
        sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
        sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
        sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
      ]]

      local telescope_accent = c.base01

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
        TelescopeMultiIcon = { link = 'TelescopeNormal' },

        String = { italic = true },

        ['@text.strong'] = { fg = c.none, bold = true },
        ['@text.emphasis'] = { fg = c.none, italic = true },
        ['@text.reference'] = { fg = c.base3, bold = true },

        CmpItemAbbrMatch = { fg = c.base0, bg = c.base02, underline = true, bold = true },

        NoiceCursor = { fg = c.base02, bg = c.base00 },
        NoicePopupBorder = { fg = c.base02, bg = c.base02 },
        NoiceCmdlinePopupBorder = { link = 'NoicePopupBorder' },
        NoiceCmdlinePopupBorderSearch = { link = 'NoicePopupBorder' },

        NormalFloat = { bg = c.base02 },
        FloatBorder = { fg = c.base1, bg = c.base1 },

        NotifyBackground = { bg = c.base03 },
        NotifyINFOBody = { link = 'NotifyBackground' },
        NotifyWARNBody = { link = 'NotifyINFOBody' },
        NotifyERRORBody = { link = 'NotifyINFOBody' },
        NotifyDEBUGBody = { link = 'NotifyINFOBody' },
        NotifyTRACEBUGBody = { link = 'NotifyINFOBody' },

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

        DiagnosticSignError = { fg = c.red, bg = c.base02 },
        DiagnosticSignWarn = { fg = c.yellow, bg = c.base02 },
        DiagnosticSignInfo = { fg = c.blue, bg = c.base02 },
        DiagnosticSignHint = { fg = c.base0, bg = c.base02 },

        NormalNC = { bg = c.base02 },
        SignColumn = { link = 'NormalNC' },
        WinSeparator = { fg = c.base01, bg = c.base02 },

        StatusLine = { link = 'Normal' },
        StatusLineNC = { link = 'Tabline' },

        CursorLine = { link = 'CursorColumn' },

        MarkSignHL = { bg = c.base02 },
        MarkSignNumHL = { link = 'MarkSignHL' },
        MarkVirtTextHL = { link = 'MarkSignHL' },

        LineNr = { fg = c.magenta, bg = c.base02 },
        LineNrAbove = { fg = c.base0, bg = c.base02 },
        LineNrBelow = { link = 'LineNrAbove' },

        -- popup menu
        Pmenu = { fg = c.blue, bg = c.base02 },
        PmenuSel = { fg = c.base02, bg = c.magenta },

        GitGutterAdd = { fg = c.green, bg = c.base02 },
        GitGutterChange = { fg = c.yellow, bg = c.base02 },
        GitGutterDelete = { fg = c.red, bg = c.base02 },

        DiffAdd = { fg = c.green, bg = c.none },
        DiffChange = { fg = c.yellow, bg = c.none },
        DiffDelete = { fg = c.red, bg = c.none },

        QuickFixLine = { fg = c.yellow, bg = c.none },
      }
    end
  },
  config = function(_, opts)
    require('solarized').setup(opts)

    vim.o.background = 'light'
    vim.cmd.colorscheme 'solarized'

    local group = vim.api.nvim_create_augroup("text_yank", {})
    vim.api.nvim_create_autocmd('TextYankPost', {
      pattern = '*',
      callback = function() vim.highlight.on_yank({ higroup = "Folded", timeout = 200 }) end,
      group = group,
    })
  end
}
