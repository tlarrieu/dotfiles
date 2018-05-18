function! StatuslineModified()
  if &buftype ==# 'help' || &buftype ==# 'quickfix'
    return ''
  endif

  if &modified
    return '+'
  endif

  if !&modifiable
    return '-'
  end

  return ''
endfunction

function! StatuslineReadonly()
  return &filetype !~? 'help' && &readonly ? '' : ''
endfunction

function! StatuslineFlags()
  return StatuslineModified() . StatuslineReadonly()
endfunction

function! StatuslinePaste()
  return &paste ? '' : ''
endfunction

function! StatuslineWhitespace()
  if &readonly || !&modifiable || line('$') > 10000
    return ''
  endif

  let b:whitespaces = ''

  " Matches " $" but not "\ $" (where $ marks the end of the line)
  " We do not want to match escaped spaces
  let l:trailing = search('\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)', 'nw')
  if l:trailing != 0
    let b:whitespaces .= printf('tr(%s)', l:trailing)
  endif

  " Spaces before or after tabs are forbidden
  let l:mixed = search('\v(^\t+ +| +\t+)', 'nw')
  if l:mixed != 0
    if l:trailing != 0
      let b:whitespaces .= ' '
    endif
    let b:whitespaces .= printf('indt(%s)', l:mixed)
  endif

  return b:whitespaces
endfunction

set statusline=
set statusline+=%*
set statusline+=%(\%{StatuslineReadonly()}%)
set statusline+=%f\                             " path
set statusline+=%(%{StatuslineModified()}\ %)
set statusline+=%(%{StatuslinePaste()}\ %)
set statusline+=%*%=\ %*                        " align right
set statusline+=%#warningmsg#
set statusline+=%(%{StatuslineWhitespace()}\ %)
set statusline+=%*
set statusline+=%(%y\ %)                        " file type
set statusline+=(%l,%c)\                        " line and column
set statusline+=%P\                             " percentage of file
set statusline+=%*
