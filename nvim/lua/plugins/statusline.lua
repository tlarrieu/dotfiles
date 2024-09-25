return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    extensions = {
      'man',
      'toggleterm',
      'quickfix',
      'oil',
      'lazy',
      'fugitive',
      'mason',
    },
    -- options = {
    --   component_separators = { left = '', right = '' },
    --   section_separators = { left = '', right = '' },
    -- },
    options = {
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = {
        {
          'mode',
          icons_enabled = true,
          fmt = function(mode, ctx)
            if mode == 'NORMAL' then return ' 󰹻 ' end
            if mode == 'INSERT' then return ' 󰏪 ' end
            if mode == 'COMMAND' then return ' 󰞷 ' end
            if mode == 'VISUAL' then return ' 󰬃 ' end
            if mode == 'V-LINE' then return ' 󰫹 ' end
            if mode == 'V-BLOCK' then return ' 󰫯 ' end
            return mode
          end
        }
      },
      lualine_b = {
        { 'branch' },
        {
          'diff',
          colored = true,
          diff_color = {
            added = 'LualineAdded',
            modified = 'LualineModified',
            removed = 'LualineRemoved',
          },
          symbols = {
          }
        },
        { 'diagnostics' },
      },
      lualine_c = {
        {
          'filename',
          path = 3,
          cond = function() return vim.bo[0].buftype ~= 'nofile' end,
          symbols = {
            modified = '',
            readonly = '',
            -- unnamed = '…',
            -- newfile = '󰎔',
          },
        }
      },
      lualine_x = {
        'encoding',
        {
          'fileformat',
          symbols = { unix = '', dos = '󰖳', mac = '' },
        },
        {
          'custom',
          fmt = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local name = vim.api.nvim_buf_get_name(bufnr)
            local filetype = vim.bo[bufnr].filetype

            if filetype == '' then return end

            -- Icon
            local icon = require('nvim-web-devicons').get_icon(name, filetype)

            return icon .. ' ' .. filetype
          end
        }
      },
    },
    tabline = {
      lualine_a = { {
        'tabs',
        mode = 2,
        path = 0,
        max_length = 1000,
        tab_max_length = 25,
        tabs_color = {
          active = 'LualineTablineActive',
          inactive = 'LualineTablineInactive',
        },
        show_modified_status = false,
        fmt = function(name, context)
          -- Icon
          local icon
          if context.filetype ~= '' then
            icon = require('nvim-web-devicons').get_icon(name, context.filetype)
          end

          -- Name
          local ftmap = {
            harpoon = 'harpoon',
            mason = 'mason',
            lazy = 'lazy',
            TelescopePrompt = 'telescope',
            qf = 'quickfix',
            oil = 'oil',
          }
          name = ftmap[context.filetype] or (name == '[No Name]' and '…') or name

          -- Modifier
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local buflist = vim.fn.tabpagebuflist(context.tabnr)
          local bufnr = buflist[winnr]
          local modified = vim.fn.getbufvar(bufnr, '&mod') == 1
          local modifier = (modified and context.buftype ~= 'prompt') and '' or ''

          return (icon and icon .. ' ' or '') .. name .. (modifier and ' ' .. modifier or '')
        end
      } },
    },
    winbar = {},
  },
  config = function(_, opts)
    require('lualine').setup(opts)

    vim.opt.laststatus = 2

    vim.keymap.set('n', '<leader>tl', ':LualineRename ')
    vim.keymap.set('n', '<leader>tr', ':LualineRename<cr>', { silent = true })
  end,
}
