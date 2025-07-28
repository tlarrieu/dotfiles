-- Avoiding moving cursor when hitting <leader> followed by nothing
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>', '<nop>', { silent = true })

--- {{{ --| basics |----------------------------------------
-- Marks
vim.keymap.set('n', "'", '`')
vim.keymap.set('n', '`', "'")
vim.keymap.set('n', 'Þ', "m]", { remap = true })
vim.keymap.set('n', 'ẞ', "m[", { remap = true })
vim.keymap.set('i', '<c-cr>', '<esc>o')
-- Split lines
vim.keymap.set('n', '<c-j>', 'i<cr><esc>')
-- Don't make a # force column zero.
vim.keymap.set('i', '#', 'X<bs>#')
-- Fuck you, help.
vim.keymap.set({ 'n', 'i' }, '<F1>', '<nop>')
-- make current file executable
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<cr>')
-- + register keymaps
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>P', '"+P')
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'o', 'x' }, '<leader>d', '"+d')
vim.keymap.set('n', 'yf', ":<c-u>let @+ = expand(\"%\")<cr>:echo 'File name yanked.'<cr>", { silent = true })
-- select the whole line
vim.keymap.set('n', 'vv', '^v$h')
-- Command line
vim.keymap.set({ 'n', 'x' }, 'è', ':')
vim.keymap.set({ 'n', 'x' }, 'È', ':!')
-- search
vim.keymap.set({ 'n', 'x' }, 'é', '/')
vim.keymap.set('n', '<c-é>', ':silent grep! ')
vim.keymap.set('n', '<leader>é', ':silent grep! <c-r><c-w><cr>', { silent = true })
vim.keymap.set('x', '<leader>é', '"by:silent grep! <c-r>b<cr>', { silent = true })
-- call snipe from visual mode
vim.keymap.set('x', '<leader>s', '<esc><cmd>call Snipe("new")<cr>')
-- replace occurrences of word under cursor
vim.keymap.set('n', 'cié', '*N:redraw!<cr>:%s/<c-r><c-w>//gI<left><left><left>')
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
vim.keymap.set('n', '<esc>', '<esc>:nohlsearch<cr>', { silent = true })
-- Find character
vim.keymap.set({ 'n', 'x' }, ',', ';')
vim.keymap.set({ 'n', 'x' }, ';', ',')
-- Close current buffer
vim.keymap.set('n', 'Q', ':bdelete!<cr>', { silent = true })
-- Sanity mappings for command line mode
vim.keymap.set('c', '<esc>', '<c-c>')
vim.keymap.set('c', '<c-a>', '<home>')
-- <BS> enters insert mode in select mode (this makes it easier to jump to the next snippet anchor)
vim.keymap.set('s', '<bs>', '<bs>i')
-- Exit
vim.keymap.set({ 'n', 'x' }, 'à', ':<c-u>confirm quit<cr>', { silent = true })
vim.keymap.set({ 'n', 'x' }, 'À', ':<c-u>confirm quitall<cr>', { silent = true })
-- Save
vim.keymap.set('n', 's', ':w ++p<cr>', { silent = true })
-- Reselect pasted lines
vim.keymap.set('n', 'gV', '`[v`]')
-- center after page scroll
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')
-- center after search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
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
vim.keymap.set('x', '<leader><leader>', ':normal 6q<cr>', { silent = true })
--- }}}
--- {{{ --| operations |------------------------------------
vim.keymap.set('o', 'ar', 'a[')
vim.keymap.set('o', 'ir', 'i[')
--- }}}
--- {{{ --| quick access |----------------------------------
vim.keymap.set('n', '<leader>em', function()
  if require('helpers').fileexists(vim.fn.expand('%')) then
    return ':tabe Makefile<cr>'
  else
    return ':e Makefile<cr>'
  end
end, { desc = 'Edit Makefile', expr = true, silent = true })
vim.keymap.set('n', '<leader>er', function()
  if require('helpers').fileexists(vim.fn.expand('%')) then
    return ':tabe ~/.pryrc.local<cr>'
  else
    return ':e ~/.pryrc.local<cr>'
  end
end, { desc = 'Edit local pryrc', expr = true, silent = true })
--- }}}
--- {{{ --| togglers |--------------------------------------
-- Uppercase current word
vim.keymap.set('n', '<c-g>', 'gUiw')
vim.keymap.set('i', '<c-g>', '<esc>gUiwea')
vim.keymap.set('n', '<leader>k', require('utils').trim_trailing_spaces,
  { silent = true, desc = 'Remove trailing spaces' })
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
-- Alternate file
vim.keymap.set('n', '<c-k>', '<c-^>')
--- }}}
--- {{{ --| Spelling |--------------------------------------
vim.keymap.set('n', '<a-n>', ']s', { silent = true, remap = true, desc = 'Next spelling error' })
vim.keymap.set('n', '<a-p>', '[s', { silent = true, remap = true, desc = 'Previous spelling error' })
--- }}}
--- {{{ --| Quickfix / Location list |----------------------
vim.keymap.set('n', '<c-n>', ':cnext<cr>', { silent = true })
vim.keymap.set('n', '<c-p>', ':cprev<cr>', { silent = true })
vim.keymap.set('n', '<leader>"', ':cc1<cr>', { silent = true })
vim.keymap.set('n', '<leader>«', ':cc2<cr>', { silent = true })
vim.keymap.set('n', '<leader>»', ':cc3<cr>', { silent = true })
vim.keymap.set('n', '<leader>(', ':cc4<cr>', { silent = true })
vim.keymap.set('n', '<leader>)', ':cc5<cr>', { silent = true })
--- }}}
--- {{{ --| Jumps |-----------------------------------------
vim.keymap.set('n', '<c-i>', '<c-i>')
vim.keymap.set('n', '<c-o>', '<c-o>')
--- }}}
--- {{{ --| Diagnostics |-----------------------------------
vim.keymap.set('n', '<c-þ>', function() vim.diagnostic.jump({ count = 1 }) end)
vim.keymap.set('n', '<c-ß>', function() vim.diagnostic.jump({ count = -1 }) end)
--- }}}
--- {{{ --| terminal |--------------------------------------
vim.keymap.set('t', '<esc>', '<c-\\><c-n>')
vim.keymap.set('n', '<leader>ti', ':tabnew<bar>terminal<cr>:startinsert!<cr>', { silent = true })
vim.keymap.set('n', '<leader>vi', ':vertical new<bar>terminal<cr>:startinsert<cr>', { silent = true })
vim.keymap.set('n', '<leader>ni', ':new<bar>terminal<cr>:startinsert<cr>', { silent = true })
--- }}}
--- {{{ --| splits / tabs |---------------------------------
vim.keymap.set('n', '<left>', '<c-w>5<')
vim.keymap.set('n', '<right>', '<c-w>5>')
vim.keymap.set('n', '<up>', '<c-w>+')
vim.keymap.set('n', '<down>', '<c-w>-')
vim.keymap.set('n', 'co', ':tabo<cr><c-w>o', { silent = true })
-- Hack to make <c-w><c-c> mapping work
vim.keymap.set('', '<c-c>', '<nop>')
vim.keymap.set({ 'n', 'o', 'x' }, '<c-w><c-c>', '<c-w>H')
vim.keymap.set({ 'n', 'o', 'x' }, '<c-w><c-t>', '<c-w>J')
vim.keymap.set({ 'n', 'o', 'x' }, '<c-w><c-s>', '<c-w>K')
vim.keymap.set({ 'n', 'o', 'x' }, '<c-w><c-r>', '<c-w>L')
-- Horizontal Split
vim.keymap.set('n', '<leader>ss', '<c-w>s', { silent = true })
vim.keymap.set('n', '<leader>se', ":new <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Vertical split
vim.keymap.set('n', '<leader>vv', '<c-w>v', { silent = true })
vim.keymap.set('n', '<leader>ve', ":vnew <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Dimensions
vim.keymap.set('n', '<leader>=', '<c-w>=')
vim.keymap.set('n', '<leader>%', ':res<cr>:vertical res<cr>', { silent = true })
-- Moving around
vim.keymap.set('n', '<tab>', '<c-w>w')
vim.keymap.set('n', '<s-tab>', '<c-w>W')
-- New tab
vim.keymap.set('n', '<leader>tt', ':tabe<cr>', { silent = true })
vim.keymap.set('n', '<leader>te', ":tabe <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Move current tab
vim.keymap.set('n', '<leader>tm', ':tabm<leader>')
-- move current split to a new tab
vim.keymap.set('n', '<leader>U', '<c-w>T', { desc = 'Move current window into its own tab' })
-- merge current split into left-hand tab
-- switch tabs
vim.keymap.set('n', '<c-tab>', 'gt', { silent = true, remap = true, desc = 'Next tab' })
vim.keymap.set('n', '<c-s-tab>', 'gT', { silent = true, remap = true, desc = 'Previous tab' })
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

  vim.api.nvim_win_close(0, true)
  vim.api.nvim_set_current_tabpage(prevtab)
  vim.cmd.vsplit()
  vim.api.nvim_win_set_buf(0, buf)
end, { desc = 'Merge current window into previous tab' })
--- }}}
--- {{{ --| folds management |------------------------------
vim.keymap.set('n', '<leader>z', 'zMzv')
vim.keymap.set('n', '<leader>Z', 'zR')
vim.keymap.set('n', 'zO', 'zczO')
--- }}}
--- {{{ --| linediff |--------------------------------------
vim.keymap.set('x', '<leader>gd', ':Linediff<cr>', { silent = true })
--- }}}
