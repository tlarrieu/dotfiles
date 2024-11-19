return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'saadparwaiz1/cmp_luasnip',
    'folke/lazydev.nvim',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'kirasok/cmp-hledger',
  },
  event = { 'CmdlineEnter', 'InsertEnter' },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local kind_icons = {
      Text = '󰦨',
      Method = '󰊕',
      Function = '󰡱',
      Constructor = '',
      Field = '󰓽',
      Variable = '󰹻',
      Class = '',
      Interface = '',
      Module = '󰏗',
      Property = '󰓽',
      Unit = '󰍘',
      Value = '󰎠',
      Enum = '󰖽',
      Keyword = '',
      Snippet = '󰈸',
      Color = '',
      File = '',
      Reference = '',
      Folder = '',
      EnumMember = '󰖽',
      Constant = '󰹻',
      Struct = '',
      Event = '󱐌',
      Operator = '󰿈',
      TypeParameter = '󰅲',
    }

    cmp.setup({
      experimental = {
        ghost_text = { hl_group = 'CmpGhostText' },
      },
      preselect = cmp.PreselectMode.None,
      performance = {
        max_view_entries = 15,
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
        { name = 'nvim_lsp', priority = 100 },
        { name = 'luasnip',  priority = 95 },
        { name = 'path',     priority = 0 },
        {
          name = 'buffer',
          priority = 90,
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          }
        },
      }),
      formatting = {
        format = function(_, vim_item)
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
          return vim_item
        end,
        fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, },
      },
      window = {
        completion = { border = 'none' },
        documentation = { border = 'single' },
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
