return {
  'hrsh7th/nvim-cmp',
  config = function()
    local cmp = require('cmp')

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
          vim.fn["UltiSnips#Anon"](args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<c-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<c-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<c-e>'] = cmp.mapping.confirm(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'ultisnips' },
      }),
      formatting = {
        format = function(entry, vim_item)
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
          -- vim_item.menu = ({
          --   buffer = '[buff]',
          --   nvim_lsp = '[LSP]',
          --   luasnip = '[snip]',
          --   ultisnips = '[snip]',
          --   nvim_lua = '[Lua]',
          --   latex_symbols = '[TeX]',
          -- })[entry.source.name]
          return vim_item
        end
      }
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' },
        { name = 'buffer' },
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
