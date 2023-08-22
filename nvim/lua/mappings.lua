local k = vim.keymap

function map(keys, cmd) k.set('', keys, cmd, {}) end
function noremap(keys, cmd) k.set('', keys, cmd, { remap = false }) end

function nmap(keys, cmd) k.set('n', keys, cmd, {}) end
function nnoremap(keys, cmd) k.set('n', keys, cmd, { remap = false }) end

function imap(keys, cmd) k.set('i', keys, cmd, {}) end
function inoremap(keys, cmd) k.set('i', keys, cmd, { remap = false }) end

function vmap(keys, cmd) k.set('v', keys, cmd, {}) end
function vnoremap(keys, cmd) k.set('v', keys, cmd, { remap = false }) end

function omap(keys, cmd) k.set('o', keys, cmd, {}) end
function onoremap(keys, cmd) k.set('o', keys, cmd, { remap = false }) end

function cmap(keys, cmd) k.set('c', keys, cmd, {}) end
function cnoremap(keys, cmd) k.set('c', keys, cmd, { remap = false }) end

function tmap(keys, cmd) k.set('t', keys, cmd, {}) end
function tnoremap(keys, cmd) k.set('t', keys, cmd, { remap = false }) end

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
noremap('è', ':')
noremap('È', ':!')
-- search
noremap('é', '/')
-- replace occurences of word under cursor
nnoremap('gé', '*N:redraw!<cr>:%s/<c-r><c-w>//g<left><left>')
-- find & replace
nnoremap('É', ':%s/')
vnoremap('É', '<esc>:%s/\\%V')
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
nmap('<a-p>', ':cprev<cr>')
nmap('<a-n>', ':cnext<cr>')
-- sort
vmap('<leader>s', ':sort<cr>')
-- macro
noremap('<leader><leader>', '@q')
vnoremap('<leader><leader>', ':normal 6q<cr>')
--- }}}
--- {{{ --| quick access |----------------------------------
nmap('<leader>eu', ':UltiSnipsEdit<cr>')
nmap('<leader>eU', ':UltiSnipsEdit<leader>')
nmap('<leader>.', ':tabedit .<cr>')
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
nmap('<leader>k', 'm`:call ClearTrailingSpaces()<cr>g``')
-- Fix indent
nmap('ga', 'm`gg=G:call ClearTrailingleaders()<cr>g``')
-- Cursorline / Cursorcolumn
nmap('<leader>g', ':call AlignMode()<cr>')
-- Quickfix / Location list
nmap('<leader>q', ':call ToggleQuickfixList()<cr>')
nmap('<leader>l', ':call ToggleLocationList()<cr>')
--- }}}
--- {{{ --| terminal |--------------------------------------
tnoremap('<c-s>', '<c-\\><c-n>')

nmap('<leader>ti', ':tabnew<bar>terminal<cr>:startinsert!<cr>')
nmap('<leader>vi', ':vertical new<bar>terminal<cr>:startinsert<cr>')
nmap('<leader>ni', ':new<bar>terminal<cr>:startinsert<cr>')
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
nmap('<leader>nn', ':new<cr>')
nmap('<leader>ne', ":new <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Vertical split
nmap('<leader>vv', ':vnew<cr>')
nmap('<leader>ve', ":vnew <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Dimensions
nmap('<leader>=', '<c-w>=')
nmap('<leader>%', ':res<cr>:vertical res<cr>')
-- Moving around
nmap('<tab>', '<c-w>w')
nmap('<s-tab>', '<c-w>W')
nmap('<c-n>', 'gt')
nmap('<c-p>', 'gT')
-- New tab
nmap('<leader>tt', ':tabe<cr>')
nmap('<leader>te', ":tabe <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Move current tab
nmap('<leader>tm', ':tabm<leader>')
-- Tab merge and “unmerge”
nmap('<leader>U', '<c-w>T')
nmap('<leader>u', ':call MergeTabs()<cr>')
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
nmap('<leader><tab>', ':Ttoggle<cr>')
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
nmap('<leader>a', ':Git commit --quiet --amend --no-edit<cr>')
nmap('<leader>A', ':Git commit --quiet --amend<cr>')
nmap('<leader>b', ':Git blame<cr>')
nmap('<leader>c', ':Git commit --quiet<cr>')
nmap('<leader>d', ':Gvdiff<cr>')
nmap('<leader>D', ':Gvdiff master<cr>')
nmap('<leader>ed', ':tab Git diff --staged<cr>')
nmap('<leader>r', ':Gread<cr>')
nmap('<leader>R', ':Git reset %<cr>')
nmap('<leader>s', ':Git<cr>')
nmap('<leader>S', ':GV<cr>')
vmap('<leader>S', ":'<,'>GV<cr>")
nmap('<leader>w', ':Gwrite<cr>')
--- }}}
--- {{{ --| linediff |--------------------------------------
vmap('<leader>d', ':Linediff<cr>')
--- }}}
