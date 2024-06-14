return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'saadparwaiz1/cmp_luasnip',
    'folke/lazydev.nvim' ,
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local kind_icons = {
      Text = '󰦨 ',
      Method = '󰆧 ',
      Function = '󰡱 ',
      Constructor = ' ',
      Field = '󰓽 ',
      Variable = '󰫧 ',
      Class = ' ',
      Interface = ' ',
      Module = ' ',
      Property = '󰓽 ',
      Unit = '󰍘 ',
      Value = '󰎠 ',
      Enum = '󰖽 ',
      Keyword = ' ',
      Snippet = '󰘦 ',
      Color = ' ',
      File = ' ',
      Reference = ' ',
      Folder = ' ',
      EnumMember = '󰖽 ',
      Constant = ' ',
      Struct = ' ',
      Event = '󱐌 ',
      Operator = '󰿈 ',
      TypeParameter = '󰅲 ',
    }

    cmp.setup({
      experimental = {
        ghost_text = { hl_group = 'CmpGhostText' },
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<c-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<c-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<c-e>'] = cmp.mapping(function()
          if cmp.get_active_entry() then
            cmp.confirm()
          else
            luasnip.expand()
          end
        end),
        ['<tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' },
      }),
      formatting = {
        format = function(entry, vim_item)
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
          -- vim_item.menu = ({
          --   buffer = '[buff]',
          --   nvim_lsp = '[LSP]',
          --   luasnip = '[snip]',
          --   nvim_lua = '[Lua]',
          --   latex_symbols = '[TeX]',
          -- })[entry.source.name]
          return vim_item
        end
      },
      window = {
        completion = { border = 'none' },
        documentation = { border = 'single' },
      },
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' },
        { name = 'path' },
      })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      sources = {
        { name = 'buffer' }
      },
      view = {
        entries = { name = 'wildmenu', separator = '|' }
      },
    })

    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' },
      }),
      view = {
        entries = { name = 'wildmenu', separator = '|' }
      },
    })
  end
}
