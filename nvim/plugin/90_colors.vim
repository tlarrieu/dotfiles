highlight! OverLength ctermbg=red ctermfg=black guibg=red guifg=black

augroup OverLength
  autocmd!
  autocmd BufReadPost,BufEnter,FileType * call s:overlength()
augroup END

let s:no_over_length = ['qf', 'man', 'netrw', 'csv', 'log', 'postgresql']

function s:overlength()
  if index(s:no_over_length, &filetype) != -1
    execute 'match OverLength //'
    return
  endif

  execute 'match OverLength /\%81v.\+/'
endfunction

function! s:highlights()
  highlight! link VertSplit CursorColumn
  highlight! link SignatureMarkText SignColumn
  highlight! link MatchParen Title
endfunction

function! s:setupcolors()
  if &background ==# 'dark'
    " Use a custom solarized theme dedicated to dark
    let g:lightline.colorscheme = 'solarized_dark'
    let l:fzf_color = 'fg:242,fg+:7,hl:33,hl+:33,bg:8,bg+:8'
  else
    " Use a custom solarized theme dedicated to light
    let g:lightline.colorscheme = 'solarized_light'
    let l:fzf_color = 'fg:242,fg+:8,hl:33,hl+:33,bg:15,bg+:15'
  end

  let $FZF_DEFAULT_OPTS = '--reverse --color ' . l:fzf_color

  call lightline#init()
  call lightline#update()

  call s:highlights()
endfunction

augroup SETUP_COLORS
  autocmd!
  autocmd OptionSet background call s:setupcolors()
  autocmd VimEnter * call s:setupcolors()
  autocmd SourceCmd $MYVIMRC call s:setupcolors()
augroup END
