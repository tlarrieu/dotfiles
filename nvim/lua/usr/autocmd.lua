-- Balance splits size upon changing host window size
vim.api.nvim_create_autocmd('VimResized', {
  callback = function() vim.api.nvim_input('<esc><c-w>=') end,
  group = vim.api.nvim_create_augroup('dimensions', {})
})

-- Do not insert comments upon <cr> or o/O
vim.api.nvim_create_autocmd('FileType', {
  callback = function() vim.opt_local.formatoptions:remove({ 'o', 'r' }) end,
  group = vim.api.nvim_create_augroup('no_incremental_comments', {})
})

-- Deactivate spell checking on RO files
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function() if vim.bo.readonly then vim.opt_local.spell = false end end,
  group = vim.api.nvim_create_augroup('restore_position', {})
})

-- Set relativenumber only in active window
local number_group = vim.api.nvim_create_augroup('autonumber_group', {})

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  callback = function() if vim.wo.number then vim.wo.relativenumber = true end end,
  group = number_group
})

vim.api.nvim_create_autocmd('WinLeave', {
  callback = function() vim.wo.relativenumber = false end,
  group = number_group
})

-- auto turn on relativenumber if we activate number
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = { 'number' },
  callback = function() vim.wo.relativenumber = vim.wo.number end,
  group = number_group
})

-- highlight yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 200 }) end,
  group = vim.api.nvim_create_augroup("text_yank", {})
})

-- theme setting

local apply_xrdb = function()
  local theme = require('xrdb').load() or { vim = {} }
  vim.o.background = theme.vim.background or 'light'
  vim.cmd.colorscheme(theme.vim.theme or 'default')
  for i = 0, 15 do vim.g['terminal_color_' .. i] = theme['color' .. i] or vim.g['terminal_color_' .. i] end
end

apply_xrdb()

vim.api.nvim_create_autocmd('Signal', {
  pattern = { 'SIGUSR1' },
  callback = apply_xrdb,
  nested = true,
  group = vim.api.nvim_create_augroup('update_background', {}),
})

local cmdline_group = vim.api.nvim_create_augroup('msg_area_hl', {})

local set_msg_area_hl = function(link)
  vim.api.nvim_set_hl(0, 'MsgArea', { link = link })
  vim.cmd.redraw()
end

vim.api.nvim_create_autocmd('CmdlineEnter',
  { callback = function() set_msg_area_hl('MsgAreaCmd') end, group = cmdline_group })
vim.api.nvim_create_autocmd('CmdlineLeave',
  { callback = function() set_msg_area_hl('MsgAreaMsg') end, group = cmdline_group })
