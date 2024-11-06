return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
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
          fmt = function(mode, _)
            if mode == 'NORMAL' then return ' 󰹻 ' end
            if mode == 'O-PENDING' then return '  ' end
            if mode == 'INSERT' then return ' 󰏪 ' end
            if mode == 'COMMAND' then return ' 󰞷 ' end
            if mode == 'TERMINAL' then return '  ' end
            if mode == 'SELECT' then return ' 󰫙 ' end
            if mode == 'VISUAL' then return ' 󰩭 ' end
            if mode == 'V-LINE' then return ' 󰩭 ' end
            if mode == 'V-BLOCK' then return ' 󰩭 ' end
            return mode
          end
        }
      },
      lualine_b = {
        {
          function()
            local project
            for dir in string.gmatch(vim.fn.getcwd(), "[^/]+") do project = dir end
            return ' ' .. project
          end,
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
        },
        {
          'diff',
          colored = true,
          diff_color = {
            added = 'LualineAdded',
            modified = 'LualineModified',
            removed = 'LualineRemoved',
          },
        },
      },
      lualine_x = {
        'encoding',
        {
          'fileformat',
          symbols = { unix = '󰻀', dos = '󰖳', mac = '' },
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
      lualine_y = { 'searchcount', 'progress' },
    },
    tabline = {
      lualine_a = {
        {
          'tabs',
          mode = 0,
          path = 0,
          max_length = 1000,
          tab_max_length = 25,
          tabs_color = {
            active = 'LualineTablineActive',
            inactive = 'LualineTablineInactive',
          },
          show_modified_status = false,
        }
      },
      lualine_b = {
        {
          'windows',
          windows_color = {
            active = 'LualineTablineActiveAlt',
            inactive = 'LualineTablineInactive',
          },
          icons_enabled = false,
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
              dashboard = 'dash',
              mason = 'mason',
              lazy = 'lazy',
              TelescopePrompt = 'telescope',
              qf = 'quickfix',
              oil = 'oil',
            }
            name = ftmap[context.filetype] or (name == '[No Name]' and '…') or name

            -- Modifier
            local modified = vim.fn.getbufvar(context.bufnr, '&mod') == 1
            local modifier = (modified and not ftmap[context.filetype]) and '' or nil

            return (icon and icon .. ' ' or '') .. name .. (modifier and ' ' .. modifier or '')
          end

        }
      },
      lualine_y = {
        { 'branch', icon = { '', align = 'right' } },
      }
    },
    winbar = {},
  },
}
