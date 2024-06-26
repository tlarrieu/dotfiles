local apply_xrdb = function()
  local xrdb = require('xrdb').load()
  if not xrdb then return end

  vim.cmd.colorscheme(xrdb.vim.theme)
  vim.o.background = xrdb.vim.background
end

return {
  'maxmx03/solarized.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  lazy = false,
  priority = 1000,
  opts = {
    theme = 'neo',
    transparent = true,
    styles = {
      comments = { italic = true, bold = false },
      functions = { bold = false },
      variables = { italic = false },
    },
    enables = {
      treesitter = true,
    },
    highlights = function(c, _)
      vim.cmd [[
        sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
        sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
        sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
      ]]

      c.none = ''

      local telescope_accent = c.base01

      return {
        -- base

        String = { italic = true },

        ['@text.strong'] = { fg = c.none, bold = true },
        ['@text.emphasis'] = { fg = c.none, italic = true },
        ['@text.reference'] = { fg = c.base3, bold = true },

        ['@markup.strong'] = { fg = c.none, bold = true },
        ['@markup.italic'] = { fg = c.none, italic = true },
        ['@markup.underline'] = { fg = c.none, underline = true },

        ['@conditional'] = { link = 'Conditional' },
        ['@include'] = { link = 'Include' },
        ['rubyPredefinedConstant'] = { link = '@constant' },
        ['rubyPredefinedVariable'] = { link = '@constant' },
        ['htmlTag'] = { link = 'Keyword' },
        ['erubyDelimiter'] = { link = 'htmlTag' },
        ['htmlEndTag'] = { link = 'htmlTag' },

        ['@text.title.gitcommit'] = { link = 'Keyword' },
        ['@text.reference.gitcommit'] = { link = 'Special' },
        ['@text.uri.gitcommit'] = { link = 'Normal' },
        ['@keyword.gitcommit'] = { link = 'Constant' },

        ['@text.diff.add.diff'] = { link = 'DiffAdd' },
        ['@text.diff.delete.diff'] = { link = 'DiffDelete' },
        ['@text.diff.change.diff'] = { link = 'DiffChange' },

        ['@repeat.bash'] = { link = 'Keyword' },
        ['@repeat.lua'] = { link = 'Keyword' },

        ['@symbol'] = { link = 'String' },
        ['@field'] = { link = 'Constant' },

        Cursor = { fg = c.base1, bg = c.base02 },
        TermCursorNC = { link = 'Cursor' },

        Normal = { bg = c.base03 },
        NormalFloat = { bg = c.base03 },
        FloatBorder = { fg = c.base00, bg = c.base03 },

        Folded = { link = 'Normal' },
        FoldColumn = { link = 'SignColumn' },

        YankHighlight = { bg = c.base02 },

        Search = { bg = c.base02 },
        CurSearch = { fg = c.base02, bg = c.green },
        IncSearch = { fg = c.base02, bg = c.magenta },

        SpellBad = { fg = c.red, undercurl = true },
        SpellLocal = { fg = c.blue, undercurl = true },
        SpellCap = { link = 'SpellLocal' },
        SpellRare = { link = 'SpellLocal' },

        Error = { undercurl = true },
        DiagnosticUnderlineError = { undercurl = true, bg = c.base02 },

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

        LineNr = { fg = c.magenta, bg = c.base02 },
        LineNrAbove = { fg = c.base0, bg = c.base02 },
        LineNrBelow = { link = 'LineNrAbove' },

        DiffAdd = { fg = c.green, bg = c.none },
        DiffChange = { fg = c.yellow, bg = c.none },
        DiffDelete = { fg = c.red, bg = c.none },

        QuickFixLine = { fg = c.yellow, bg = c.none },

        Pmenu = { fg = c.blue, bg = c.base02 },
        PmenuSel = { fg = c.base02, bg = c.magenta },
        PmenuThumb = { fg = c.base02, bg = c.base00 },

        -- plugins

        OilDir = { fg = c.base1 },
        OilDirIcon = { link = 'OilDir' },

        LazyNormal = { bg = c.base03 },
        MasonNormal = { bg = c.base03 },

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

        -- Those are definitions that we use inside actual neorg configuration
        NeorgDone = { fg = c.base01, bg = c.base03, italic = false },
        NeorgPending = { fg = c.green, bg = c.base03, italic = false },
        NeorgOnHold = { fg = c.yellow, bg = c.base03, italic = false },
        NeorgUndone = { fg = c.red, bg = c.base03, italic = false },
        NeorgCancelled = { link = 'NeorgDone' },
        NeorgHeading1 = { fg = c.magenta, italic = false, bold = false },
        NeorgHeading4 = { fg = c.cyan, italic = false },
        NeorgLinkDescription = { underline = true },

        CmpItemAbbrMatch = { fg = c.base0, bg = c.base02, underline = true, bold = true },
        CmpItemKindEnum = { bold = false },
        CmpItemKindFile = { bold = false },
        CmpItemKindText = { bold = false },
        CmpItemKindUnit = { bold = false },
        CmpItemKindClass = { bold = false },
        CmpItemKindColor = { bold = false },
        CmpItemKindEvent = { bold = false },
        CmpItemKindField = { bold = false },
        CmpItemKindValue = { bold = false },
        CmpItemKindFolder = { bold = false },
        CmpItemKindMethod = { bold = false },
        CmpItemKindModule = { bold = false },
        CmpItemKindStruct = { bold = false },
        CmpItemKindDefault = { bold = false },
        CmpItemKindKeyword = { bold = false },
        CmpItemKindSnippet = { bold = false },
        CmpItemKindConstant = { bold = false },
        CmpItemKindFunction = { bold = false },
        CmpItemKindOperator = { bold = false },
        CmpItemKindProperty = { bold = false },
        CmpItemKindVariable = { bold = false },
        CmpItemKindInterface = { bold = false },
        CmpItemKindReference = { bold = false },
        CmpItemKindEnumMember = { bold = false },
        CmpItemKindConstructor = { bold = false },
        CmpGhostText = { fg = c.base01, bg = c.base02 },

        MarkSignHL = { bg = c.base02 },
        MarkSignNumHL = { link = 'MarkSignHL' },
        MarkVirtTextHL = { link = 'MarkSignHL' },

        GitGutterAdd = { fg = c.green, bg = c.base02 },
        GitGutterChange = { fg = c.yellow, bg = c.base02 },
        GitGutterDelete = { fg = c.red, bg = c.base02 },
      }
    end
  },
  config = function(_, opts)
    require('solarized').setup(opts)

    apply_xrdb()

    vim.api.nvim_create_autocmd('Signal', {
      pattern = { 'SIGUSR1' },
      callback = apply_xrdb,
      nested = true,
      group = vim.api.nvim_create_augroup('update_background', {})
    })

    local group = vim.api.nvim_create_augroup("text_yank", {})
    vim.api.nvim_create_autocmd('TextYankPost', {
      pattern = '*',
      callback = function() vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 }) end,
      group = group,
    })
  end
}
