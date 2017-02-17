augroup OverLength
  autocmd!
  autocmd BufReadPost,BufEnter,FileType,TermOpen * call s:overlength()
  autocmd OptionSet textwidth call s:overlength()
augroup END

augroup SETUP_COLORS
  autocmd!
  autocmd OptionSet background call s:setupcolors()
  autocmd VimEnter * call s:setupcolors()
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

function! s:highlights()
  highlight! link VertSplit CursorColumn
  highlight! link SignatureMarkText SignColumn
  highlight! link MatchParen Title
  highlight! link HighlightedyankRegion SignColumn
endfunction

function! s:setupcolors()
  let g:lightline.colorscheme = 'solarized'
  if &background ==# 'dark'
    " Use a custom solarized theme dedicated to dark
    let l:fzf_color = 'fg:242,fg+:7,hl:33,hl+:33,bg:8,bg+:8'
  else
    " Use a custom solarized theme dedicated to light
    let l:fzf_color = 'fg:242,fg+:8,hl:33,hl+:33,bg:15,bg+:15'
  end

  let $FZF_DEFAULT_OPTS = '--reverse --color ' . l:fzf_color

  call lightline#init()
  call lightline#update()

  call s:highlights()
endfunction
