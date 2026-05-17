-- Source local nvimrc on save
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '.nvim.lua',
  callback = function()
    vim.secure.trust({ action = 'allow', bufnr = 0 })
    vim.cmd.source('.nvim.lua')
  end,
})

-- Balance splits size upon changing host window size
vim.api.nvim_create_autocmd('VimResized', { callback = function() vim.api.nvim_input('<esc><c-w>=') end })

-- Do not insert comments upon <cr> or o/O
vim.api.nvim_create_autocmd('FileType', { callback = function() vim.opt_local.formatoptions:remove({ 'o', 'r' }) end })

-- Deactivate spell checking on RO files
vim.api.nvim_create_autocmd('BufReadPost',
  { callback = function() if vim.bo.readonly then vim.opt_local.spell = false end end })

-- Toggle relative numbering for active window only
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' },
  { callback = function() if vim.wo.number then vim.wo.relativenumber = true end end })
vim.api.nvim_create_autocmd('WinLeave', { callback = function() vim.wo.relativenumber = false end })

-- highlight yank
vim.api.nvim_create_autocmd('TextYankPost',
  { callback = function() vim.hl.on_yank({ higroup = "Visual", timeout = 200, on_visual = false }) end })

-- set git root directory as local working directory (useful when editing snippets on the fly for instance)
vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function()
    local path = vim.system({
      'git',
      '-C',
      vim.fn.expand('%:h'),
      'rev-parse',
      '--show-toplevel',
    }):wait().stdout:gsub('\n', '')
    if path ~= '' then vim.cmd.lcd(path) end
  end,
})

-- theme setting
local apply_xrdb = function()
  local theme = require('xrdb').load()
  vim.o.background = theme.variant or 'light'
  vim.cmd.colorscheme(vim.o.background == 'light' and 'dawnfox' or 'nordfox')
  for i = 0, 15 do vim.g['terminal_color_' .. i] = theme['color' .. i] or vim.g['terminal_color_' .. i] end
end

apply_xrdb()

vim.api.nvim_create_autocmd('Signal', { pattern = { 'SIGUSR1' }, callback = apply_xrdb, nested = true })

local cmdline_group = vim.api.nvim_create_augroup('msg_area_hl', {})

local set_msg_area_hl = function(link)
  vim.api.nvim_set_hl(0, 'MsgArea', { link = link })
  vim.cmd.redraw()
end

vim.api.nvim_create_autocmd('CmdlineEnter',
  { callback = function() set_msg_area_hl('MsgAreaCmd') end, group = cmdline_group })
vim.api.nvim_create_autocmd('CmdlineLeave',
  { callback = function() set_msg_area_hl('MsgAreaMsg') end, group = cmdline_group })
