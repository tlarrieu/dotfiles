return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
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
    local plug = require('mason-lspconfig')

    plug.setup(opts)

    plug.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup({
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
        })
      end,
      ["lua_ls"] = function()
        require('lspconfig').lua_ls.setup({
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
    }
  end
}
