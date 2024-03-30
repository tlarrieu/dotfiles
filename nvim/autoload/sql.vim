" ------------------------------------------------------------------------------
" This can be configured through buffer variable
" Here is the list of supported variables:
" - b:sql_comment
"     a string that will be taken to process the query line by
"     line. Every time it is encountered, every character following it
"     (including it) on the line will be ignored
" - b:sql_adapter
"     can be one of 'mysql' or 'psql'
" - b:sql_connection_string
"     the entire line of parameters to be fed into the adapter
"
" Unless b:sql_adapter AND b:sql_connection_string are provided, this plugin
" will try to find a “magic” comment on the first line of the file, looking
" like:
" -- $adapter $connection_string
" to parse it and retrieve the adapter and the connection string
" eg.
" -- psql -hlocalhost -p5432 -ddbname -Upostgres
" -- mysql --host localhost --port 1234 --database dbname --user mysql
" ------------------------------------------------------------------------------

function! sql#configure()
  command! -range=% ExecuteSQL <line1>,<line2>call sql#execute()

  if !exists('b:sql_comment')
    let b:sql_comment = '--'
  endif
  echom(b:sql_comment)
endfunction

function! sql#execute() range abort
  let l:lines = getline(a:firstline, a:lastline)
  let l:index = 0
  for line in l:lines
    let l:lines[l:index] = s:clean(line)
    let l:index += 1
  endfor
  let l:query = join(l:lines, "\\n")

  call sql#run(l:query)
endfunction

function! sql#identify(entity) abort
  let [l:adapter, l:_] = s:get_connection_info()

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
  let [l:adapter, l:connection_string] = s:get_connection_info()

  let l:tempfile = tempname()

  " Use first line to infer plot type (if any)
  let l:plot = s:parse_config(split(a:query, '\\n')[0])

  let l:type = l:plot.draw ? 'csv' : 'sql'

  " This is the faulty line
  let l:Funcref = function('s:' . l:adapter)

  let [l:query, l:filetype, l:connection_string] = l:Funcref(
    \ a:query,
    \ l:type,
    \ l:connection_string
    \ )

  let l:query = shellescape(l:query)

  let l:cmdline = 'echo -e ' . l:query . ' | ' . l:adapter . ' ' . l:connection_string

  new

  call termopen(
    \ l:cmdline . '>& ' . l:tempfile,
    \ {
    \   'name' : l:filetype,
    \   'on_exit' : function('s:callback'),
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

function! s:callback(job_id, data, event) dict abort
  " Do nothing if the buffer has been closed before the query returned a result
  if bufnr(l:self.bufnr) == -1
    return
  endif

  execute 'bdelete! ' . l:self.bufnr
  execute 'new ' . l:self.filename

  execute 'setfiletype ' . l:self.filetype

  if l:self.plot.draw
    call gnuplot#plot(l:self.filename, l:self.plot.kind, l:self.plot.terminal)
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

function! s:clean(query) abort
  return substitute(a:query, b:sql_comment . ".*", "", "")
endfunction

function! s:get_connection_info() abort
  if exists('b:sql_adapter') && exists('b:sql_connection_string')
    return [b:sql_adapter, b:sql_connection_string]
  else
    return s:parse_magic_comment()
  endif
endfunction

function! s:parse_magic_comment() abort
  let l:magic_comment = matchstr(getline(1), '--\s*\zs.*')
  let l:adapter = matchstr(l:magic_comment, '\w\+\ze\s*.*')
  let l:connection_string = matchstr(l:magic_comment, '\w\+\zs\s*.*')

  return [l:adapter, l:connection_string]
endfunction

function! s:parse_config(comment) abort
  let l:tokens = matchlist(a:comment, '-- plot \?\(.*\)')

  if empty(l:tokens)
    return { 'draw' : 0 }
  endif

  let l:config = { 'draw' : 1 }

  let l:options = split(l:tokens[1], ' ')

  let l:config['kind'] = len(l:options) >= 1 ? l:options[0] : 'bars'
  let l:config['terminal'] = len(l:options) >= 2 ? l:options[1] : 'wxt'

  return l:config
endfunction
