vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' }, { confirm = false })

local ro_icon = '󱆠'
local mod_icon = '󰴓 '
local ftmap = {
  harpoon = 'harpoon',
  mason = 'mason',
  TelescopePrompt = 'telescope',
  qf = 'quickfix',
  oil = 'oil',
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

local projectdir = function()
  local cwd = vim.fn.getcwd()
  if cwd == vim.fn.expand('~') then return ' ~' end

  local project
  for dir in string.gmatch(cwd, "[^/]+") do project = dir end
  if cwd == vim.fn.expand('~/.neorg') then return '󰠮 ' .. project end
  if cwd == vim.fn.expand('~/.hledger') then return '󰗑 ' .. project end
  return ' ' .. project
end

local branch = {
  'branch',
  fmt = function(name)
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

local macrorecording = {
  function() return rec_msg end,
  color = function()
    local palette = require('colors').palette()
    if not palette then return { fg = 'red' } end
    return { fg = palette.red.base }
  end,
}

local selectioncount = function()
  local height = math.abs(vim.fn.line('v') - vim.fn.line('.')) + 1
  local width = math.abs(vim.fn.col('v') - vim.fn.col('.')) + 1

  local curmode = vim.fn.mode(true)

  if curmode:match('') then
    return '󰁌 ' .. string.format('%d×%d', height, width)
  elseif curmode:match('V') or height > 1 then
    return '󰡏 ' .. tostring(height)
  elseif curmode:match('v') then
    return '󰡎 ' .. tostring(width)
  else
    return ''
  end
end

local stashstatus = {
  function()
    local handle = io.popen("git stash list 2> /dev/null | wc -l")
    if not handle then return '' end

    local result = tonumber(handle:read("*a"))
    handle:close()

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
    handle:close()

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
      lualine_b = { projectdir, branch, tabs, searchcount },
      lualine_c = { macrorecording, stashstatus, pushstatus, cfg.fn },
      lualine_x = { selectioncount, 'location' },
      lualine_z = { function() return cfg.title or '' end },
    },
    filetypes = cfg.filetypes or {}
  }
end

require('lualine').setup({
  extensions = {
    'mason',
    plugin({
      fn = function() return vim.fn.getqflist({ title = 0 }).title end,
      title = ' quickfix',
      filetypes = { 'qf' },
    }),
    plugin({
      fn = function() return require('oil').get_current_dir() end,
      title = ' oil',
      filetypes = { 'oil' },
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
    lualine_x = { selectioncount, 'lsp_status', 'progress', 'location' },
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
