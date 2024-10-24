local noremap = { remap = false, silent = true }
local remap = { remap = true, silent = true }

local k = vim.keymap
local merge = require('helpers').merge

-- Avoiding moving cursor when hitting <leader> followed by nothing
k.set({ 'n', 'o', 'x' }, '<leader>', '<nop>', noremap)

--- {{{ --| basics |----------------------------------------
-- Marks
k.set('n', "'", '`', noremap)
k.set('n', '`', "'", noremap)
k.set('n', '<leader>m', ':delmarks!<cr>', noremap)
k.set('i', '<c-cr>', '<esc>o', noremap)
-- Split lines
k.set('n', '<c-j>', 'i<cr><esc>', noremap)
-- Don't make a # force column zero.
k.set('i', '#', 'X<bs>#', noremap)
-- Fuck you, help.
k.set({ 'n', 'i' }, '<F1>', '<nop>', noremap)
-- Clever paste from system buffer
k.set({ 'n', 'o', 'x' }, '<leader>p', '"+p', noremap)
k.set({ 'n', 'o', 'x' }, '<leader>P', '"+P', noremap)
k.set({ 'n', 'o', 'x' }, '<leader>y', '"+y', noremap)
k.set('n', 'yf', ":<c-u>let @+ = expand(\"%\")<cr>:echo 'File name yanked.'<cr>", noremap)
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
k.set('n', 'gé', '*N:redraw!<cr>:%s/<c-r><c-w>//gI<left><left><left>')
-- move all lines matching pattern after cursor
k.set('n', 'gÉ', function()
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
end, require('helpers').merge(noremap, { desc = 'move matching lines after cursor' }))
-- find & replace
k.set('n', 'É', ':%s/<space><bs>')
k.set('x', 'É', '<esc>:%s/\\%V<space><bs>')
-- hide search matches
k.set('n', '<esc>', '<esc>:nohlsearch<cr>', noremap)
-- Find character
k.set({ 'n', 'x' }, ',', ';', noremap)
k.set({ 'n', 'x' }, ';', ',', noremap)
-- Close current buffer
k.set('n', 'Q', ':bdelete!<cr>', noremap)
-- Sanity mappings for command line mode
k.set('c', '<esc>', '<c-c>', noremap)
k.set('c', '<c-a>', '<home>')
-- Exit
k.set({ 'n', 'x' }, 'à', ':<c-u>confirm quit<cr>', noremap)
k.set({ 'n', 'x' }, 'À', ':<c-u>confirm quitall<cr>', noremap)
-- Save
k.set({ 'n', 'i', 'x' }, '<c-s>', '<esc>:w<cr>', noremap)
-- Reselect pasted lines
k.set('n', 'gV', '`[v`]', noremap)
-- direct access to numbers when in normal / operator pending / visual mode
k.set({ 'n', 'o', 'x' }, '"', '1', noremap)
k.set({ 'n', 'o', 'x' }, '1', '"', noremap)
k.set({ 'n', 'o', 'x' }, '«', '2', noremap)
k.set({ 'n', 'o' }, '2', '<<_', remap)
k.set('x', '2', '<gv', remap)
k.set({ 'n', 'o', 'x' }, '»', '3', noremap)
k.set({ 'n', 'o', }, '3', '>>_', remap)
k.set('x', '3', '>gv', remap)
k.set({ 'n', 'o', 'x' }, '(', '4', noremap)
k.set({ 'n', 'o', 'x' }, '4', '(', noremap)
k.set({ 'n', 'o', 'x' }, ')', '5', noremap)
k.set({ 'n', 'o', 'x' }, '5', ')', noremap)
k.set({ 'n', 'o', 'x' }, '@', '6', noremap)
k.set({ 'n', 'o', 'x' }, '6', '@', noremap)
k.set({ 'n', 'o', 'x' }, '+', '7', noremap)
k.set({ 'n', 'o', 'x' }, '7', '+', noremap)
k.set({ 'n', 'o', 'x' }, '-', '8', noremap)
k.set({ 'n', 'o', 'x' }, '8', '-', noremap)
k.set({ 'n', 'o', 'x' }, '/', '9', noremap)
k.set({ 'n', 'o', 'x' }, '9', '/', noremap)
k.set({ 'n', 'o', 'x' }, '*', '0', noremap)
k.set({ 'n', 'o', 'x' }, '0', '*', noremap)
-- sort
k.set('x', '<leader>s', ':sort<cr>', noremap)
-- macro
k.set({ 'n', 'o' }, '<leader><leader>', '@q', noremap)
k.set('x', '<leader><leader>', ':normal 6q<cr>', noremap)
--- }}}
--- {{{ --| quick access |----------------------------------
k.set('n', '<leader>em', function()
  if require('helpers').fileexists(vim.fn.expand('%')) then
    return ':tabe Makefile<cr>'
  else
    return ':e Makefile<cr>'
  end
end, { desc = 'Edit Makefile', expr = true, silent = true })
--- }}}
--- {{{ --| togglers |--------------------------------------
-- Uppercase current word
k.set('n', '<c-g>', 'gUiw', noremap)
k.set('i', '<c-g>', '<esc>gUiwea', noremap)
k.set('n', '<leader>k', function()
  vim.cmd [[
    normal! m`
    let _s=@/
    %substitute/\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)//e
    let @/=_s
    nohl
    normal! g``
  ]]
end, merge({ desc = 'Remove trailing spaces' }, noremap))
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
end, merge({ desc = 'Toggle crosshair' }, noremap))
-- Alternate file
k.set('n', '<c-k>', '<c-^>')
--- }}}
--- {{{ --| Quickfix / Location list |----------------------
k.set('n', '<leader>q', ':call ToggleQuickfixList()<cr>', merge({ desc = 'Toggle quickfix list' }, noremap))
k.set('n', '<leader>l', ':call ToggleLocationList()<cr>', merge({ desc = 'Toggle location list' }, noremap))
k.set('n', '<c-n>', ':cnext<cr>', noremap)
k.set('n', '<c-p>', ':cprev<cr>', noremap)
--- }}}
--- {{{ --| Diagnostics |-----------------------------------
k.set('n', 'Þ', vim.diagnostic.goto_next, noremap)
k.set('n', 'ẞ', vim.diagnostic.goto_prev, noremap)
--- }}}
--- {{{ --| terminal |--------------------------------------
k.set('t', '<c-s>', '<c-\\><c-n>', noremap)

k.set('n', '<leader>ti', ':tabnew<bar>terminal<cr>:startinsert!<cr>', noremap)
k.set('n', '<leader>vi', ':vertical new<bar>terminal<cr>:startinsert<cr>', noremap)
k.set('n', '<leader>ni', ':new<bar>terminal<cr>:startinsert<cr>', noremap)
--- }}}
--- {{{ --| splits / tabs |---------------------------------
k.set('n', '<left>', '<c-w>5<', noremap)
k.set('n', '<right>', '<c-w>5>', noremap)
k.set('n', '<up>', '<c-w>+', noremap)
k.set('n', '<down>', '<c-w>-', noremap)
k.set('n', 'co', ':tabo<cr><c-w>o', noremap)
-- Hack to make <c-w><c-c> mapping work
k.set('', '<c-c>', '<nop>', noremap)
k.set({ 'n', 'o', 'x' }, '<c-w><c-c>', '<c-w>H', noremap)
k.set({ 'n', 'o', 'x' }, '<c-w><c-t>', '<c-w>J', noremap)
k.set({ 'n', 'o', 'x' }, '<c-w><c-s>', '<c-w>K', noremap)
k.set({ 'n', 'o', 'x' }, '<c-w><c-r>', '<c-w>L', noremap)
-- Horizontal Split
k.set('n', '<leader>nn', ':new<cr>', noremap)
k.set('n', '<leader>ne', ":new <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Vertical split
k.set('n', '<leader>vv', ':vnew<cr>', noremap)
k.set('n', '<leader>ve', ":vnew <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Dimensions
k.set('n', '<leader>=', '<c-w>=', noremap)
k.set('n', '<leader>%', ':res<cr>:vertical res<cr>', noremap)
-- Moving around
k.set('n', '<c-i>', '<c-i>', noremap) -- force standard ctrl-i behavior (because we redefine tab later on)
k.set('n', '<c-o>', '<c-o>', noremap) -- force standard ctrl+o behavior (mostly to be symmetrical)
k.set('n', '<tab>', '<c-w>w', noremap)
k.set('n', '<s-tab>', '<c-w>W', noremap)
-- New tab
k.set('n', '<leader>tt', ':tabe<cr>', noremap)
k.set('n', '<leader>te', ":tabe <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Move current tab
k.set('n', '<leader>tm', ':tabm<leader>')
-- move current split to a new tab
k.set('n', '<leader>U', '<c-w>T', noremap)
-- merge current split into left-hand tab
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
--- }}}
--- {{{ --| folds management |------------------------------
k.set('n', '<leader>z', 'zMzv', noremap)
k.set('n', '<leader>Z', 'zR', noremap)
k.set('n', 'zO', 'zczO', noremap)
--- }}}
--- {{{ --| argwrap |---------------------------------------
k.set('n', '<leader>,', ':ArgWrap<CR>', noremap)
--- }}}
--- {{{ --| linediff |--------------------------------------
k.set('x', '<leader>d', ':Linediff<cr>', noremap)
--- }}}
