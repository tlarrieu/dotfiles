set showtabline=2 " Always display tabline
set laststatus=2  " Always display statusline
set noshowmode

" let s:whitespace_symbol = ' ⌫ '
" let s:whitespace_default_checks = ['indent', 'trailing']
" let s:whitespace_trailing_format = 'trailing[%s]'
" let s:whitespace_mixed_indent_format = 'mixed-indent[%s]'
" let s:whitespace_indent_algo = 1
" let s:whitespace_max_lines = 3000
" let s:status_type = 'normal'

" let s:paste_glyphe = 'ρ'
" let s:readonly_glyphe = '⭤'
" let s:modified_glyphe = '∙'
" let s:branch_glyphe = '⭠'

highlight! link StatusLine CursorLineNr
highlight! link StatusLineNC SignColumn
highlight! link TabLine SignColumn
highlight! link TabLineFill SignColumn
highlight! link TabLineSel CursorLineNr

" Modified file marker (active window)
" highlight! User1 cterm=standout ctermfg=7 ctermbg=1 gui=standout
" Modified file marker (inactive window)
" highlight! User4 cterm=standout ctermfg=7 ctermbg=1 gui=standout
" Filename
" highlight! User2 ctermfg=14 ctermbg=7
" VCS Branch
" highlight! User3 ctermfg=14 ctermbg=7
highlight! WarningMsg   ctermfg=1 guifg=Red

" function! StatusIf(glyphe, condition)
"   if a:condition
"     return a:glyphe
"   end
"   return ''
" endfunction

" function! Paste()
"   return StatusIf(' ' . s:paste_glyphe . ' ', &paste)
" endfunction

" function! RO()
"   return StatusIf(' ' . s:readonly_glyphe . ' ', &ro)
" endfunction

" function! Modified()
"   return StatusIf(' ' . s:modified_glyphe, &modified)
" endfunction

" function! VCSBranch()
"   let branch = fugitive#head()

"   return StatusIf(' ' . s:branch_glyphe . ' ' . branch . ' ', !empty(branch))
" endfunction

" function! Syntax()
"   if !has('nvim')
"     return ''
"   end
"   let neomake = neomake#statusline#LoclistStatus()
"   return StatusIf(' ' . neomake, !empty(neomake))
" endfunction

" function! CheckMixedIndent()
"   if s:whitespace_indent_algo == 1
"     " [<tab>]<space><tab>
"     " spaces before or between tabs are not allowed
"     let t_s_t = '(^\t* +\t\s*\S)'
"     " <tab>(<space> x count)
"     " count of spaces at the end of tabs should be less then tabstop value
"     let t_l_s = '(^\t+ {' . &ts . ',}' . '\S)'
"     return search('\v' . t_s_t . '|' . t_l_s, 'nw')
"   else
"     return search('\v(^\t+ +)|(^ +\t+)', 'nw')
"   endif
" endfunction

" function! Whitespace()
"   if &readonly || !&modifiable || line('$') > s:whitespace_max_lines
"     return ''
"   endif

"   if !exists('b:whitespace_check')
"     let checks = s:whitespace_default_checks
"     let trailing = 0
"     let mixed = 0

"     if index(checks, 'trailing') > -1
"       " Matches " $" but not "\ $" (where $ marks the end of the line)
"       " We do not want to match escaped spaces
"       let trailing = search('[^.\\]\s$', 'nw')
"     endif

"     if index(checks, 'indent') > -1
"       let mixed = CheckMixedIndent()
"     endif

"     let b:whitespace_check = ''
"     if trailing != 0 || mixed != 0
"       if trailing != 0
"         let b:whitespace_check .=
"             \' ' . printf(s:whitespace_trailing_format, trailing)
"       endif
"       if mixed != 0
"         let b:whitespace_check .=
"             \' ' . printf(s:whitespace_mixed_indent_format, mixed)
"       endif
"       let b:whitespace_check .= s:whitespace_symbol
"     endif
"   endif
"   return b:whitespace_check
" endfunction

" function! WhitespaceReset()
"   let b:whitespace_check = ''
"   unlet b:whitespace_check
" endfunction

" function! ShortStatus()
"   setlocal statusline=
"   setlocal statusline+=%t
"   setlocal statusline+=%4*%{Modified()}%*
" endfunction

" function! NormalStatus()
"   setlocal statusline=
"   setlocal statusline+=%t%*
"   setlocal statusline+=%{Modified()}%*
"   setlocal statusline+=%#warningmsg#
"   setlocal statusline+=%{Syntax()}
"   setlocal statusline+=%{Whitespace()}
"   setlocal statusline+=%*
"   setlocal statusline+=%{Paste()}
"   setlocal statusline+=%{RO()}
"   setlocal statusline+=%=
"   setlocal statusline+=\ %h%w
"   setlocal statusline+=%y\ 
"   setlocal statusline+=⭡\ %l,%v\ %P
" endfunction

" function! FullStatus()
"   setlocal statusline=
"   setlocal statusline+=%{VCSBranch()}%*
"   setlocal statusline+=%f%*
"   setlocal statusline+=%{Modified()}%*
"   setlocal statusline+=%#warningmsg#
"   setlocal statusline+=%{Syntax()}
"   setlocal statusline+=%{Whitespace()}
"   setlocal statusline+=%*
"   setlocal statusline+=%{Paste()}
"   setlocal statusline+=%{RO()}
"   setlocal statusline+=%=
"   setlocal statusline+=\ %h%w
"   setlocal statusline+=%y
"   setlocal statusline+=[%{strlen(&fenc)?&fenc:'none'},%{&ff}]
"   setlocal statusline+=\ 
"   setlocal statusline+=⭡\ %l,%v\ %P
" endfunction

" function! Status()
"   if s:status_type == 'normal'
"     call NormalStatus()
"   else
"     call FullStatus()
"   end
" endfunction

" function! SwitchStatus()
"   if s:status_type == 'normal'
"     let s:status_type = 'full'
"   else
"     let s:status_type = 'normal'
"   end
"   call Status()
" endfunction

" augroup StatusLine
"   autocmd!

"   autocmd BufEnter * call Status()
"   autocmd WinEnter * call Status()

"   autocmd WinLeave * call ShortStatus()

"   autocmd BufWritePost * call WhitespaceReset()
" augroup END

" call Status()
