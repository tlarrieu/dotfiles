" set background=light
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
  highlight! link SignatureMarkText Folded
  highlight! link HighlightedyankRegion Folded

  highlight! Folded cterm=bold

  highlight! link TabLine Normal
  highlight! link TabLineFill Normal
  highlight! TabLineSel ctermfg=5 ctermbg=none cterm=none

  highlight! link VertSplit Normal

  highlight! link User1 Normal

  highlight! link QuickFixLine DiffChange
endfunction

call s:setupcolors()
