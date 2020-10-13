function! statusline#Modified()
  if &buftype ==# 'help' || &buftype ==# 'quickfix'
    return ''
  endif

  if &modified
    return ''
  endif

  if !&modifiable
    return ''
  end

  return ''
endfunction

function! statusline#Readonly()
  return &filetype !~? 'help' && &readonly ? '' : ''
endfunction

function! statusline#Paste()
  return &paste ? '' : ''
endfunction

function! statusline#Whitespace()
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
