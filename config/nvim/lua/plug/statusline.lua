vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' }, { confirm = false })

local ro_icon = '󱆠'
local modified_icon = '󰴓 '
local ftmap = {
  harpoon = 'harpoon',
  mason = 'mason',
  TelescopePrompt = 'telescope',
  qf = 'quickfix',
  oil = 'oil',
}

local mode_icons = {
  NORMAL = ' 󰹻 ',
  ['O-PENDING'] = '  ',
  INSERT = ' 󰏪 ',
  COMMAND = ' 󰞷 ',
  TERMINAL = '  ',
  SELECT = ' 󰫙 ',
  VISUAL = ' 󰩭 ',
  ['V-LINE'] = ' 󰩭 ',
  ['V-BLOCK'] = ' 󰩭 ',
}
local mode = { 'mode', icons_enabled = true, fmt = function(mode) return mode_icons[mode] or mode end }

local projectdir = function()
  local cwd = vim.fn.getcwd()
  if cwd == vim.fn.expand('~') then return ' ~' end

  local project
  for dir in string.gmatch(cwd, "[^/]+") do project = dir end
  if project == '.neorg' then return '󰠮 wiki' end
  if project == 'accounting' then return '󰗑 accounting' end
  if project == 'completorium' then return '󰅄 completorium' end
  if project == 'dotfiles' then return ' dotfiles' end
  return ' ' .. project
end

local branch = {
  function()
    local ok, name = pcall(vim.fn.FugitiveHead, 8)
    if not ok then return '' end

    local length = 40
    if #name > length then return name:sub(0, length) .. ' ' else return name end
  end,
  icon = { '', align = 'left' }
}

local tabs = function()
  local tabcount = #vim.api.nvim_list_tabpages()

  if tabcount <= 1 then return '' end

  local tabindex = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())

  return string.format('󰓩  %d | %d', tabindex, tabcount)
end

local searchcount = function()
  if vim.v.hlsearch == 0 then return '' end

  local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
  if not ok or next(result) == nil then return '' end

  if result.total == 0 then return '' end

  return string.format(
    ' %d/%d',
    result.current,
    math.min(result.total, result.maxcount)
  )
end

local rec_msg = ''
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  group = vim.api.nvim_create_augroup('LualineRecordingSection', { clear = true }),
  callback = function(e)
    rec_msg = e.event == 'RecordingEnter' and ' REC @' .. vim.fn.reg_recording() or ''
  end,
})

local macrorecording = { function() return rec_msg end, color = 'LualineMacroRecording' }

local selectioncount = function()
  local height = math.abs(vim.fn.line('v') - vim.fn.line('.')) + 1
  local width = math.abs(vim.fn.col('v') - vim.fn.col('.')) + 1
  local vmode = vim.fn.mode(true)

  if vmode:match('') then return '󰁌 ' .. string.format('%d×%d', height, width) end
  if vmode:match('V') or height > 1 then return '󰡏 ' .. tostring(height) end
  if vmode:match('v') then return '󰡎 ' .. tostring(width) end

  return ''
end

local filenamecolor = function()
  if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0 then return 'LualineError' end
  if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) > 0 then return 'LualineWarning' end
  if vim.fn.executable(vim.api.nvim_buf_get_name(0)) == 1 then return 'LualineExecutable' end
end

local plugin = function(cfg)
  return {
    sections = {
      lualine_a = { mode },
      lualine_b = { projectdir, branch, tabs, searchcount },
      lualine_c = { macrorecording, cfg.fn },
      lualine_x = { selectioncount, 'location' },
      lualine_z = { function() return cfg.title or '' end },
    },
    filetypes = cfg.filetypes or {}
  }
end

local compact = function(str) return str:gsub('/home/%w+/', '~/') end

require('lualine').setup({
  extensions = {
    'mason',
    plugin({
      fn = function() return vim.fn.getqflist({ title = 0 }).title end,
      title = ' quickfix',
      filetypes = { 'qf' },
    }),
    plugin({
      fn = function() return compact(require('oil').get_current_dir()) end,
      title = ' oil',
      filetypes = { 'oil' },
    }),
    plugin({
      fn = function() return compact(vim.fn.FugitiveGitDir():gsub('/.git', '')) end,
      title = ' fugitive',
      filetypes = { 'fugitive' },
    }),
    plugin({
      fn = function() return compact(vim.fn.FugitiveGitDir():gsub('/.git', '')) end,
      title = ' logs',
      filetypes = { 'floggraph' },
    }),
  },
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    always_show_tabline = false,
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { projectdir, branch, tabs, searchcount },
    lualine_c = {
      macrorecording,
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
          modified = modified_icon,
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

          return success and source or nil
        end,
      },
    },
    lualine_x = {
      selectioncount,
      {
        'lsp_status',
        icon = ' ',
        symbols = {
          spinner = { '', '', '' },
          done = '',
          separator = ' • ',
        },
      },
      'progress',
      'location',
    },
    lualine_y = { 'encoding', { 'fileformat', symbols = { unix = '󰻀', dos = '󰖳', mac = '' } } },
    lualine_z = {
      {
        function()
          local bufnr = vim.api.nvim_get_current_buf()

          local icon, filetype = require('helpers').icon_and_filetype(
            vim.api.nvim_buf_get_name(bufnr),
            vim.bo[bufnr].filetype
          )

          return icon .. ' ' .. filetype
        end
      },
    },
  },
})
