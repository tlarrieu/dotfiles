function! sql#execute() range abort
  let l:lines = getline(a:firstline, a:lastline)
  let l:query = join(l:lines, "\\n")

  call sql#run(l:query)
endfunction

function! sql#identify(entity) abort
  let [l:adapter, l:_] = s:parse_magic_comment()

  if l:adapter ==# 'psql'
    let l:query = '\d ' . a:entity . "\\n"
    let l:query .= '\dT+ ' . a:entity
  else
    if l:adapter ==# 'mysql'
      let l:query = 'show columns from ' . a:entity . ';'
      let l:query .= 'show index from ' . a:entity
    endif
  endif

  call sql#run(l:query)
endfunction

function! sql#run(query) abort
  let [l:adapter, l:connection_string] = s:parse_magic_comment()

  let l:tempfile = tempname()

  " Use first line to infer plot type (if any)
  let l:plot = s:parse_config(split(a:query, '\\n')[0])

  let l:type = l:plot.draw ? 'csv' : 'sql'

  let l:Funcref = function('s:' . l:adapter)

  let [l:query, l:filetype, l:connection_string] = l:Funcref(
    \ a:query,
    \ l:type,
    \ l:connection_string
    \ )

  let l:query = shellescape(l:query)
  let l:query = escape(l:query, '%')

  let l:cmdline = 'echo -e ' . l:query . ' | ' . l:adapter . ' ' . l:connection_string

  new

  call termopen(
    \ l:cmdline . '>& ' . l:tempfile,
    \ {
    \   'name' : l:filetype,
    \   'on_exit' : function('<sid>callback'),
    \   'filename' : l:tempfile,
    \   'bufnr' : bufnr('%'),
    \   'plot' : l:plot,
    \   'filetype' : l:filetype
    \ })
endfunction

function! s:psql(query, type, connection_string) abort
  if a:type ==# 'csv'
    let l:query = 'copy (' . a:query . ") to stdout delimiter '\t' csv header"
    let l:filetype = 'csv'
  else
    if a:type ==# 'sql'
      let l:query = a:query
      let l:filetype = 'postgresql'
    else
      throw 'Unsupported type "' . a:type . '"'
    endif
  endif

  return [l:query, l:filetype, a:connection_string]
endfunction

function! s:mysql(query, type, connection_string) abort
  if a:type ==# 'csv'
    let l:connection_string = a:connection_string . ' -b'
    let l:filetype = 'csv'
  else
    if a:type ==# 'sql'
    let l:connection_string = a:connection_string . ' -t'
      let l:filetype = 'mysql'
    else
      throw 'Unsupported type "' . a:type . '"'
    endif
  endif

  return [a:query, l:filetype, l:connection_string]
endfunction

function! s:callback() dict abort
  execute 'bdelete! ' . l:self.bufnr
  execute 'new ' . l:self.filename

  execute 'setfiletype ' . l:self.filetype

  if l:self.plot.draw
    call gnuplot#plot(l:self.filename, l:self.plot.kind)
  endif
endfunction

function! sql#upper(sql) abort
  let l:syntax_id = synID(line('.'), col('.') - 1, 0)
  let l:syntax_element = synIDattr(synIDtrans(l:syntax_id), 'name')

  " Do not uppercase word if within a comment or string
  if l:syntax_element =~# 'Comment\|String'
    return a:sql
  endif

  return toupper(a:sql)
endfunction

" -- Helper functions ----------------------------------------------------------

function! s:parse_magic_comment() abort
  let l:magic_comment = matchstr(getline(1), '--\s*\zs.*')
  let l:adapter = matchstr(l:magic_comment, '\w\+\ze\s*.*')
  let l:connection_string = matchstr(l:magic_comment, '\w\+\zs\s*.*')

  return [l:adapter, l:connection_string]
endfunction

function! s:parse_config(comment) abort
  let l:args = matchlist(a:comment, '-- plot \?\(.*\)')

  if empty(l:args)
    return { 'draw' : 0 }
  endif

  let l:kind = l:args[1]

  if empty(l:kind)
    let l:kind = 'bars'
  endif

  return { 'draw' : 1, 'kind' : l:kind }
endfunction
