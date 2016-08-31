function! s:setupcolors()
  if &background ==# 'dark'
    " Use a custom solarized theme dedicated to dark
    let g:lightline.colorscheme = 'solarized_dark'
    let fzf_color = 'fg:242,fg+:7,hl:33,hl+:33,bg:8,bg+:8'
  else
    " Use a custom solarized theme dedicated to light
    let g:lightline.colorscheme = 'solarized_light'
    let fzf_color = 'fg:242,fg+:8,hl:33,hl+:33,bg:15,bg+:15'
  end

  let $FZF_DEFAULT_OPTS = '--color ' . fzf_color

  call lightline#init()
  call lightline#update()

  highlight! link VertSplit CursorColumn
endfunction

augroup SETUP_COLORS
  autocmd!
  autocmd OptionSet background call s:setupcolors()
augroup END

call s:setupcolors()
