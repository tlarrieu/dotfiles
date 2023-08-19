function map(shortcut, command)
  vim.api.nvim_set_keymap('', shortcut, command, {})
end

function noremap(shortcut, command)
  vim.api.nvim_set_keymap('', shortcut, command, { noremap = true })
end

function nmap(shortcut, command)
  vim.api.nvim_set_keymap('n', shortcut, command, {})
end

function nnoremap(shortcut, command)
  vim.api.nvim_set_keymap('n', shortcut, command, { noremap = true })
end

function imap(shortcut, command)
  vim.api.nvim_set_keymap('i', shortcut, command, {})
end

function inoremap(shortcut, command)
  vim.api.nvim_set_keymap('i', shortcut, command, { noremap = true })
end

function vmap(shortcut, command)
  vim.api.nvim_set_keymap('v', shortcut, command, {})
end

function vnoremap(shortcut, command)
  vim.api.nvim_set_keymap('v', shortcut, command, { noremap = true })
end

function omap(shortcut, command)
  vim.api.nvim_set_keymap('o', shortcut, command, {})
end

function onoremap(shortcut, command)
  vim.api.nvim_set_keymap('o', shortcut, command, { noremap = true })
end

function cmap(shortcut, command)
  vim.api.nvim_set_keymap('c', shortcut, command, {})
end

function cnoremap(shortcut, command)
  vim.api.nvim_set_keymap('c', shortcut, command, { noremap = true })
end

function tmap(shortcut, command)
  vim.api.nvim_set_keymap('t', shortcut, command, {})
end

function tnoremap(shortcut, command)
  vim.api.nvim_set_keymap('t', shortcut, command, { noremap = true })
end

-- Avoiding moving cursor when hitting <space> followed by nothing
map('<space>', '<nop>')

--- {{{ --| basics |----------------------------------------
-- Marks
noremap("'", '`')
noremap('`', "'")
noremap('<space>m', ':delmarks!<cr>')
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
noremap('<space>p', '"+p')
noremap('<space>P', '"+P')
noremap('<space>y', '"+y')
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
-- search based on word under cursor
nmap('<space>é', ':set operatorfunc=UsageOperator<cr>g@iw')
vmap('<space>é', ':<c-u>call UsageOperator(visualmode())<cr>')
nmap('<space>É', ':set operatorfunc=DefinitionOperator<cr>g@iw')
nnoremap('gé', '*N:redraw!<cr>:%s/<c-r><c-w>//g<left><left>')
-- find & replace
nnoremap('É', ':%s/')
vnoremap('É', '<esc>:%s/%V')
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
-- sort
vmap('<space>s', ':sort<cr>')
-- macro
noremap('<space><space>', '@q')
vnoremap('<space><space>', ':normal 6q<cr>')
--- }}}
--- {{{ --| quick access |----------------------------------
nmap('<space>eu', ':UltiSnipsEdit<cr>')
nmap('<space>eU', ':UltiSnipsEdit<space>')
nmap('<space>.', ':Texplore .<cr>')
--- }}}
--- {{{ --| togglers |--------------------------------------
-- Toggle highlight current word
nmap("<space>'", ':if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>')
-- Uppercase current word
nmap('<c-g>', 'gUiw')
imap('<c-g>', '<esc>gUiwea')
-- Clear trailing spaces (but not the escaped ones)
nmap('<space>k', 'm`:call ClearTrailingSpaces()<cr>g``')
-- Fix indent
nmap('ga', 'm`gg=G:call ClearTrailingSpaces()<cr>g``')
-- Cursorline / Cursorcolumn
nmap('<space>g', ':call AlignMode()<cr>')
-- Quickfix / Location list
nmap('<space>q', ':call ToggleQuickfixList()<cr>')
nmap('<space>l', ':call ToggleLocationList()<cr>')
--- }}}
--- {{{ --| terminal |--------------------------------------
tnoremap('<c-s>', '<c-\\><c-n>')

nmap('<space>ti', ':tabnew<bar>terminal<cr>:startinsert!<cr>')
nmap('<space>vi', ':vertical new<bar>terminal<cr>:startinsert<cr>')
nmap('<space>ni', ':new<bar>terminal<cr>:startinsert<cr>')
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
nmap('<space>nn', ':new<cr>')
nmap('<space>ne', ":new <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Vertical split
nmap('<space>vv', ':vnew<cr>')
nmap('<space>ve', ":vnew <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Dimensions
nmap('<space>=', '<c-w>=')
nmap('<space>%', ':res<cr>:vertical res<cr>')
-- Moving around
nmap('<tab>', '<c-w>w')
nmap('<s-tab>', '<c-w>W')
nmap('<c-n>', 'gt')
nmap('<c-p>', 'gT')
-- New tab
nmap('<space>tt', ':tabe<cr>')
nmap('<space>te', ":tabe <c-r>=escape(expand(\"%:p:h\"), ' ') . '/'<cr>")
-- Move current tab
nmap('<space>tm', ':tabm<space>')
-- Tab merge and “unmerge”
nmap('<space>U', '<c-w>T')
nmap('<space>u', ':call MergeTabs()<cr>')
--- }}}
--- {{{ --| folds management |------------------------------
nmap('<space>z', 'zMzv')
nnoremap('<space>Z', 'zR')
nnoremap('zO', 'zczO')
--- }}}

--- {{{ --| neoformat |-------------------------------------
vim.api.nvim_buf_set_keymap(
  0,
  'n',
  '<space>f',
  ':Neoformat<cr>',
  { noremap = true, silent = true }
)
vim.api.nvim_buf_set_keymap(
  0,
  'v',
  '<space>f',
  ':Neoformat<cr>',
  { noremap = true, silent = true }
)
--- }}}
--- {{{ --| neoterm |---------------------------------------
nmap('<space><tab>', ':Ttoggle<cr>')
vnoremap('<cr>', ':TREPLSendSelection<cr>')
--- }}}
--- {{{ --| argwrap |---------------------------------------
nnoremap('<space>,', ':ArgWrap<CR>')
--- }}}
--- {{{ --| FZF |-------------------------------------------
-- Standard mode (file list)
nmap('<c-t>', ':FZF -m -e<cr>')
-- Custom modes (home made functions)
nnoremap('<c-b>', ':FZFbuf<cr>')
nnoremap('<c-e>', ':FZFsearch<space>')
nnoremap('<c-c>', ':FZFtags tag<cr>')
nnoremap('<c-l>', ':FZFtags tag<cr>')
nnoremap('<c-y>', ':FZFGitFiles<cr>')
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
nmap('<space>tl', ':TabooRename<space>')
nmap('<space>tr', ':TabooReset<cr>')
--- }}}
--- {{{ --| fugitive |--------------------------------------
nmap('<space>a', ':Git commit --quiet --amend --no-edit<cr>')
nmap('<space>A', ':Git commit --quiet --amend<cr>')
nmap('<space>b', ':Git blame<cr>')
nmap('<space>c', ':Git commit --quiet<cr>')
nmap('<space>d', ':Gvdiff<cr>')
nmap('<space>D', ':Gvdiff master<cr>')
nmap('<space>ed', ':tab Git diff --staged<cr>')
nmap('<space>r', ':Gread<cr>')
nmap('<space>R', ':Git reset %<cr>')
nmap('<space>s', ':Git<cr>')
nmap('<space>S', ':GV<cr>')
vmap('<space>S', ":'<,'>GV<cr>")
nmap('<space>w', ':Gwrite<cr>')
--- }}}
--- {{{ --| linediff |--------------------------------------
vmap('<space>d', ':Linediff<cr>')
--- }}}
