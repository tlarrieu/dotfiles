local k = vim.keymap
local options = { remap = false, silent = true }

function map(keys, cmd) k.set('', keys, cmd, {}) end
function noremap(keys, cmd) k.set('', keys, cmd, options) end

function nmap(keys, cmd) k.set('n', keys, cmd, {}) end
function nnoremap(keys, cmd) k.set('n', keys, cmd, options) end

function imap(keys, cmd) k.set('i', keys, cmd, {}) end
function inoremap(keys, cmd) k.set('i', keys, cmd, options) end

function vmap(keys, cmd) k.set('v', keys, cmd, {}) end
function vnoremap(keys, cmd) k.set('v', keys, cmd, options) end

function omap(keys, cmd) k.set('o', keys, cmd, {}) end
function onoremap(keys, cmd) k.set('o', keys, cmd, options) end

function cmap(keys, cmd) k.set('c', keys, cmd, {}) end
function cnoremap(keys, cmd) k.set('c', keys, cmd, options) end

function tmap(keys, cmd) k.set('t', keys, cmd, {}) end
function tnoremap(keys, cmd) k.set('t', keys, cmd, options) end

vim.g.mapleader = " "

-- Avoiding moving cursor when hitting <leader> followed by nothing
map('<leader>', '<nop>')

--- {{{ --| basics |----------------------------------------
-- Marks
noremap("'", '`')
noremap('`', "'")
noremap('<leader>m', ':delmarks!<cr>')
-- Beginning / end of the line
cnoremap('<c-a>', '<home>')
cnoremap('<c-e>', '<end>')
-- Split lines
noremap('<c-j>', 'i<cr><esc>')
-- Don't make a # force column zero.
inoremap('#', 'X<bs>#')
-- Fuck you, help.
nnoremap('<F1>', '<nop>')
inoremap('<F1>', '<nop>')
-- Clever paste from system buffer
noremap('<leader>p', '"+p')
noremap('<leader>P', '"+P')
noremap('<leader>y', '"+y')
nnoremap('yf', ":<c-u>let @+ = expand(\"%\")<cr>:echo 'File name yanked.'<cr>")
-- Give a more logical behavior to Y
nnoremap('Y', 'y$')
-- Visual yank
vnoremap('y', 'ygv<esc>')
vnoremap('Y', 'Ygv<esc>')
-- select the whole line
nnoremap('vv', '^v$h')
-- Command line
nmap('è', ':')
nmap('È', ':!')
-- search
nmap('é', '/')
-- replace occurences of word under cursor
nmap('gé', '*N:redraw!<cr>:%s/<c-r><c-w>//g<left><left>')
-- find & replace
nmap('É', ':%s/')
vmap('É', '<esc>:%s/\\%V')
-- hide search matches
nnoremap('<esc>', '<esc>:nohlsearch<cr><c-l>')
-- Find character
nnoremap(',', ';')
nnoremap(';', ',')
vnoremap(',', ';')
vnoremap(';', ',')
-- block
nmap('<m-t>', '}')
nmap('<m-s>', '{')
-- Close current buffer
nnoremap('Q', ':bdelete!<cr>')
-- Normal mode
cnoremap('<esc>', '<c-c>')
-- Exit
nnoremap('à', ':confirm quit<cr>')
nnoremap('À', ':confirm quitall<cr>')
-- Save
nnoremap('<c-s>', ':w<cr>')
inoremap('<c-s>', '<esc>:w<cr>')
vnoremap('<c-s>', '<esc>:w<cr>')
-- Reselect pasted lines
nnoremap('gV', '`[v`]')
-- It is more convenient to access numbers directly when in normal mode
noremap('"', '1')
noremap('1', '"')
noremap('«', '2')
noremap('2', '<<_')
vnoremap('2', '<gv')
noremap('»', '3')
noremap('3', '>>_')
vnoremap('3', '>gv')
noremap('(', '4')
noremap('4', '(')
noremap(')', '5')
noremap('5', ')')
noremap('@', '6')
noremap('6', '@')
noremap('+', '7')
noremap('7', ':GitGutterStageHunk<cr>')
noremap('-', '8')
noremap('8', ':GitGutterUndoHunk<cr>')
noremap('/', '9')
noremap('9', '/')
noremap('*', '0')
noremap('0', '*')
-- diff hunk navigation
nmap('ß', '<Plug>(GitGutterPrevHunk)')
nmap('þ', '<Plug>(GitGutterNextHunk)')
-- quickfix navigation
nnoremap('<a-p>', ':cprev<cr>')
nnoremap('<a-n>', ':cnext<cr>')
-- sort
vnoremap('<leader>s', ':sort<cr>')
-- macro
noremap('<leader><leader>', '@q')
vnoremap('<leader><leader>', ':normal 6q<cr>')
--- }}}
--- {{{ --| quick access |----------------------------------
nnoremap('<leader>eu', ':UltiSnipsEdit<cr>')
nnoremap('<leader>eU', ':UltiSnipsEdit<leader>')
nnoremap('<leader>.', ':tabedit .<cr>')
--- }}}
--- {{{ --| togglers |--------------------------------------
-- Toggle highlight current word
nmap("<leader>'", require('illuminate').toggle)
nmap("<a-e>", require('illuminate').goto_next_reference)
nmap("<a-i>", require('illuminate').goto_prev_reference)
-- Uppercase current word
nmap('<c-g>', 'gUiw')
imap('<c-g>', '<esc>gUiwea')
-- Clear trailing leaders (but not the escaped ones)
nmap('<leader>k', function()
  vim.cmd [[
    normal! m`
    let _s=@/
    %substitute/\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)//e
    let @/=_s
    nohl
    normal! g``
  ]]
end)
-- Cursorline / Cursorcolumn
nmap('<leader>g', function()
  vim.cmd [[
    if &virtualedit ==# 'all'
      setlocal virtualedit=""
    else
      setlocal virtualedit=all
    end
    setlocal cursorcolumn!
    setlocal cursorline!
  ]]
end)
-- Quickfix / Location list
nnoremap('<leader>q', ':call ToggleQuickfixList()<cr>')
nnoremap('<leader>l', ':call ToggleLocationList()<cr>')
--- }}}
--- {{{ --| terminal |--------------------------------------
tnoremap('<c-s>', '<c-\\><c-n>')

nnoremap('<leader>ti', ':tabnew<bar>terminal<cr>:startinsert!<cr>')
nnoremap('<leader>vi', ':vertical new<bar>terminal<cr>:startinsert<cr>')
nnoremap('<leader>ni', ':new<bar>terminal<cr>:startinsert<cr>')
--- }}}
--- {{{ --| splits / tabs |---------------------------------
nnoremap('<left>', '<c-w><')
nnoremap('<right>', '<c-w>>')
nnoremap('<up>', '<c-w>+')
nnoremap('<down>', '<c-w>-')
nnoremap('cO', ':tabo<cr><c-w>o')
nnoremap('co', '<c-w>o')
-- Hack to make <c-w><c-c> mapping work
noremap('<c-w><c-c>', '<c-w>H')
noremap('<c-w><c-t>', '<c-w>J')
noremap('<c-w><c-s>', '<c-w>K')
noremap('<c-w><c-r>', '<c-w>L')
-- Horizontal Split
nnoremap('<leader>nn', ':new<cr>')
nnoremap('<leader>ne', ":new <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Vertical split
nnoremap('<leader>vv', ':vnew<cr>')
nnoremap('<leader>ve', ":vnew <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Dimensions
nnoremap('<leader>=', '<c-w>=')
nnoremap('<leader>%', ':res<cr>:vertical res<cr>')
-- Moving around
nmap('<tab>', '<c-w>w')
nmap('<s-tab>', '<c-w>W')
nmap('<c-n>', 'gt')
nmap('<c-p>', 'gT')
-- New tab
nnoremap('<leader>tt', ':tabe<cr>')
nnoremap('<leader>te', ":tabe <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Move current tab
nmap('<leader>tm', ':tabm<leader>')
-- move current split to a new tab
nmap('<leader>U', '<c-w>T')
-- merge current split into lefthand tab
nmap('<leader>u', function()
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
end)
--- }}}
--- {{{ --| folds management |------------------------------
nmap('<leader>z', 'zMzv')
nnoremap('<leader>Z', 'zR')
nnoremap('zO', 'zczO')
--- }}}
--- {{{ --| neoformat |-------------------------------------
nnoremap('<leader>f', ':Neoformat<cr>')
vnoremap('<leader>f', ':Neoformat<cr>')
--- }}}
--- {{{ --| neoterm |---------------------------------------
nnoremap('<leader><tab>', ':Ttoggle<cr>')
vnoremap('<cr>', ':TREPLSendSelection<cr>')
--- }}}
--- {{{ --| argwrap |---------------------------------------
nnoremap('<leader>,', ':ArgWrap<CR>')
--- }}}
--- {{{ --| Telescope |-------------------------------------
local builtin = require('telescope.builtin')
nmap('<c-t>', builtin.find_files)
nnoremap('<c-e>', builtin.live_grep)
nnoremap('<leader>é', builtin.grep_string)
nnoremap('<c-b>', builtin.buffers)
nnoremap('<c-h>', builtin.help_tags)
nnoremap('<c-y>', builtin.git_status)
nnoremap('<c-l>', builtin.tags)
nnoremap('<c-q>', builtin.quickfix)
nnoremap('<c-è>', ':TodoTelescope<cr>')
--- }}}
--- {{{ --| packer |----------------------------------------
nnoremap('<leader>i', ':PackerInstall<cr>')
nnoremap('<leader>I', ':PackerSync<cr>')
--- }}}
--- {{{ --| angry |-----------------------------------------
vmap('ac', '<Plug>AngryOuterPrefix')
omap('ac', '<Plug>AngryOuterPrefix')
vmap('ic', '<Plug>AngryInnerPrefix')
omap('ic', '<Plug>AngryInnerPrefix')
vmap('aC', '<Plug>AngryOuterSuffix')
omap('aC', '<Plug>AngryOuterSuffix')
vmap('iC', '<Plug>AngryInnerSuffix')
omap('iC', '<Plug>AngryInnerSuffix')
--- }}}
--- {{{ --| taboo |-----------------------------------------
nmap('<leader>tl', ':TabooRename<leader>')
nmap('<leader>tr', ':TabooReset<cr>')
--- }}}
--- {{{ --| fugitive |--------------------------------------
nnoremap('<leader>a', ':Git commit --quiet --amend --no-edit<cr>')
nnoremap('<leader>A', ':Git commit --quiet --amend<cr>')
nnoremap('<leader>b', ':Git blame<cr>')
nnoremap('<leader>c', ':Git commit --quiet<cr>')
nnoremap('<leader>d', ':Gvdiff<cr>')
nnoremap('<leader>D', ':Gvdiff master<cr>')
nnoremap('<leader>ed', ':tab Git diff --staged<cr>')
nnoremap('<leader>r', ':Gread<cr>')
nnoremap('<leader>R', ':Git reset %<cr>')
nnoremap('<leader>s', ':Git<cr>')
nnoremap('<leader>S', ':GV<cr>')
vnoremap('<leader>S', ":'<,'>GV<cr>")
nnoremap('<leader>w', ':Gwrite<cr>')
--- }}}
--- {{{ --| linediff |--------------------------------------
vnoremap('<leader>d', ':Linediff<cr>')
--- }}}
