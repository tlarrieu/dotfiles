let g:lightline = {
      \ 'colorscheme': 'solarized',
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
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

augroup LightLine
  autocmd!
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
  let trailing = search('[^.\\]\s$', 'nw')
  if trailing != 0
    let b:whitespaces .= printf('tr(%s)', trailing)
  endif

  let mixed = CheckMixedIndent()
  if mixed != 0
    if trailing != 0
      let b:whitespaces .= ' '
    endif
    let b:whitespaces .= printf('indt(%s)', mixed)
  endif

  return b:whitespaces
endfunction

function! CheckMixedIndent()
  " [<tab>]<space><tab>
  " spaces before or between tabs are not allowed
  let t_s_t = '(^\t* +\t\s*\S)'
  " <tab>(<space> x count)
  " count of spaces at the end of tabs should be less then tabstop value
  let t_l_s = '(^\t+ {' . &ts . ',}' . '\S)'
  return search('\v' . t_s_t . '|' . t_l_s, 'nw')
endfunction
