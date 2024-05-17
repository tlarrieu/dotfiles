return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'neovim/nvim-lspconfig',
    'folke/neodev.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  opts = {
    ensure_installed = {
      'hls',        -- haskell
      'tsserver',   -- javascript / TS
      'solargraph', -- ruby
      'lua_ls',     -- lua
      'vimls',      -- vim
      'gopls',      -- golang
      'bashls',     -- bash
      'ocamllsp',   -- ocaml
    },
  },
  config = function(_, opts)
    vim.keymap.set('n', 'ga', '<nop>')

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local conf = { buffer = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client then
          client.server_capabilities.semanticTokensProvider = nil

          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, conf)

          if client.supports_method('textDocument/hover') then
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, conf)
          end
          if client.supports_method('textDocument/codeAction') then
            vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, conf)
          end
          if client.supports_method('textDocument/references') then
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, conf)
          end
          if client.supports_method('textDocument/rename') then
            vim.keymap.set({ 'n', 'v' }, 'gé', vim.lsp.buf.rename, conf)
          end

          vim.keymap.set({ 'n', 'v' }, '<leader>f', function() vim.lsp.buf.format({ async = true }) end, conf)
        end
      end
    })

    local plug = require('mason-lspconfig')
    local lspconfig = require('lspconfig')

    plug.setup(opts)

    plug.setup_handlers({
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
    })
  end
}
