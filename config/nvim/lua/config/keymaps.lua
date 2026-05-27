-- ====| Essentials |===========================================================

-- Avoiding moving cursor when hitting <leader> followed by nothing
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>', '<nop>', { silent = true })
-- undo
vim.keymap.set('n', 'U', '<c-r>')
-- Marks
vim.keymap.set('n', "'", '`')
vim.keymap.set('n', '`', "'")
vim.keymap.set('n', 'Þ', "m]", { remap = true })
vim.keymap.set('n', 'ẞ', "m[", { remap = true })
-- file navigation
vim.keymap.set('n', 'gf', 'gF')
vim.keymap.set('n', '<c-w>gf', function()
  vim.cmd.vsplit()
  vim.cmd.normal('gf')
end)
vim.keymap.set('n', 'gF', 'gf')
vim.keymap.set('n', '<c-w>gF', function()
  vim.cmd.vsplit()
  vim.cmd.normal('gF')
end)
-- Split lines
vim.keymap.set('n', '<c-j>', 'i<cr><esc>')
-- Don't make a # force column zero.
vim.keymap.set('i', '#', 'X<bs>#')
-- Fuck you, help.
vim.keymap.set({ 'n', 'i' }, '<F1>', '<nop>')
-- open file under the cursor in github (to navigate shorthand repo links mostly)
vim.keymap.set('n', 'gh', function() vim.system({ 'browser-kiosk', vim.fn.expand('<cfile>') }) end, { silent = true })
-- make current file executable
vim.keymap.set('n', '<leader>x', '<cmd>silent !chmod +x %<cr><cmd>echo "file is now executable"<cr>')
-- navigate wrapped lines like normal lines
vim.keymap.set('n', 'k', 'gk', { remap = true })
vim.keymap.set('n', 'j', 'gj', { remap = true })
-- + register keymaps
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>P', '"+P')
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>y', '"+y')
vim.keymap.set('n', 'yf', "<cmd>let @+ = expand(\"%\")<cr><cmd>echo 'File name yanked.'<cr>", { silent = true })
-- select the whole line
vim.keymap.set('n', 'vv', '^v$h')
-- Command line
vim.keymap.set({ 'n', 'x' }, 'è', ':')
vim.keymap.set({ 'n', 'x' }, 'È', '@:')
-- search
vim.keymap.set({ 'n', 'x' }, 'é', '/')
vim.keymap.set('n', '<c-é>', ':silent grep! ')
vim.keymap.set('n', '<leader>é', ':silent grep! <c-r><c-w><cr>', { silent = true })
vim.keymap.set('x', '<leader>é', '"by:silent grep! <c-r>b<cr>', { silent = true })
-- replace occurrences of word under cursor
vim.keymap.set('n', 'cié', '*N<cmd>redraw!<cr>:%s/<c-r><c-w>//I<left><left>')
-- move all lines matching pattern after cursor
vim.keymap.set('n', 'gÉ', function()
  local input = vim.fn.input({ prompt = '󰛢: ' })
  if input == '' then return end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local offset = 0
  local capture, rest = {}, {}

  for i, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line:find(input, 1, true) then
      table.insert(capture, line)
      if i <= cursor[1] then offset = offset + 1 end
    else
      table.insert(rest, line)
    end
  end

  local buffer = {}
  for i = 1, cursor[1] - offset do
    table.insert(buffer, rest[i])
  end
  for _, line in ipairs(capture) do
    table.insert(buffer, line)
  end
  for i = cursor[1] - offset + 1, #rest do
    table.insert(buffer, rest[i])
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, buffer)
end, { desc = 'move matching lines after cursor' })
-- find & replace
vim.keymap.set('n', 'É', ':%s/')
vim.keymap.set('x', 'É', '<esc>:%s/\\%V')
-- hide search matches
vim.keymap.set(
  'n',
  '<esc>',
  '<esc>cxc<cmd>nohlsearch<bar>Cursorword disable<cr>', -- cxc clears exchange
  { silent = true, remap = true }
)
-- Find character
vim.keymap.set({ 'n', 'x' }, ',', ';')
vim.keymap.set({ 'n', 'x' }, ';', ',')
-- Close current buffer
vim.keymap.set('n', 'Q', '<cmd>bdelete!<cr>', { silent = true })
-- Sanity mappings for command line mode
vim.keymap.set('c', '<esc>', '<c-c>')
vim.keymap.set('c', '<c-a>', '<home>')
-- <BS> enters insert mode in select mode (this makes it easier to jump to the next snippet anchor)
vim.keymap.set('s', '<bs>', '<bs>i')
-- Exit
vim.keymap.set({ 'n', 'x' }, 'à', '<cmd>confirm quit<cr>', { silent = true })
vim.keymap.set({ 'n', 'x' }, 'À', '<cmd>confirm quitall<cr>', { silent = true })
-- Restart
vim.keymap.set({ 'n', 'x' }, '<leader>à',
  function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[bufnr].buftype == 'terminal' then vim.cmd.bd { args = { bufnr }, bang = true } end
    end
    vim.cmd.mksession { args = { '/tmp/session.nvim' }, bang = true }
    vim.cmd('confirm restart source /tmp/session.nvim')
  end,
  { silent = true })
-- Save
vim.keymap.set('n', 's', function() vim.cmd('silent update ++p') end)
-- Reselect pasted lines
vim.keymap.set('n', 'gV', '`[v`]')
-- center after go to bottom
vim.keymap.set({ 'n', 'x' }, 'G', 'Gzz')
-- center after page scroll
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')
-- center after search
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
-- direct access to numbers when in normal / operator pending / visual mode
vim.keymap.set({ 'n', 'o', 'x' }, '"', '1')
vim.keymap.set({ 'n', 'o', 'x' }, '1', '"')
vim.keymap.set({ 'n', 'o', 'x' }, '«', '2')
vim.keymap.set({ 'n', 'o' }, '2', '<<_', { remap = true })
vim.keymap.set('x', '2', '<gv', { remap = true })
vim.keymap.set({ 'n', 'o', 'x' }, '»', '3')
vim.keymap.set({ 'n', 'o', }, '3', '>>_', { remap = true })
vim.keymap.set('x', '3', '>gv', { remap = true })
vim.keymap.set({ 'n', 'o', 'x' }, '(', '4')
vim.keymap.set({ 'n', 'o', 'x' }, '4', '(')
vim.keymap.set({ 'n', 'o', 'x' }, ')', '5')
vim.keymap.set({ 'n', 'o', 'x' }, '5', ')')
vim.keymap.set({ 'n', 'o', 'x' }, '@', '6')
vim.keymap.set({ 'n', 'o', 'x' }, '6', '@')
vim.keymap.set({ 'n', 'o', 'x' }, '+', '7')
vim.keymap.set({ 'n', 'o', 'x' }, '7', '+')
vim.keymap.set({ 'n', 'o', 'x' }, '-', '8')
vim.keymap.set({ 'n', 'o', 'x' }, '8', '-')
vim.keymap.set({ 'n', 'o', 'x' }, '/', '9')
vim.keymap.set({ 'n', 'o', 'x' }, '9', '/')
vim.keymap.set({ 'n', 'o', 'x' }, '*', '0')
vim.keymap.set({ 'n', 'o', 'x' }, '0', '*')
-- sort
vim.keymap.set('x', 's', ':sort<cr>', { silent = true })
-- macro
vim.keymap.set({ 'n', 'o' }, '<leader><leader>', '@q')
vim.keymap.set('x', '<leader><leader>', '<cmd>normal 6q<cr>', { silent = true })
-- }}}

-- ====| Quick access |=========================================================

local quickedit = function(path)
  return function()
    local keep_buffer = require('helpers').fileexists(vim.fn.expand('%')) or vim.bo.buftype == 'terminal'
    return '<cmd>' .. (keep_buffer and 'vsplit' or 'edit') .. ' ' .. path .. '<cr>'
  end
end

local quicksave = function(path)
  return function()
    vim.notify('Writing to "' .. path .. '"')
    return '<cmd>silent w! ' .. path .. '<cr>'
  end
end

local builder = require('helpers').fileexists('Makefile') and 'Makefile' or 'Justfile'
vim.keymap.set('n', '<leader>em', quickedit(builder), { desc = 'Edit ' .. builder, expr = true })
vim.keymap.set('n', '<leader>en', quickedit('.nvim.lua'), { desc = 'Edit Makefile', expr = true })
vim.keymap.set('n', '<leader>er', quickedit('~/.ruby.local'), { desc = 'Edit local (irb/pry)rc', expr = true })
vim.keymap.set('n', '<leader>eR', quickedit('~/.pryrc'), { desc = 'Edit pryrc', expr = true })
vim.keymap.set('n', '<leader>eo', quickedit('~/output.txt'), { desc = 'Edit output.txt', expr = true })
vim.keymap.set('n', '<leader>ei', quickedit('~/input.txt'), { desc = 'Edit input.txt', expr = true })
vim.keymap.set('n', '<leader>so', quicksave('~/output.txt'), { desc = 'Save to output.txt', expr = true })
vim.keymap.set('n', '<leader>si', quicksave('~/input.txt'), { desc = 'Save to input.txt', expr = true })

-- ====| Togglers |=============================================================

-- Uppercase current word
vim.keymap.set('n', '<c-g>', 'gUiw')
vim.keymap.set('i', '<c-g>', '<esc>gUiwea')
local trim_trailing_spaces = function()
  vim.cmd [[
    normal! m`
    let _s=@/
    %substitute/\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)//e
    let @/=_s
    nohl
    normal! g``
  ]]
end
vim.keymap.set('n', '<leader>k', trim_trailing_spaces, { silent = true, desc = 'Remove trailing spaces' })

-- Cursorline / Cursorcolumn
vim.keymap.set('n', '<leader>r', function()
  vim.cmd [[
    if &virtualedit ==# 'all'
      setlocal virtualedit=""
    else
      setlocal virtualedit=all
    end
    setlocal cursorcolumn!
    setlocal cursorline!
  ]]
end, { desc = 'Toggle crosshair' })
vim.keymap.set('n', '<leader>R', function()
  vim.wo.cursorline = not vim.wo.cursorline
end, { desc = 'Toggle crosshair' })

-- Alternate file
vim.keymap.set('n', '<c-$>', '<c-^>')

-- ====| Spelling |=============================================================

vim.keymap.set('n', '<a-n>', ']szz', { silent = true, remap = true, desc = 'Next spelling error' })
vim.keymap.set('n', '<a-p>', '[szz', { silent = true, remap = true, desc = 'Previous spelling error' })

-- ====| Quickfix |=============================================================

local cgo = function(cmd)
  return function()
    local qflist = vim.fn.getqflist({ idx = 0, items = {} })
    local fn = (qflist.idx == 1 and qflist.items[1].bufnr ~= vim.api.nvim_get_current_buf())
        and vim.cmd.cc
        or function() vim.cmd('silent ' .. cmd) end
    local ok, _ = pcall(fn)
    if ok then vim.cmd.normal('zz') end
  end
end

vim.keymap.set('n', '<c-n>', cgo('cnext!'), { silent = true })
vim.keymap.set('n', '<c-p>', cgo('cprev!'), { silent = true })
vim.keymap.set('n', '<c-c>', cgo('crewind!'), { silent = true })

vim.keymap.set('n', '<leader>q', function()
  if vim.fn.getqflist({ winid = 0 }).winid > 0 then return vim.cmd.cclose() end

  local lastwin = vim.api.nvim_get_current_win()
  vim.cmd('below copen')
  vim.api.nvim_set_current_win(lastwin)
end, { desc = 'Toggle quickfix list' })

-- ====| Jumps |================================================================

vim.keymap.set('n', '<c-i>', '<c-i>zz')
vim.keymap.set('n', '<c-o>', '<c-o>zz')

-- ====| Diagnostics |==========================================================

vim.keymap.set('n', '<c-þ>', ']dzz', { remap = true })
vim.keymap.set('n', '<c-ß>', '[dzz', { remap = true })

-- ====| Treesitter |===========================================================

vim.keymap.set('n', '<c-s-space>', 'van', { remap = true })
vim.keymap.set('x', '<c-s-space>', 'an', { remap = true })
vim.keymap.set('x', '<bs>', 'in', { remap = true })

vim.keymap.set('n', '<leader>i', vim.show_pos, { desc = 'Inspect' })
vim.keymap.set('n', '<leader>I', function() vim.treesitter.inspect_tree({ command = 'vnew' }) end,
  { desc = 'InspectTree' })

-- ====| Terminal |=============================================================

vim.keymap.set('t', '<esc>', '<c-\\><c-n>')
vim.keymap.set('n', '<leader>ti', '<cmd>tab terminal<cr><cmd>startinsert!<cr>', { silent = true })
vim.keymap.set('n', '<leader>vi', '<cmd>vertical terminal<cr><cmd>startinsert!<cr>', { silent = true })
vim.keymap.set('n', '<leader>ni', '<cmd>horizontal terminal<cr><cmd>startinsert!<cr>', { silent = true })

-- ====| Windows |==============================================================

vim.keymap.set('n', '<left>', '<c-w>5<')
vim.keymap.set('n', '<right>', '<c-w>5>')
vim.keymap.set('n', '<up>', '<c-w>+')
vim.keymap.set('n', '<down>', '<c-w>-')
vim.keymap.set('n', 'co', '<cmd>silent tabo<cr><c-w>o')
vim.keymap.set('n', 'cO', '<c-w>o')
vim.keymap.set({ 'n', 'o', 'x' }, '<c-w><c-c>', '<c-w>H')
vim.keymap.set({ 'n', 'o', 'x' }, '<c-w><c-t>', '<c-w>J')
vim.keymap.set({ 'n', 'o', 'x' }, '<c-w><c-s>', '<c-w>K')
vim.keymap.set({ 'n', 'o', 'x' }, '<c-w><c-r>', '<c-w>L')
vim.keymap.set({ 'n', 'o', 'x' }, ' ', '<c-w>r')

-- Splits
vim.keymap.set('n', '<leader>ss', vim.cmd.split, { silent = true })
vim.keymap.set('n', '<leader>vv', vim.cmd.vsplit, { silent = true })
vim.keymap.set('n', '<leader>tt', function() vim.cmd('tab split') end, { silent = true })
-- Dimensions
vim.keymap.set('n', '<leader>=', '<c-w>=')
vim.keymap.set('n', '<leader>%', '<cmd>res<cr><cmd>vertical res<cr>', { silent = true })
-- Moving around
vim.keymap.set('n', '<tab>', '<c-w>w')
vim.keymap.set('n', '<s-tab>', '<c-w>W')
-- Move current tab
vim.keymap.set('n', '<leader>tm', ':tabm<space>')
-- switch tabs
vim.keymap.set('n', '<c-tab>', 'gt', { silent = true, remap = true, desc = 'Next tab' })
vim.keymap.set('n', '<c-s-tab>', 'gT', { silent = true, remap = true, desc = 'Previous tab' })
-- move current split to a new tab
vim.keymap.set('n', '<leader>U', '<c-w>T', { desc = 'Move current window into its own tab' })
-- merge current split into left-hand tab
vim.keymap.set('n', '<leader>u', function()
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

  local success, _ = pcall(vim.api.nvim_win_close, 0, true)
  if success then
    vim.api.nvim_set_current_tabpage(prevtab)
    vim.cmd.vsplit()
    vim.api.nvim_win_set_buf(0, buf)
  end
end, { desc = 'Merge current window into previous tab' })
-- }}}

-- ====| Folds |================================================================

vim.keymap.set('n', '<leader>z', 'zMzv')
vim.keymap.set('n', '<leader>Z', 'zR')
vim.keymap.set('n', 'zO', 'zczO')

-- ====| Diff |=================================================================

vim.keymap.set(
  'n',
  '<leader>D',
  function() if vim.wo.diff then vim.cmd.diffoff({ bang = true }) else vim.cmd.diffthis() end end,
  { silent = true }
)
