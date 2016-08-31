let g:lightline = {
      \ 'active': {
      \   'left': [['mode', 'paste'], ['fugitive'], ['filename']],
      \   'right': [
      \     ['syntax', 'whitespace', 'lineinfo'],
      \     ['percent'],
      \     ['fileformat', 'fileencoding', 'filetype']
      \   ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
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
      \   'active': ['filename'],
      \   'inactive': ['filename'],
      \ },
      \ 'tab_component_function': {
      \   'filename': 'TabooTabTitle'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

augroup LightLine
  autocmd!
  autocmd CursorMoved * call lightline#update()
  autocmd CursorMovedI * call lightline#update()
  autocmd User NeomakeMakerFinished call lightline#update()
augroup END

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? '' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != expand('%:p:.') ? expand('%:p:.') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if exists('*fugitive#head')
      let mark = ''
      let branch = fugitive#head()
      return branch !=# '' ? mark.' '.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! StatusIf(glyphe, condition)
  if a:condition
    return a:glyphe
  end
  return ''
endfunction

function! LightLineSyntax()
  let neomake = neomake#statusline#LoclistStatus()
  return StatusIf(' ' . neomake, !empty(neomake))
endfunction

function! LightLineWhitespace()
  if &readonly || !&modifiable || line('$') > 10000
    return ''
  endif

  let b:whitespaces = ''

  " Matches " $" but not "\ $" (where $ marks the end of the line)
  " We do not want to match escaped spaces
  let trailing = search('\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)', 'nw')
  if trailing != 0
    let b:whitespaces .= printf('tr(%s)', trailing)
  endif

  " Spaces before or after tabs are forbidden
  let mixed = search('\v(^\t+ +| +\t+)', 'nw')
  if mixed != 0
    if trailing != 0
      let b:whitespaces .= ' '
    endif
    let b:whitespaces .= printf('indt(%s)', mixed)
  endif

  return b:whitespaces
endfunction
