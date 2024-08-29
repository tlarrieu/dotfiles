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
    transparent = {
      enabled = true,
      normal = false,
      normalfloat = true,
      pmenu = true,
      telescope = true,
      lazy = true,
      mason = true,
    },
    palette = 'solarized',
    styles = {
      comments = { italic = true, bold = false },
      functions = { bold = false },
      variables = { italic = false },
    },
    enables = {
      treesitter = true,
    },
    on_highlights = function(c, _)
      vim.cmd [[
        sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
        sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
        sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
      ]]

      c.none = ''

      local telescope_accent = c.base0

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
        ['@field'] = { link = 'Normal' },
        ['@variable'] = { link = 'Normal' },

        Folded = { link = 'Comment' },
        FoldColumn = { link = 'SignColumn' },

        Visual = { link = 'CursorColumn' },
        YankHighlight = { link = 'Visual' },

        Search = { fg = c.magenta, bg = c.mix_magenta, bold = false, underline = false },
        IncSearch = { fg = c.magenta, bg = c.mix_magenta, bold = true, underline = true },
        CurSearch = { link = 'IncSearch' },

        SpellBad = { fg = c.red, bg = c.mix_red },
        SpellLocal = { fg = c.blue, bg = c.mix_blue, undercurl = true },
        SpellCap = { link = 'SpellLocal' },
        SpellRare = { link = 'SpellLocal' },

        Error = { undercurl = true },
        DiagnosticUnderlineError = { undercurl = true },

        WinSeparator = { link = 'Comment' },

        LineNr = { fg = c.magenta },
        LineNrAbove = { link = 'Comment' },
        LineNrBelow = { link = 'LineNrAbove' },

        QuickFixLine = { link = 'TelescopeSelection' },

        Pmenu = { link = 'CursorColumn' },
        PmenuSel = { link = 'TelescopeSelection' },

        -- plugins

        OilDir = { link = 'Normal' },
        OilDirIcon = { link = 'OilDir' },

        TelescopeTitle = { link = '@markup.strong' },

        TelescopePromptTitle = { fg = telescope_accent, bg = telescope_accent },
        TelescopePromptBorder = { link = 'TelescopePromptTitle' },
        TelescopePromptNormal = { fg = c.base2, bg = telescope_accent },
        TelescopePromptPrefix = { link = 'TelescopePromptNormal' },
        TelescopePromptCounter = { link = 'TelescopePromptNormal' },

        TelescopeSelection = { fg = c.blue, bg = c.mix_blue },
        TelescopeSelectionCaret = { link = 'TelescopeSelection' },
        TelescopeMatching = { link = 'Incsearch' },

        TelescopeMultiSelection = { fg = c.yellow },
        TelescopeMultiIcon = { link = 'TelescopeMultiSelection' },

        -- Those are definitions that we use inside actual neorg configuration
        NeorgDone = { link = '@markup.list.unchecked' },
        NeorgPending = { fg = c.green, italic = false },
        NeorgOnHold = { fg = c.yellow, italic = false },
        NeorgUndone = { fg = c.red,  italic = false },
        NeorgCancelled = { link = 'NeorgDone' },
        NeorgHeading1 = { fg = c.magenta, italic = false, bold = false },
        NeorgHeading4 = { fg = c.cyan, italic = false },
        NeorgLinkDescription = { underline = true },

        CmpGhostText = { link = '@markup.list.unchecked' },
        CmpItemAbbrMatch = { bold = true }
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
