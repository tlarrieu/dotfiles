return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
    'folke/neodev.nvim',
  },
  opts = {
    ensure_installed = {
      'hls',      -- haskell
      'ruby_ls',  -- ruby
      'tsserver', -- javascript / TS
      'lua_ls',   -- lua
      'vimls',    -- vim
      'gopls',    -- golang
    },
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local conf = { buffer = ev.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, conf)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, conf)
        vim.keymap.set('n', 'gé', vim.lsp.buf.rename, conf)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, conf)
        vim.keymap.set('n', '<space>f', function()
          vim.lsp.buf.format { async = true }
        end, conf)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
      end
    })

    local plug = require('mason-lspconfig')
    local lspconfig = require('lspconfig')

    plug.setup(opts)

    plug.setup_handlers {
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
        })
      end,
      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          on_attach = opts.on_attach,
          capabilities = opts.capabilities,

          settings = {
            Lua = {
              ["workspace.ignoreDir"] = {
                'lain/',
              },
              diagnostics = {
                -- awesome related globals
                globals = {
                  "awesome",
                  "root",
                  "client",
                  "mouse",
                  "mousegrabber",
                },
              },
            },
          },
        })
      end,
      ["gopls"] = function()
        lspconfig.gopls.setup({
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
      end,
    }
  end
}