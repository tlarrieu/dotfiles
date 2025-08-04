return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
  },
  opts = {
    ensure_installed = {
      'ruby_lsp', -- ruby
      'ts_ls',    -- typescript
      'lua_ls',   -- lua
      'gopls',    -- golang
      'bashls',   -- bash
    },
  },
  cmd = { 'Mason' },
  ft = {
    'bash',
    'go',
    'zig',
    'haskell',
    'javascript',
    'lua',
    'python',
    'ruby',
    'sh',
    'typescript',
    'vim',
    'yaml',
  },
  config = function(_, opts)
    vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })

    vim.lsp.config('ruby_lsp', {
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
      init_options = {
        addonSettings = {
          ['Ruby LSP Rails'] = {
            enablePendingMigrationsPrompt = false,
          },
        }
      },
    })

    vim.lsp.config('lua_ls', {
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
      settings = {
        Lua = {
          diagnostics = {
            -- awesome / vim related globals
            globals = {
              'awesome',
              'screen',
              'root',
              'client',
              'mouse',
              'mousegrabber',
            },
          },
        },
      },
    })

    vim.lsp.config('gopls', {
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
      settings = {
        gopls = {
          gofumpt = true,
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
            staticcheck = true,
            unreachable = true,
          }
        }
      }
    })

    require('mason-lspconfig').setup(opts)

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local conf = { buffer = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client then
          client.server_capabilities.semanticTokensProvider = nil

          vim.keymap.set('n', 'gD', vim.diagnostic.open_float, conf)
          if client.supports_method('textDocument/hover', ev.buf) then
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, conf)
          end
          if client.supports_method('textDocument/codeAction', ev.buf) then
            vim.keymap.set({ 'n', 'x' }, 'g.', vim.lsp.buf.code_action, conf)
            vim.keymap.set({ 'n', 'x' }, '<leader>i', function()
              vim.lsp.buf.code_action({ context = { only = { 'quickfix' }, diagnostics = vim.diagnostic.get(0, {}) } })
            end, conf)
          end
          if client.supports_method('textDocument/rename', ev.buf) then
            vim.keymap.set('n', 'gé', vim.lsp.buf.rename, conf)
          end

          vim.keymap.set('n', '<leader>h', vim.lsp.buf.signature_help, require('helpers').merge({ remap = false }, conf))
          vim.keymap.set('i', '<c-h>', vim.lsp.buf.signature_help, require('helpers').merge({ remap = false }, conf))
        end
      end
    })

    vim.api.nvim_create_autocmd('LspRequest', {
      callback = function(args)
        local request = args.data.request

        if request.method == 'textDocument/formatting' then return end
        if request.method == 'textDocument/completion' then return end
        if request.method == 'textDocument/inlayHint' then return end
        if request.method == 'textDocument/hover' then return end

        local icons = { pending = '󰔟', cancel = '󰜺', complete = '' }
        local icon = icons[request.type]
        if not icon then return end

        vim.notify(icon .. ' ' .. request.method)
      end,
      group = vim.api.nvim_create_augroup('lsp_request_status', {})
    })
  end
}
