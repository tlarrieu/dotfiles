return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    {
      'williamboman/mason.nvim',
      config = true,
      opts = {
        ui = {
          border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
          height = 0.85,
          icons = {
            package_installed = '',
            package_pending = '󱫬',
            package_uninstalled = '',
          },
          keymaps = {
            toggle_help = 'g?',
            toggle_package_expand = '<cr>',
            toggle_package_install_log = '<cr>',
            install_package = 'i',
            update_package = 'u',
            update_all_packages = 'U',
            check_package_version = 'c',
            check_outdated_packages = 'C',
            uninstall_package = 'x',
            cancel_installation = '<c-c>',
            apply_language_filter = '<c-f>',
          },
        },
      },
    },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
  },
  opts = {
    ensure_installed = {
      'ruby_lsp', -- ruby
      'lua_ls',   -- lua
      'gopls',    -- golang
      'bashls',   -- bash
      'jsonls',   -- json
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
    'json',
  },
  config = function(_, opts)
    vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })

    vim.lsp.config('ruby_lsp', {
      init_options = {
        addonSettings = {
          ['Ruby LSP Rails'] = {
            enablePendingMigrationsPrompt = false,
          },
        }
      },
    })

    vim.lsp.config('gopls', {
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

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          format = {
            defaultConfig = {
              indent_style = 'space',
              indent_size = '2',
              align_array_table = 'false',
            },
          },
          diagnostics = {
            neededFileStatus = { ['codestyle-check'] = 'Any' },
          },
        }
      }
    })

    require('mason-lspconfig').setup(opts)

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end

        client.server_capabilities.semanticTokensProvider = nil

        local conf = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.diagnostic.open_float, conf)
        if client:supports_method('textDocument/hover', ev.buf) then
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, conf)
        end
        if client:supports_method('textDocument/codeAction', ev.buf) then
          vim.keymap.set({ 'n', 'x' }, 'g.', vim.lsp.buf.code_action, conf)
        end
        if client:supports_method('textDocument/rename', ev.buf) then
          vim.keymap.set('n', 'cé', vim.lsp.buf.rename, conf)
        end

        vim.keymap.set('n', '<leader>h', vim.lsp.buf.signature_help, require('helpers').merge({ remap = false }, conf))
        vim.keymap.set('i', '<c-h>', vim.lsp.buf.signature_help, require('helpers').merge({ remap = false }, conf))
      end
    })

    local notify_request = function(request)
      local icons = { pending = '󰔟', cancel = '󰜺', complete = '' }
      local icon = icons[request.type]
      if not icon then return end

      vim.notify(icon .. ' ' .. request.method)
    end

    vim.api.nvim_create_autocmd('LspRequest', {
      callback = function(args)
        local request = args.data.request

        if request.method == 'textDocument/definition' then notify_request(request) end
        if request.method == 'textDocument/references' then notify_request(request) end
      end,
      group = vim.api.nvim_create_augroup('lsp_request_status', {})
    })
  end
}
