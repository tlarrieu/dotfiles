local ro_icon = '󰌾'
local mod_icon = '󰴓'

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'lewis6991/gitsigns.nvim',
    'tlarrieu/testbus',
  },
  lazy = false,
  opts = {
    extensions = {
      'man',
      'toggleterm',
      'quickfix',
      'oil',
      'fugitive',
      'mason',
      {
        sections = {
          lualine_a = { function() return 'lazy 󰒲' end },
          lualine_b = { function()
            return 'loaded: ' .. require('lazy').stats().loaded .. '/' .. require('lazy').stats().count
          end },
          lualine_c = { { require('lazy.status').updates, cond = require('lazy.status').has_updates } },
        },
        filetypes = { 'lazy' }
      },
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
      },
      lualine_c = {
        {
          'filename',
          path = 3,
          cond = function() return vim.bo[0].buftype ~= 'nofile' end,
          symbols = {
            modified = mod_icon,
            readonly = ro_icon,
            -- unnamed = '…',
            -- newfile = '󰎔',
          },
        },
        {
          function() return require('testbus').statusline.icon() end,
          color = function() return require('testbus').statusline.color() end,
        },
        { 'diagnostics' },
        {
          'diff',
          colored = true,
          diff_color = {
            added = 'LualineAdded',
            modified = 'LualineModified',
            removed = 'LualineRemoved',
          },
          source = function()
            local success, source = pcall(vim.api.nvim_buf_get_var, 0, 'gitsigns_status_dict')

            if success then
              return {
                modified = source.changed,
                added = source.added,
                removed = source.removed
              }
            end

            return {}
          end,
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
        },
      },
      lualine_y = { 'searchcount', 'progress', 'lsp_status', }
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
        },
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

            if context.filetype == 'fugitive' then
              icon = ''
              name = 'status'
            elseif context.file:find('^fugitive:///') then
              icon = ''
              name = name .. ' (diff)'
            end

            -- Modifier
            local modified = vim.fn.getbufvar(context.bufnr, '&mod') == 1
            local modifier = (modified and not ftmap[context.filetype]) and mod_icon or nil

            return (icon and icon .. ' ' or '') .. name .. (modifier and ' ' .. modifier or '')
          end
        },
      },
      lualine_y = {
        {
          'branch',
          fmt = function(name)
            local length = 40
            if #name > length then return name:sub(0, length) .. '…' else return name end
          end,
          icon = { '', align = 'right' }
        },
      }
    },
    winbar = {},
  },
}
