" set background = light
" colorscheme solarized

set background=dark
colorscheme gruvbox

augroup OverLength
  autocmd!
  autocmd BufReadPost,BufEnter,FileType,TermOpen * call s:overlength()
  autocmd OptionSet textwidth call s:overlength()
augroup END

augroup SETUP_COLORS
  autocmd!
  autocmd OptionSet background call s:setupcolors()
  autocmd SourceCmd $MYVIMRC call s:setupcolors()
augroup END

function! s:overlength()
  let l:exclude = {
    \ 'filetype': [
    \   'qf',
    \   'man',
    \   'netrw',
    \   'csv',
    \   'log',
    \   'postgresql',
    \   'mysql',
    \   'fugitiveblame',
    \   '',
    \ ],
    \ 'buftype': ['terminal']
    \ }

  let l:ft_exclude = index(l:exclude['filetype'], &filetype) != -1
  let l:bt_exclude = index(l:exclude['buftype'], &buftype) != -1

  if l:ft_exclude || l:bt_exclude
    execute 'match Folded //'
  else
    execute 'match Folded /\%' . (&textwidth + 1) . 'v.\+/'
  endif
endfunction

function! s:setupcolors()
  highlight! link MatchParen Title

  highlight! link SignColumn Normal
  highlight! link SignatureMarkText SignColumn
  highlight! link HighlightedyankRegion SignColumn

  highlight! link StatusLine Normal
  highlight! link StatusLineNC Folded

  highlight! Folded cterm=bold

  highlight! link TabLine Folded
  highlight! link TabLineFill Folded
  highlight! link TabLineSel Normal

  highlight! link VertSplit Normal
endfunction

call s:setupcolors()
