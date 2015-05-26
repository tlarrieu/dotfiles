set showtabline=2 " Always display tabline
set laststatus=2  " Always display statusline
set noshowmode

function! Highlight()
  highlight! StatusLine  ctermfg=32 guifg=#fdf6e3 ctermbg=15 guibg=#2aa198
  highlight! TabLineSel  ctermfg=15 guifg=#fdf6e3 ctermbg=32 guibg=#2aa198
  highlight! WarningMsg  ctermfg=15 guifg=#fdf6e3 ctermbg=32 guibg=#2aa198

  " Modified file marker (active window)
  highlight! User1 term=bold cterm=bold ctermfg=1 ctermbg=32
  " Modified file marker (inactive window)
  highlight! User4 term=bold cterm=bold ctermfg=1 ctermbg=7
  " Filename
  highlight! User2 ctermfg=15 ctermbg=32
  " VCS Branch
  highlight! User3 ctermfg=15 ctermbg=32
endfunc

function! NoHighlight()
  highlight! WarningMsg   ctermfg=1 ctermbg=7 guifg=Red
  highlight! StatusLine   ctermbg=12 ctermfg=7 guifg=Blue
  highlight! StatusLineNC ctermbg=14 ctermfg=7 guifg=Brown
  highlight! TabLine      term=NONE cterm=NONE ctermfg=12 ctermbg=7 guifg=Blue
  highlight! TabLineFill  term=NONE cterm=NONE ctermfg=12 ctermbg=7 guifg=Blue
  highlight! TabLineSel   term=bold cterm=bold ctermfg=32 ctermbg=7 guifg=Blue

  " Modified file marker (active window)
  highlight! User1 term=bold cterm=bold ctermfg=1 ctermbg=7
  " Modified file marker (inactive window)
  highlight! link User4 User1
  " Filename
  highlight! User2 term=bold cterm=bold ctermfg=14 ctermbg=7
  " VCS Branch
  highlight! User3 ctermfg=14 ctermbg=7
endfunc

function! Paste()
  if &paste
    return ' ⌘ '
  endif
  return ''
endfunction

function! RO()
  if &ro
    return ' ⭤ '
  end
  return ''
endfunction

function! Modified()
  if &modified
    return ' ∙'
  endif
  return ''
endfunction

function! VCSBranch()
  let branch = ''
  let branch = lawrencium#statusline() . fugitive#head()

  if empty(branch)
    return branch
  end

  return ' ⭠ ' . branch . ' '
endfunction

function! Syntastic()
  let syntastic = SyntasticStatuslineFlag()
  if empty(syntastic)
    return ''
  endif
  return ' ' . syntastic
endfunction

let g:whitespace_symbol = ' ⌫ '
let g:whitespace_default_checks = ['indent', 'trailing']
let g:whitespace_trailing_format = 'trailing[%s]'
let g:whitespace_mixed_indent_format = 'mixed-indent[%s]'
let g:whitespace_indent_algo = 1
let g:whitespace_max_lines = 3000

function! CheckMixedIndent()
  if g:whitespace_indent_algo == 1
    " [<tab>]<space><tab>
    " spaces before or between tabs are not allowed
    let t_s_t = '(^\t* +\t\s*\S)'
    " <tab>(<space> x count)
    " count of spaces at the end of tabs should be less then tabstop value
    let t_l_s = '(^\t+ {' . &ts . ',}' . '\S)'
    return search('\v' . t_s_t . '|' . t_l_s, 'nw')
  else
    return search('\v(^\t+ +)|(^ +\t+)', 'nw')
  endif
endfunction

function! Whitespace()
  if &readonly || !&modifiable || line('$') > g:whitespace_max_lines
    return ''
  endif

  if !exists('b:whitespace_check')
    let checks = g:whitespace_default_checks
    let trailing = 0
    let mixed = 0

    if index(checks, 'trailing') > -1
      " Matches " $" but not "\ $" (where $ marks the end of the line)
      " We do not want to match escaped spaces
      let trailing = search('[^.\\]\s$', 'nw')
    endif

    if index(checks, 'indent') > -1
      let mixed = CheckMixedIndent()
    endif

    let b:whitespace_check = ''
    if trailing != 0 || mixed != 0
      if trailing != 0
        let b:whitespace_check .=
            \' ' . printf(g:whitespace_trailing_format, trailing)
      endif
      if mixed != 0
        let b:whitespace_check .=
            \' ' . printf(g:whitespace_mixed_indent_format, mixed)
      endif
      let b:whitespace_check .= g:whitespace_symbol
    endif
  endif
  return b:whitespace_check
endfunction

function! WhitespaceReset()
  let b:whitespace_check = ''
  unlet b:whitespace_check
endfunction


function! ShortStatus()
  setlocal statusline=
  setlocal statusline+=%t
  setlocal statusline+=%4*%{Modified()}%*
endfunction

function! Status()
  if g:status_type == 'normal'
    setlocal statusline=
    setlocal statusline+=%2*%t%*
    setlocal statusline+=%1*%{Modified()}%*
    setlocal statusline+=%#warningmsg#
    setlocal statusline+=%{Syntastic()}
    setlocal statusline+=%{Whitespace()}
    setlocal statusline+=%*
    setlocal statusline+=%{Paste()}
    setlocal statusline+=%{RO()}
    setlocal statusline+=%=
    setlocal statusline+=\ %h%w
    setlocal statusline+=%y\ 
    setlocal statusline+=⭡\ %l,%v\ %P
  else
    setlocal statusline=
    setlocal statusline+=%3*%{VCSBranch()}%*
    setlocal statusline+=%2*%f%*
    setlocal statusline+=%1*%{Modified()}%*
    setlocal statusline+=%#warningmsg#
    setlocal statusline+=%{Syntastic()}
    setlocal statusline+=%{Whitespace()}
    setlocal statusline+=%*
    setlocal statusline+=%{Paste()}
    setlocal statusline+=%{RO()}
    setlocal statusline+=%=
    setlocal statusline+=\ %h%w
    setlocal statusline+=%y
    setlocal statusline+=[%{strlen(&fenc)?&fenc:'none'},%{&ff}]
    setlocal statusline+=\ 
    setlocal statusline+=⭡\ %l,%v\ %P
  end
endfunction

function! SwitchStatus()
  if g:status_type == 'normal'
    let g:status_type = 'full'
  else
    let g:status_type = 'normal'
  end
  call Status()
endfunction

let g:status_type = 'normal'

call NoHighlight()
call Status()

augroup StatusLine
  autocmd!

  autocmd InsertEnter * call Highlight()
  autocmd InsertLeave * call NoHighlight()

  autocmd BufEnter * call Status()
  autocmd WinEnter * call Status()
  autocmd WinLeave * call ShortStatus()

  autocmd BufWritePost * call WhitespaceReset()
augroup END
