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
    palette = 'solarized',
    transparent = {
      enabled = true,
      normal = false,
      normalfloat = true,
      pmenu = true,
      telescope = true,
      lazy = true,
      mason = true,
    },
    styles = {
      comments = { italic = true, bold = false },
      functions = { bold = false },
      variables = { italic = false },
    },
    on_colors = function(c, _)
      if vim.o.background == 'light' then
        return { fg = c.base00, bg = c.base3 }
      else
        return { fg = c.base0, bg = c.base03 }
      end
    end,
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
        ---------------------- base ------------------------

        Constant = { fg = c.magenta },
        Identifier = { fg = c.blue },
        Include = { fg = c.orange },
        Keyword = { fg = c.green, bold = false },
        Special = { fg = c.magenta },
        String = { italic = true },
        Tag = { fg = c.orange },
        Type = { fg = c.orange },
        Whitespace = { link = 'Comment' },

        ['@markup.strong'] = { fg = c.none, bold = true },
        ['@markup.italic'] = { fg = c.none, italic = true },
        ['@markup.underline'] = { fg = c.none, underline = true },

        ['@conditional'] = { link = 'Conditional' },
        ['@field'] = { link = 'Normal' },
        ['@include'] = { link = 'Include' },
        ['@label'] = { fg = c.violet },
        ['@method'] = { link = 'Function' },
        ['@repeat'] = { link = 'Keyword' },
        ['@symbol'] = { link = 'String' },
        ['@type.qualifier'] = { link = 'Keyword' },
        ['@variable'] = { link = 'Normal' },
        ['@variable.global'] = { fg = c.violet },

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

        DiagnosticOk = { fg = c.green, bg = c.none },
        DiagnosticError = { fg = c.red, bg = c.none },
        DiagnosticWarn = { fg = c.yellow, bg = c.none },
        DiagnosticInfo = { fg = c.blue, bg = c.none },
        DiagnosticHint = { fg = c.none, bg = c.none },
        DiagnosticUnderlineError = { undercurl = true },

        DiffAdd = { fg = c.green, bg = c.mix_green, reverse = false },
        DiffDelete = { fg = c.red, bg = c.mix_red, reverse = false },
        DiffText = { fg = c.blue, bg = c.mix_blue, reverse = false },
        DiffChange = { fg = c.yellow, bg = c.mix_yellow, reverse = false },
        Added = { link = 'DiffAdd' },
        Removed = { link = 'DiffDelete' },
        Changed = { link = 'DiffChange' },
        ['@diff.plus'] = { fg = c.green },
        ['@diff.minus'] = { fg = c.red },
        ['@diff.delta'] = { fg = c.yellow },
        ['@text.diff.add.diff'] = { link = 'DiffAdd' },
        ['@text.diff.delete.diff'] = { link = 'DiffDelete' },
        ['@text.diff.change.diff'] = { link = 'DiffChange' },

        WinSeparator = { link = 'Comment' },

        LineNr = { fg = c.magenta },
        LineNrAbove = { link = 'Comment' },
        LineNrBelow = { link = 'LineNrAbove' },

        QuickFixLine = { link = 'TelescopeSelection' },

        Pmenu = { link = 'CursorColumn' },
        PmenuSel = { link = 'TelescopeSelection' },

        --------------------- plugins ----------------------

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

        TelescopeBorder = { fg = c.bg, bg = c.bg },
        FloatBorder = { link = 'TelescopeBorder' },

        TelescopeMultiSelection = { fg = c.yellow },
        TelescopeMultiIcon = { link = 'TelescopeMultiSelection' },

        TelescopeResultsDiffAdd = { link = 'GitgutterAdd' },
        TelescopeResultsDiffDelete = { link = 'GitgutterDelete' },
        TelescopeResultsDiffChange = { link = 'GitgutterChange' },

        LazyButton = { fg = c.blue, bg = c.mix_blue },
        LazyButtonActive = { fg = c.magenta, bg = c.mix_magenta },
        LazySpecial = { fg = c.fg },

        MasonHeader = { link = 'lazyH1' },
        MasonHighlight = { fg = c.blue, bg = c.bg },
        MasonHighlightBlock = { fg = c.green, bg = c.mix_green },
        MasonHighlightBlockBold = { link = 'LazyButtonActive' },
        MasonMutedBlock = { link = 'LazyButton' },

        GitgutterAdd = { fg = c.green },
        GitgutterDelete = { fg = c.red },
        GitgutterChange = { fg = c.yellow },

        fugitiveHeading = { link = 'Include' },
        fugitiveStagedHeading = { fg = c.green },
        fugitiveUnstagedHeading = { fg = c.orange },
        ['@text.title.gitcommit'] = { link = 'Keyword' },
        ['@text.reference.gitcommit'] = { link = 'Special' },
        ['@text.uri.gitcommit'] = { link = 'Normal' },
        ['@keyword.gitcommit'] = { link = 'Constant' },

        CmpGhostText = { link = '@markup.list.unchecked' },
        CmpItemAbbrMatch = { bold = true },

        ['@field.ledger'] = { fg = c.blue },
        ['@number.ledger'] = { fg = c.magenta },
        ['@string.special.ledger'] = { fg = c.yellow, bold = true },

        -- Those are definitions that we use inside actual neorg configuration
        NeorgDone = { link = '@markup.list.unchecked' },
        NeorgPending = { fg = c.green, italic = false },
        NeorgOnHold = { fg = c.yellow, italic = false },
        NeorgUndone = { fg = c.none, italic = false },
        NeorgCancelled = { link = 'NeorgDone' },
        NeorgLinkDescription = { underline = true, italic = true },
        ['@markup.heading.1'] = { fg = c.magenta },
        ['@markup.heading.2'] = { fg = c.green },
        ['@markup.heading.3'] = { fg = c.blue },
        ['@markup.heading.4'] = { fg = c.yellow },
        ['@markup.heading.5'] = { fg = c.cyan },
        ['@markup.heading.6'] = { fg = c.violet },

        ['@punctuation.special.markdown'] = { fg = c.red },
        ['@text.title.1'] = { link = '@markup.heading.1' },
        ['@text.title.2'] = { link = '@markup.heading.2' },
        ['@text.title.3'] = { link = '@markup.heading.3' },
        ['@text.title.4'] = { link = '@markup.heading.4' },
        ['@text.title.5'] = { link = '@markup.heading.5' },
        ['@text.title.6'] = { link = '@markup.heading.6' },
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

    vim.api.nvim_create_autocmd('TextYankPost', {
      pattern = '*',
      callback = function() vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 }) end,
      group = vim.api.nvim_create_augroup("text_yank", {})
    })
  end
}
