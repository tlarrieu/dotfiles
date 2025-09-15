local blank_border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }

return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'saadparwaiz1/cmp_luasnip',
    'folke/lazydev.nvim',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'kirasok/cmp-hledger',
    'zbirenbaum/copilot-cmp',
  },
  event = { 'CmdlineEnter', 'InsertEnter' },
  config = function()
    require('copilot_cmp').setup()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local kind_icons = {
      Text = '󰦨',
      Method = '󰊕',
      Function = '󰊕',
      Constructor = '',
      Field = '󰓽',
      Variable = '󰹻',
      Constant = '󰹻',
      Class = '',
      Interface = '',
      Module = '󰏗',
      Property = '',
      Unit = '󰍘',
      Value = '󰎠',
      Enum = '󰖽',
      Keyword = '󱕵',
      Snippet = '󰈸',
      Color = '',
      File = '',
      Reference = '',
      Folder = '',
      EnumMember = '󰖽',
      Struct = '',
      Event = '󱐌',
      Operator = '󰿈',
      TypeParameter = '󰅲',
      Copilot = '',
    }

    cmp.setup({
      experimental = {
        ghost_text = { hl_group = 'CmpGhostText' },
      },
      preselect = cmp.PreselectMode.None,
      performance = {
        max_view_entries = 8,
        debounce = 250,
        throttle = 250,
      },
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<c-n>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })()
          end
        end),
        ['<c-p>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })()
          end
        end),
        ['<c-y>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
        ['<c-e>'] = cmp.mapping(function() luasnip.expand() end),
        ['<tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then luasnip.jump(1) else fallback() end
        end, { 'i', 's' }),
        ['<S-tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'path', priority = 1000 },
        { name = 'copilot', priority = 110 },
        { name = 'nvim_lsp', priority = 100 },
        { name = 'luasnip', priority = 95 },
        { name = 'buffer', priority = 10, option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end } },
      }),
      formatting = {
        format = function(_, vim_item)
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
          return vim_item
        end,
        fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, },
      },
      window = {
        completion = { border = blank_border },
        documentation = { border = blank_border },
      },
    })

    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' },
        { name = 'path' },
      })
    })

    cmp.setup.filetype('ledger', {
      sources = cmp.config.sources({
        { name = 'hledger', priority = 100 },
        { name = 'buffer' },
      })
    })

    cmp.setup.cmdline({ '/', '?', '@' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' },
      }),
    })
  end
}
