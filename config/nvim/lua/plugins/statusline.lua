local ro_icon = '󱆠'
local mod_icon = '󰴓 '
local ftmap = {
  harpoon = 'harpoon',
  mason = 'mason',
  lazy = 'lazy',
  TelescopePrompt = 'telescope',
  qf = 'quickfix',
  oil = 'oil',
}

local projectdir = function()
  local project
  for dir in string.gmatch(vim.fn.getcwd(), "[^/]+") do project = dir end
  return ' ' .. project
end

local branch = {
  'branch',
  fmt = function(name)
    local length = 40
    if #name > length then return name:sub(0, length) .. '…' else return name end
  end,
  icon = { '', align = 'left' }
}

local mode = {
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

local stashstatus = {
  function()
    local handle = io.popen("git stash list 2> /dev/null | wc -l")
    if not handle then return '' end

    local result = tonumber(handle:read("*a"))

    if result == 0 then return '' end
    if result == 1 then return '───  󰎤 ───' end
    if result == 2 then return '───  󰎧 ───' end
    if result == 3 then return '───  󰎪 ───' end
    if result >= 4 then return '───  󰼑 ───' end

    return ''
  end,
  color = function() return 'LualineSuccess' end,
}

local pushstatus = {
  function()
    local handle = io.popen("git rev-list @{u}...HEAD --left-right 2> /dev/null | cut -c1 | paste -sd ''")
    if not handle then return '' end

    local result = handle:read("*a")
    if result:match('><') then return '─── 󰆖 ───' end
    if result:match('<') then return '─── 󰧖 ───' end
    if result:match('>') then return '─── 󰧜 ───' end

    return ''
  end,
  color = function() return 'LualineNotice' end,
}

local filenamecolor = function()
  if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0 then return 'LualineError' end
  if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) > 0 then return 'LualineWarning' end

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then return end

  if vim.fn.executable(bufname) > 0 then return 'LualineExecutable' end
end

local plugin = function(cfg)
  return {
    sections = {
      lualine_a = { mode },
      lualine_b = { projectdir, branch, 'searchcount' },
      lualine_c = { stashstatus, pushstatus, cfg.fn },
      lualine_x = { 'location' },
      lualine_z = { function() return cfg.title or '' end },
    },
    filetypes = cfg.filetypes or {}
  }
end

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
      'mason',
      {
        sections = {
          lualine_a = { function() return 'lazy 󰒲' end },
          lualine_b = { function()
            return 'loaded: ' .. require('lazy').stats().loaded .. '/' .. require('lazy').stats().count
          end },
          lualine_c = {
            {
              require('lazy.status').updates,
              cond = require('lazy.status').has_updates,
            }
          },
        },
        filetypes = { 'lazy' }
      },
      plugin({
        fn = function() return vim.fn.getqflist({ title = 0 }).title end,
        title = 'quickfix ',
        filetypes = { 'qf' },
      }),
      plugin({
        fn = function() return require('oil').get_current_dir() end,
        title = 'oil ',
        filetypes = { 'oil' },
      }),
      plugin({
        title = 'neogit  ',
        filetypes = { 'NeogitStatus', 'NeogitLogView', 'NeogitCommitView', 'NeogitCommitSelectView' },
      }),
    },
    options = {
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      always_show_tabline = false,
    },
    sections = {
      lualine_a = { mode },
      lualine_b = { projectdir, branch, 'searchcount' },
      lualine_c = {
        stashstatus,
        pushstatus,
        {
          'filename',
          path = 3,
          cond = function()
            local bo = vim.bo[0]
            return bo.buftype ~= 'nofile'
                and bo.buftype ~= 'nowrite'
                and not ftmap[bo.filetype]
          end,
          color = filenamecolor,
          symbols = {
            modified = mod_icon,
            readonly = ro_icon,
            unnamed = '',
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

            if not success then return end

            return {
              modified = source.changed,
              added = source.added,
              removed = source.removed
            }
          end,
        },
      },
      lualine_x = { 'lsp_status', 'progress', 'location' },
      lualine_y = { 'encoding', { 'fileformat', symbols = { unix = '󰻀', dos = '󰖳', mac = '' } } },
      lualine_z = {
        {
          'custom',
          fmt = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local name = vim.api.nvim_buf_get_name(bufnr)
            local filetype = vim.bo[bufnr].filetype

            if filetype == '' then return '󰒡 ' end

            return require('nvim-web-devicons').get_icon(name, filetype) .. ' ' .. filetype
          end
        },
      },
    },
    tabline = {
      lualine_a = {
        {
          'tabs',
          mode = 0,
          path = 0,
          max_length = 1000,
          tab_max_length = 25,
          use_mode_colors = true,
          show_modified_status = false,
        },
      },
    },
  },
}
