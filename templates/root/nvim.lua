-- {{{ --| Colors |-------------------------------------------------------------
vim.cmd.colorscheme('retrobox')
vim.o.background = 'dark'
vim.cmd('filetype plugin off')
vim.cmd('syntax on')
-- }}}

-- {{{ --| lines numbering |----------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true
-- }}}

-- {{{ --| Keymaps |------------------------------------------------------------
vim.g.mapleader = ' '
local k = vim.keymap
local noremap = { remap = false, silent = true }

-- Avoiding moving cursor when hitting <leader> followed by nothing
k.set('', '<leader>', '<nop>', noremap)

-- {{{ --| basics |-----------------------------------------
-- Marks
k.set('n', "'", '`', noremap)
k.set('n', '`', "'", noremap)
k.set('n', '<leader>m', '<cmd>delmarks!<cr>', noremap)
k.set('i', '<c-cr>', '<esc>o', noremap)
-- Split lines
k.set('n', '<c-j>', 'i<cr><esc>', noremap)
-- Don't make a # force column zero.
k.set('i', '#', 'X<bs>#', noremap)
-- Fuck you, help.
k.set({ 'n', 'i' }, '<F1>', '<nop>', noremap)
-- Clever paste from system buffer
k.set('', '<leader>p', '"+p', noremap)
k.set('', '<leader>P', '"+P', noremap)
k.set('', '<leader>y', '"+y', noremap)
k.set('n', 'yf', [[<cmd>let @+ = expand("%")<cr><cmd>echo 'File name yanked.'<cr>]], noremap)
-- Give a more logical behavior to Y
k.set('n', 'Y', 'y$', noremap)
-- select the whole line
k.set('n', 'vv', '^v$h', noremap)
-- Command line
k.set({ 'n', 'x' }, 'è', ':')
k.set({ 'n', 'x' }, 'È', ':!')
-- search
k.set({ 'n', 'x' }, 'é', '/')
-- replace occurrences of word under cursor
k.set('n', 'gé', '*N<cmd>redraw!<cr>:%s/<c-r><c-w>//gI<left><left><left>', noremap)
-- find & replace
k.set('n', 'É', ':%s/<space><bs>')
k.set('x', 'É', '<esc>:%s/\\%V<space><bs>')
-- hide search matches
k.set('n', '<esc>', '<esc><cmd>nohlsearch<cr>', noremap)
-- Find character
k.set({ 'n', 'x' }, ',', ';', noremap)
k.set({ 'n', 'x' }, ';', ',', noremap)
-- Close current buffer
k.set('n', 'Q', '<cmd>bdelete!<cr>', noremap)
-- Sanity mappings for command line mode
k.set('c', '<esc>', '<c-c>', noremap)
k.set('c', '<c-a>', '<home>')
-- Exit
k.set({ 'n', 'x' }, 'à', '<cmd>confirm quit<cr>', noremap)
k.set({ 'n', 'x' }, 'À', '<cmd>confirm quitall<cr>', noremap)
-- Save
k.set('n', 's', '<cmd>w ++p<cr>', noremap)
-- Reselect pasted lines
k.set('n', 'gV', '`[v`]', noremap)
-- It is more convenient to access numbers directly when in normal mode
k.set('', '"', '1', noremap)
k.set('', '1', '"', noremap)
k.set('', '«', '2', noremap)
k.set('', '2', '<<_', noremap)
k.set('x', '2', '<gv', noremap)
k.set('', '»', '3', noremap)
k.set('', '3', '>>_', noremap)
k.set('x', '3', '>gv', noremap)
k.set('', '(', '4', noremap)
k.set('', '4', '(', noremap)
k.set('', ')', '5', noremap)
k.set('', '5', ')', noremap)
k.set('', '@', '6', noremap)
k.set('', '6', '@', noremap)
k.set('', '+', '7', noremap)
k.set('', '7', '+', noremap)
k.set('', '-', '8', noremap)
k.set('', '8', '-', noremap)
k.set('', '/', '9', noremap)
k.set('', '9', '/', noremap)
k.set('', '*', '0', noremap)
k.set('', '0', '*', noremap)
-- sort
k.set('x', 's', ':sort<cr>', noremap)
-- macro
k.set('', '<leader><leader>', '@q', noremap)
k.set('x', '<leader><leader>', '<cmd>normal 6q<cr>', noremap)
-- }}}
-- {{{ --| togglers |---------------------------------------
-- Uppercase current word
k.set('n', '<c-g>', 'gUiw', noremap)
k.set('i', '<c-g>', '<esc>gUiwea', noremap)
-- Clear trailing leaders (but not the escaped ones)
k.set('n', '<leader>k', function()
  vim.cmd [[
    normal! m`
    let _s=@/
    %substitute/\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)//e
    let @/=_s
    nohl
    normal! g``
  ]]
end, noremap)
-- Cursorline / Cursorcolumn
k.set('n', '<leader>r', function()
  vim.cmd [[
    if &virtualedit ==# 'all'
      setlocal virtualedit=""
    else
      setlocal virtualedit=all
    end
    setlocal cursorcolumn!
    setlocal cursorline!
  ]]
end, noremap)
-- Alternate file
vim.keymap.set('n', '<c-k>', '<c-^>')
-- Quickfix list
local togglelist = function()
  local curwin = vim.api.nvim_get_current_win()

  local found = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'quickfix' then
      found = vim.fn.bufwinnr(buf) ~= -1
      break
    end
  end

  if found then vim.cmd.cclose() else vim.cmd.copen() end

  vim.api.nvim_set_current_win(curwin)
end
vim.keymap.set('n', '<leader>q', togglelist, { desc = 'Toggle quickfix list' })
-- {{{ --| splits / tabs |----------------------------------
k.set('n', '<left>', '<c-w>5<', noremap)
k.set('n', '<right>', '<c-w>5>', noremap)
k.set('n', '<up>', '<c-w>+', noremap)
k.set('n', '<down>', '<c-w>-', noremap)
k.set('n', 'co', '<cmd>tabo<cr><c-w>o', noremap)
-- Hack to make <c-w><c-c> mapping work
k.set('', '<c-c>', '<nop>', noremap)
k.set('', '<c-w><c-c>', '<c-w>H', noremap)
k.set('', '<c-w><c-t>', '<c-w>J', noremap)
k.set('', '<c-w><c-s>', '<c-w>K', noremap)
k.set('', '<c-w><c-r>', '<c-w>L', noremap)

local edit_path = function(cmd)
  return function() return ':' .. cmd .. ' ' .. vim.fn.escape(vim.fn.expand('%:p:h'), ' ') .. '/' end
end
-- Horizontal Split
k.set('n', '<leader>ss', '<c-w>s', { silent = true })
k.set('n', '<leader>se', edit_path('new'), { expr = true })
-- Vertical split
k.set('n', '<leader>vv', '<c-w>v', { silent = true })
k.set('n', '<leader>ve', edit_path('vnew'), { expr = true })
-- Tabs
k.set('n', '<leader>tt', '<cmd>tabe<cr>', { silent = true })
k.set('n', '<leader>te', edit_path('tabe'), { expr = true })
-- Dimensions
k.set('n', '<leader>=', '<c-w>=', noremap)
k.set('n', '<leader>%', '<cmd>res<cr><cmd>vertical res<cr>', noremap)
-- Moving around
k.set('n', '<c-i>', '<c-i>', noremap) -- force standard ctrl-i behavior (because we redefine tab later on)
k.set('n', '<c-o>', '<c-o>', noremap) -- force standard ctrl+o behavior (mostly to be symetrical)
k.set('n', '<tab>', '<c-w>w', noremap)
k.set('n', '<s-tab>', '<c-w>W', noremap)
k.set('n', '<c-tab>', 'gt', noremap)
k.set('n', '<c-s-tab>', 'gT', noremap)
k.set('n', '<c-n>', '<cmd>cnext<cr>', noremap)
k.set('n', '<c-p>', '<cmd>cprev<cr>', noremap)
-- Move current tab
k.set('n', '<leader>tm', '<cmd>tabm<leader>')
-- move current split to a new tab
k.set('n', '<leader>U', '<c-w>T', noremap)
-- merge current split into lefthand tab
k.set('n', '<leader>u', function()
  local curtab = vim.api.nvim_get_current_tabpage()

  -- tabs are not numbered the way they are displayed,
  -- we have to go through the list
  local prevtab = 0
  for _, num in ipairs(vim.api.nvim_list_tabpages()) do
    if num == curtab then break end
    prevtab = num
  end

  if curtab == 0 then return end

  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_win_close(0, true)
  vim.api.nvim_set_current_tabpage(prevtab)
  vim.cmd.vsplit()
  vim.api.nvim_win_set_buf(0, buf)
end, noremap)
-- }}}
-- {{{ --| folds management |-------------------------------
k.set('n', '<leader>z', 'zMzv', noremap)
k.set('n', '<leader>Z', 'zR', noremap)
k.set('n', 'zO', 'zczO', noremap)
-- }}}
-- }}}
