local apply_xrdb = function()
  local xrdb = require('xrdb').load()
  if not xrdb then return end

  vim.cmd.colorscheme(xrdb.vim.theme)
  vim.o.background = xrdb.vim.background
  vim.cmd.syntax('on')
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
      local colors

      if vim.o.background == 'light' then
        colors = { fg = c.base00, mix_fg = c.base1, bg = c.base3, mix_bg = c.base2, dim_bg = c.base4 }
      else
        colors = { fg = c.base0, mix_fg = c.base01, bg = c.base03, mix_bg = c.base02, dim_bg = c.base04 }
      end

      return require('helpers').merge(colors, {
        none = '',
        telescope = {
          prompt = {
            fg = colors.bg,
            bg = colors.fg
          }
        }
      })
    end,
    on_highlights = function(c, _)
      for kind, icon in pairs({ Error = "", Warn = "", Hint = "", Info = "" }) do
        local hl = "DiagnosticSign" .. kind
        vim.fn.sign_define(hl, { text = icon, texthl = '', numhl = '' })
      end

      local paint = function(color, opts)
        return require('helpers').merge({ fg = c[color], bg = c['mix_' .. color] }, opts or {})
      end

      return {
        ---------------------- base ------------------------

        Constant = { fg = c.magenta },
        Identifier = { fg = c.blue },
        Include = { fg = c.orange },
        Keyword = { fg = c.green, bold = false },
        Special = { fg = c.magenta },
        String = { italic = true },
        Tag = { fg = c.yellow },
        TagAttribute = { fg = c.violet },
        Type = { fg = c.orange },
        Whitespace = { link = 'Comment' },

        ['@markup.strong'] = { fg = c.none, bold = true },
        ['@markup.italic'] = { fg = c.none, italic = true, underline = false },
        ['@markup.underline'] = { fg = c.none, underline = true },

        ['@conditional'] = { link = 'Conditional' },
        ['@field'] = { link = 'Normal' },
        ['@include'] = { link = 'Include' },
        ['@label'] = { fg = c.violet },
        ['@method'] = { link = 'Function' },
        ['@operator'] = { link = 'Normal' },
        ['@repeat'] = { link = 'Keyword' },
        ['@symbol'] = { link = 'String' },
        ['@type.builtin'] = { link = '@type' },
        ['@type.qualifier'] = { link = 'Keyword' },
        ['@variable'] = { link = 'Normal' },
        ['@variable.global'] = { fg = c.violet },

        ['@constructor.css'] = { fg = c.yellow },
        ['@operator.css'] = { link = '@tag.css' },
        ['@property.css'] = { fg = c.violet },
        ['@tag.css'] = { fg = c.orange },
        ['@type.css'] = { fg = c.violet },
        ['@field.css'] = { fg = c.mix_fg },

        Folded = { link = 'Comment' },
        FoldColumn = { link = 'SignColumn' },

        CursorColumn = { fg = c.blue, bg = c.mix_blue },
        CursorLine = { link = 'CursorColumn' },

        Visual = { link = 'CursorColumn' },
        YankHighlight = { link = 'Visual' },

        Search = paint('magenta', { bold = false, underline = false }),
        IncSearch = paint('magenta', { bold = true, underline = true }),
        CurSearch = { link = 'IncSearch' },

        SpellBad = paint('red'),
        SpellCap = paint('blue', { undercurl = true }),
        SpellLocal = { link = 'SpellCap' },
        SpellRare = { link = 'SpellCap' },
        Error = { undercurl = true },

        DiagnosticOk = { fg = c.green, bg = c.none },
        DiagnosticError = { fg = c.red, bg = c.none },
        DiagnosticWarn = { fg = c.yellow, bg = c.none },
        DiagnosticInfo = { fg = c.blue, bg = c.none },
        DiagnosticHint = { fg = c.blue, bg = c.none },
        DiagnosticUnderlineOk = paint('green', { underline = false }),
        DiagnosticUnderlineError = paint('red', { underline = false }),
        DiagnosticUnderlineWarn = paint('yellow', { underline = false }),
        DiagnosticUnderlineInfo = paint('blue', { underline = false }),
        DiagnosticUnderlineHint = paint('blue', { underline = false }),

        DiffAdd = paint('green', { reverse = false }),
        DiffDelete = paint('red', { reverse = false }),
        DiffText = paint('blue', { reverse = false }),
        DiffChange = paint('yellow', { reverse = false }),
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

        NormalFloat = { fg = c.fg, bg = c.dim_bg },
        FloatBorder = { fg = c.mix_fg, bg = c.dim_bg },
        FloatTitle = { fg = c.mix_fg, bg = c.dim_bg, bold = true },
        FloatFooter = { fg = c.fg, bg = c.bg },

        FidgetGroup = { fg = c.blue, bg = c.bg },

        LineNr = { fg = c.magenta },
        LineNrAbove = { link = 'Comment' },
        LineNrBelow = { link = 'LineNrAbove' },

        QuickFixLine = { link = 'Search' },

        Pmenu = { fg = c.fg, bg = c.mix_bg },
        PmenuSel = { link = 'CursorLine' },

        --------------------- plugins ----------------------

        OilDir = { link = 'Normal' },
        OilDirIcon = { link = 'OilDir' },

        TelescopeTitle = { link = '@markup.strong' },

        TelescopePromptTitle = { fg = c.telescope.prompt.bg, bg = c.telescope.prompt.bg },
        TelescopePromptBorder = { link = 'TelescopePromptTitle' },
        TelescopePromptNormal = { fg = c.telescope.prompt.fg, bg = c.telescope.prompt.bg },
        TelescopePromptPrefix = { fg = c.telescope.prompt.fg },
        TelescopePromptCounter = { link = 'TelescopePromptPrefix' },

        TelescopeSelection = { link = 'CursorLine' },
        TelescopeSelectionCaret = { link = 'TelescopeSelection' },
        TelescopeMatching = { link = 'Incsearch' },

        TelescopeBorder = { fg = c.bg, bg = c.bg },

        TelescopeMultiSelection = { fg = c.yellow },
        TelescopeMultiIcon = { link = 'TelescopeMultiSelection' },

        TelescopeResultsDiffAdd = { link = 'GitgutterAdd' },
        TelescopeResultsDiffDelete = { link = 'GitgutterDelete' },
        TelescopeResultsDiffChange = { link = 'GitgutterChange' },

        LazyButton = paint('blue'),
        LazyButtonActive = paint('magenta'),
        LazySpecial = { fg = c.fg },

        MasonHeader = { link = 'lazyH1' },
        MasonHighlight = { fg = c.blue, bg = c.bg },
        MasonHighlightBlock = paint('green'),
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
        NeorgCodeBlock = { bg = c.mix_bg },
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
