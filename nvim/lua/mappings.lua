vim.g.mapleader = " "

local default_options = { remap = false, silent = true }
local silent = { silent = true }
local noopts = {}

local k = vim.keymap

-- Avoiding moving cursor when hitting <leader> followed by nothing
k.set('', '<leader>', '<nop>', { silent = true })

--- {{{ --| basics |----------------------------------------
-- Marks
k.set('n', "'", '`', default_options)
k.set('n', '`', "'", default_options)
k.set('n', '<leader>m', ':delmarks!<cr>', default_options)
-- Beginning / end of the line
k.set('c', '<c-a>', '<home>', default_options)
k.set('c', '<c-e>', '<end>', default_options)
-- Split lines
k.set('n', '<c-j>', 'i<cr><esc>', default_options)
-- Don't make a # force column zero.
k.set('i', '#', 'X<bs>#', default_options)
-- Fuck you, help.
k.set({ 'n', 'i' }, '<F1>', '<nop>', default_options)
-- Clever paste from system buffer
k.set('', '<leader>p', '"+p', default_options)
k.set('', '<leader>P', '"+P', default_options)
k.set('', '<leader>y', '"+y', default_options)
k.set('n', 'yf', ":<c-u>let @+ = expand(\"%\")<cr>:echo 'File name yanked.'<cr>", default_options)
-- Give a more logical behavior to Y
k.set('n', 'Y', 'y$', default_options)
-- Visual yank
k.set('v', 'y', 'ygv<esc>', default_options)
k.set('v', 'Y', 'Ygv<esc>', default_options)
-- select the whole line
k.set('n', 'vv', '^v$h', default_options)
-- Command line
k.set({ 'n', 'v' }, 'è', ':', noopts)
k.set({ 'n', 'v' }, 'È', ':!', noopts)
-- search
k.set({ 'n', 'v' }, 'é', '/', noopts)
-- replace occurences of word under cursor
k.set('n', 'gé', '*N:redraw!<cr>:%s/<c-r><c-w>//g<left><left>', noopts)
-- find & replace
k.set('n', 'É', ':%s/', noopts)
k.set('v', 'É', '<esc>:%s/\\%V', noopts)
-- hide search matches
k.set( 'n', '<esc>', function()
    require('illuminate').pause()
    return '<esc>:nohlsearch<cr><c-l>'
  end,
  { silent = true, remap = false, expr = true }
)
-- Find character
k.set({ 'n', 'v' }, ',', ';', default_options)
k.set({ 'n', 'v' }, ';', ',', default_options)
-- block
k.set({ 'n', 'v' }, '<m-t>', '}', noopts)
k.set({ 'n', 's' }, '<m-s>', '{', noopts)
-- Close current buffer
k.set('n', 'Q', ':bdelete!<cr>', default_options)
-- Normal mode
k.set('c', '<esc>', '<c-c>', default_options)
-- Exit
k.set('n', 'à', ':confirm quit<cr>', default_options)
k.set('n', 'À', ':confirm quitall<cr>', default_options)
-- Save
k.set({ 'n', 'i', 'v' }, '<c-s>', '<esc>:w<cr>', default_options)
-- Reselect pasted lines
k.set('n', 'gV', '`[v`]', default_options)
-- It is more convenient to access numbers directly when in normal mode
k.set('', '"', '1', default_options)
k.set('', '1', '"', default_options)
k.set('', '«', '2', default_options)
k.set('', '2', '<<_', default_options)
k.set('v', '2', '<gv', default_options)
k.set('', '»', '3', default_options)
k.set('', '3', '>>_', default_options)
k.set('v', '3', '>gv', default_options)
k.set('', '(', '4', default_options)
k.set('', '4', '(', default_options)
k.set('', ')', '5', default_options)
k.set('', '5', ')', default_options)
k.set('', '@', '6', default_options)
k.set('', '6', '@', default_options)
k.set('', '+', '7', default_options)
k.set('', '7', ':GitGutterStageHunk<cr>', default_options)
k.set('', '-', '8', default_options)
k.set('', '8', ':GitGutterUndoHunk<cr>', default_options)
k.set('', '/', '9', default_options)
k.set('', '9', '/', default_options)
k.set('', '*', '0', default_options)
k.set('', '0', '*', default_options)
-- diff hunk navigation
k.set('n', 'ß', '<Plug>(GitGutterPrevHunk)', { silent = true })
k.set('n', 'þ', '<Plug>(GitGutterNextHunk)', { silent = true })
-- quickfix navigation
k.set('n', '<a-p>', ':cprev<cr>', default_options)
k.set('n', '<a-n>', ':cnext<cr>', default_options)
-- sort
k.set('v', '<leader>s', ':sort<cr>', default_options)
-- macro
k.set('', '<leader><leader>', '@q', default_options)
k.set('v', '<leader><leader>', ':normal 6q<cr>', default_options)
--- }}}
--- {{{ --| quick access |----------------------------------
k.set('n', '<leader>eu', ':UltiSnipsEdit<cr>', default_options)
k.set('n', '<leader>eU', ':UltiSnipsEdit<leader>', default_options)
k.set('n', '<leader>.', ':tabedit .<cr>', default_options)
--- }}}
--- {{{ --| togglers |--------------------------------------
-- Toggle highlight current word
k.set('n', "<leader>'", require('illuminate').resume, noopts)
k.set('n', "<a-e>", require('illuminate').goto_next_reference, noopts)
k.set('n', "<a-i>", require('illuminate').goto_prev_reference, noopts)
-- Uppercase current word
k.set('n', '<c-g>', 'gUiw', noopts)
k.set('i', '<c-g>', '<esc>gUiwea', noopts)
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
end, noopts)
-- Cursorline / Cursorcolumn
k.set('n', '<leader>g', function()
  vim.cmd [[
    if &virtualedit ==# 'all'
      setlocal virtualedit=""
    else
      setlocal virtualedit=all
    end
    setlocal cursorcolumn!
    setlocal cursorline!
  ]]
end, noopts)
-- Quickfix / Location list
k.set('n', '<leader>q', ':call ToggleQuickfixList()<cr>', default_options)
k.set('n', '<leader>l', ':call ToggleLocationList()<cr>', default_options)
--- }}}
--- {{{ --| terminal |--------------------------------------
k.set('t', '<c-s>', '<c-\\><c-n>', default_options)

k.set('n', '<leader>ti', ':tabnew<bar>terminal<cr>:startinsert!<cr>', default_options)
k.set('n', '<leader>vi', ':vertical new<bar>terminal<cr>:startinsert<cr>', default_options)
k.set('n', '<leader>ni', ':new<bar>terminal<cr>:startinsert<cr>', default_options)
--- }}}
--- {{{ --| splits / tabs |---------------------------------
k.set('n', '<left>', '<c-w><', default_options)
k.set('n', '<right>', '<c-w>>', default_options)
k.set('n', '<up>', '<c-w>+', default_options)
k.set('n', '<down>', '<c-w>-', default_options)
k.set('n', 'cO', ':tabo<cr><c-w>o', default_options)
k.set('n', 'co', '<c-w>o', default_options)
-- Hack to make <c-w><c-c> mapping work
k.set('', '<c-w><c-c>', '<c-w>H', default_options)
k.set('', '<c-w><c-t>', '<c-w>J', default_options)
k.set('', '<c-w><c-s>', '<c-w>K', default_options)
k.set('', '<c-w><c-r>', '<c-w>L', default_options)
-- Horizontal Split
k.set('n', '<leader>nn', ':new<cr>', default_options)
k.set('n', '<leader>ne', ":new <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>", default_options)
-- Vertical split
k.set('n', '<leader>vv', ':vnew<cr>', default_options)
k.set('n', '<leader>ve', ":vnew <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>", default_options)
-- Dimensions
k.set('n', '<leader>=', '<c-w>=', default_options)
k.set('n', '<leader>%', ':res<cr>:vertical res<cr>', default_options)
-- Moving around
k.set('n', '<tab>', '<c-w>w', noopts)
k.set('n', '<s-tab>', '<c-w>W', noopts)
k.set('n', '<c-n>', 'gt', noopts)
k.set('n', '<c-p>', 'gT', noopts)
-- New tab
k.set('n', '<leader>tt', ':tabe<cr>', default_options)
k.set('n', '<leader>te', ":tabe <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>", default_options)
-- Move current tab
k.set('n', '<leader>tm', ':tabm<leader>', noopts)
-- move current split to a new tab
k.set('n', '<leader>U', '<c-w>T', noopts)
-- merge current split into lefthand tab
k.set('n', '<leader>u', function()
  -- FIXME: This should be moved to an actual lua function once we have the proper
  -- API for that (or until I find it)
  vim.cmd [[
    if tabpagenr() != 1
      let bufferName = bufname("%")
      if tabpagenr("$") == tabpagenr()
        close!
      else
        close!
        tabprev
      endif
      execute "vs " . bufferName
    endif
  ]]
end, noopts)
--- }}}
--- {{{ --| folds management |------------------------------
k.set('n', '<leader>z', 'zMzv', noopts)
k.set('n', '<leader>Z', 'zR', default_options)
k.set('n', 'zO', 'zczO', default_options)
--- }}}
--- {{{ --| neoformat |-------------------------------------
k.set({ 'n', 'v' }, '<leader>f', ':Neoformat<cr>', default_options)
--- }}}
--- {{{ --| neoterm |---------------------------------------
k.set('n', '<leader><tab>', ':Ttoggle<cr>', default_options)
k.set('v', '<cr>', ':TREPLSendSelection<cr>', default_options)
--- }}}
--- {{{ --| argwrap |---------------------------------------
k.set('n', '<leader>,', ':ArgWrap<CR>', default_options)
--- }}}
--- {{{ --| Telescope |-------------------------------------
local builtin = require('telescope.builtin')
k.set('n', '<c-t>', builtin.find_files, default_options)
k.set('n', '<c-e>', builtin.live_grep, default_options)
k.set('n', '<leader>é', builtin.grep_string, default_options)
k.set('n', '<c-b>', builtin.buffers, default_options)
k.set('n', '<c-h>', builtin.help_tags, default_options)
k.set('n', '<c-y>', builtin.git_status, default_options)
k.set('n', '<c-l>', builtin.tags, default_options)
k.set('n', '<c-q>', builtin.quickfix, default_options)
k.set('n', '<c-è>', ':TodoTelescope<cr>', default_options)
--- }}}
--- {{{ --| packer |----------------------------------------
k.set('n', '<leader>i', ':PackerInstall<cr>', default_options)
k.set('n', '<leader>I', ':PackerSync<cr>', default_options)
--- }}}
--- {{{ --| angry |-----------------------------------------
k.set({ 'v', 'o' }, 'ac', '<Plug>AngryOuterPrefix', noopts)
k.set({ 'v', 'o' }, 'ic', '<Plug>AngryInnerPrefix', noopts)
k.set({ 'v', 'o' }, 'aC', '<Plug>AngryOuterSuffix', noopts)
k.set({ 'v', 'o' }, 'iC', '<Plug>AngryInnerSuffix', noopts)
--- }}}
--- {{{ --| taboo |-----------------------------------------
k.set('n', '<leader>tl', ':TabooRename<leader>', noopts)
k.set('n', '<leader>tr', ':TabooReset<cr>', noopts)
--- }}}
--- {{{ --| fugitive |--------------------------------------
k.set('n', '<leader>a', ':Git commit --quiet --amend --no-edit<cr>', default_options)
k.set('n', '<leader>A', ':Git commit --quiet --amend<cr>', default_options)
k.set('n', '<leader>b', ':Git blame<cr>', default_options)
k.set('n', '<leader>c', ':Git commit --quiet<cr>', default_options)
k.set('n', '<leader>d', ':Gvdiff<cr>', default_options)
k.set('n', '<leader>D', ':Gvdiff master<cr>', default_options)
k.set('n', '<leader>ed', ':tab Git diff --staged<cr>', default_options)
k.set('n', '<leader>r', ':Gread<cr>', default_options)
k.set('n', '<leader>R', ':Git reset %<cr>', default_options)
k.set('n', '<leader>s', ':Git<cr>', default_options)
k.set('n', '<leader>S', ':GV<cr>', default_options)
k.set('v', '<leader>S', ":'<,'>GV<cr>", default_options)
k.set('n', '<leader>w', ':Gwrite<cr>', default_options)
--- }}}
--- {{{ --| linediff |--------------------------------------
k.set('v', '<leader>d', ':Linediff<cr>', default_options)
--- }}}
