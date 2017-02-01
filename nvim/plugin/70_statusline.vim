let g:lightline = {
      \ 'active': {
      \   'left': [['mode', 'paste'], ['fugitive'], ['buffer']],
      \   'right': [
      \     ['syntax', 'whitespace', 'lineinfo'],
      \     ['percent'],
      \     ['filetype', 'fileencoding', 'fileformat'],
      \   ]
      \ },
      \ 'inactive': {
      \   'left': [['buffer']],
      \ },
      \ 'component_function': {
      \   'fileencoding': 'LightLineFileencoding',
      \   'fileformat': 'LightLineFileformat',
      \   'buffer': 'LightLineBuffer',
      \   'filetype': 'LightLineFiletype',
      \   'fugitive': 'LightLineFugitive',
      \   'mode': 'LightLineMode'
      \ },
      \ 'component_expand': {
      \   'syntax': 'LightLineSyntax',
      \   'whitespace': 'LightLineWhitespace'
      \ },
      \ 'component_type': {
      \   'syntax': 'error',
      \   'whitespace': 'warning'
      \ },
      \ 'tabline': {
      \   'left': [['tabs']],
      \   'right': [[]]
      \ },
      \ 'tab': {
      \   'active': ['buffer'],
      \   'inactive': ['buffer'],
      \ },
      \ 'tab_component_function': {
      \   'buffer': 'TabooTabTitle'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

augroup LightLine
  autocmd!
  autocmd CursorMoved * call lightline#update()
  autocmd CursorMovedI * call lightline#update()
  autocmd User NeomakeMakerFinished call lightline#update()
augroup END

function! LightLineModified()
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

function! LightLineReadonly()
  return &filetype !~? 'help' && &readonly ? '' : ''
endfunction

function! LightLineFilename()
  let l:filename = expand('%:p:.')
  if l:filename !=# ''
    return l:filename
  endif

  if exists('w:quickfix_title')
    if w:quickfix_title ==# ''
      return 'quickfix'
    endif
    return w:quickfix_title
  endif

  return ''
endfunction

function! LightLineBuffer()
  return s:maybe(LightLineReadonly(), '') .
    \ s:maybe(LightLineFilename(), '[No Name]') .
    \ s:maybe(LightLineModified(), '')
endfunction

function! LightLineFugitive()
  try
    if exists('*fugitive#head')
      let l:mark = ''
      let l:branch = fugitive#head()
      return l:branch !=# '' ? l:mark . ' ' . l:branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return &fileformat
endfunction

function! LightLineFiletype()
  return &filetype !=# '' ? &filetype : 'no ft'
endfunction

function! LightLineFileencoding()
  return &fileencoding !=# '' ? &fileencoding : &encoding
endfunction

function! LightLineMode()
  return lightline#mode()
endfunction

function! StatusIf(glyphe, condition)
  if a:condition
    return a:glyphe
  end
  return ''
endfunction

function! LightLineSyntax()
  let l:neomake = neomake#statusline#LoclistStatus()
  return StatusIf(' ' . l:neomake, !empty(l:neomake))
endfunction

function! LightLineWhitespace()
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

function! s:maybe(label, replacement)
  if a:label ==# ''
    return a:replacement
  end

  return a:label . ' '
endfunction
