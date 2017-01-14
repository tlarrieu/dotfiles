function! sql#execute() range abort
  let l:lines = getline(a:firstline, a:lastline)
  let l:query = join(l:lines, "\\n")
  call sql#run(l:query)
endfunction

function! sql#identify(entity) abort
  let l:query = '\d ' . a:entity . "\\n"
  let l:query .= '\dT+ ' . a:entity
  call sql#run(l:query)
endfunction

function! sql#run(query) abort
  let l:connection_string = matchstr(getline(1), '--\s*\zs.*')

  let l:tempfile = tempname()

  " Use first line to infer plot type (if any)
  let l:plot = s:parse_config(split(a:query, '\\n')[0])

  if l:plot.draw
    let l:query = 'copy (' . a:query . ") to stdout delimiter ';' csv header"
    let l:filetype = 'csv'
  else
    let l:query = '\\timing on\n ' . a:query
    let l:filetype = 'postgresql'
  endif

  let l:query = shellescape(l:query)
  let l:query = escape(l:query, '%')
  let l:cmdline =
    \ 'echo -e ' . l:query .
    \ '| psql ' . l:connection_string .
    \ ' >& ' . l:tempfile

  new

  call termopen(
    \ l:cmdline,
    \ {
    \   'name' : 'postgres',
    \   'on_exit' : function('<sid>callback'),
    \   'filename' : l:tempfile,
    \   'bufnr' : bufnr('%'),
    \   'plot' : l:plot,
    \   'filetype' : l:filetype
    \ })
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

function! s:parse_config(comment) abort
  let l:args = matchlist(a:comment, '-- plot \?\(.*\)')

  if empty(l:args)
    return { 'draw' : 0 }
  endif

  let l:kind = l:args[1]

  if empty(l:kind)
    let l:kind = 'bars'
  end

  return { 'draw' : 1, 'kind' : l:kind }
endfunction
