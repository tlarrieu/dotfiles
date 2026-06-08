vim.pack.add({
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-cmdline',
  'https://github.com/zbirenbaum/copilot-cmp',
  'https://github.com/hrsh7th/nvim-cmp',
}, { confirm = false })

local border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }

if vim.pack.get({ 'copilot-cmp' })[1].rev == '15fc12af3d0109fa76b60b5cffa1373697e261d1' then
  -- get rid of deprecation warnings (client.is_stopped vs client:is_stopped) from copilot-cmp
  require("copilot_cmp.source").is_available = function(self)
    if self.client:is_stopped() or not self.client.name == "copilot" then return false end

    return next(vim.lsp.get_clients({
      bufnr = vim.api.nvim_get_current_buf(),
      id = self.client.id,
    })) ~= nil
  end
else
  vim.notify('copilot-cmp has been updated, check whether the monkey patch is still useful', vim.log.levels.WARN)
end

require('copilot_cmp').setup()
local cmp = require('cmp')

local kind_icons = {
  Text = '',
  Method = '󰡱',
  Function = '󰡱',
  Constructor = '󰡱',
  Field = '',
  Property = '',
  Variable = '󰀫',
  Constant = '󱃮',
  Class = '',
  Interface = '',
  Module = '󰅩',
  Unit = '󰺾',
  Value = '󰎠',
  Enum = '',
  EnumMember = '',
  Keyword = '',
  Color = '󰌁',
  Reference = '',
  File = '󰈔',
  Folder = '',
  Snippet = '󰩫',
  Struct = '',
  Event = '󱐌',
  Operator = '󱓉',
  TypeParameter = '',
  Copilot = '󱨚',
}

cmp.setup({
  experimental = {
    ghost_text = { hl_group = 'CmpGhostText' },
  },
  preselect = cmp.PreselectMode.None,
  performance = {
    max_view_entries = 100,
    debounce = 250,
    throttle = 250,
  },
  snippet = {
    expand = function(args) vim.snippet.expand(args.body) end,
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
    ['<c-e>'] = cmp.mapping(function(fallback) fallback() end),
  }),
  sources = cmp.config.sources({
    { name = 'path', priority = 1000 },
    { name = 'copilot', priority = 110 },
    { name = 'nvim_lsp', priority = 100 },
    { name = 'buffer', priority = 10, option = { get_bufnrs = vim.api.nvim_list_bufs, keyword_pattern = [[\k\+]] } },
  }),
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = string.format('%s ', kind_icons[vim_item.kind])
      return vim_item
    end,
    fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, },
  },
  window = {
    completion = { border = border, col_offset = -4 },
    documentation = { border = border },
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
    { name = 'path' },
  })
})

cmp.setup.cmdline({ '/', '?', '@' }, { mapping = cmp.mapping.preset.cmdline() })
cmp.setup.cmdline({ ':' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    {
      name = 'cmdline',
      max_item_count = 30,
      keyword_length = 3,
    }
  }),
})
