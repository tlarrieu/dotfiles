function! sql#execute() range abort
  let l:query = ''
  let l:lines = getline(a:firstline, a:lastline)
  for l:line in l:lines
    if l:line !~# '--.*'
      let l:query .= l:line . "\\n"
    endif
  endfor

  if getline(a:firstline, a:firstline)[0] ==# '-- plot'
    call sql#run(l:query, 1)
  else
    call sql#run(l:query, 0)
  end
endfunction

function! sql#identify(entity) abort
  let l:query = '\d ' . a:entity . "\\n"
  let l:query .= '\dT+ ' . a:entity
  call sql#run(l:query, 0)
endfunction

function! s:result() dict abort
  execute 'bdelete! ' . l:self.bufnr
  execute 'new ' . l:self.filename
  setf postgresql

  if l:self.plot
    call gnuplot#plot(l:self.filename)
  endif
endfunction

function! sql#run(query, plot) abort
  let l:arguments = matchstr(getline(1), '--\s*\zs.*')

  let l:tempfile = tempname()

  if a:plot
    let l:query = "copy (" . a:query . ") to stdout delimiter ';' csv header"
  else
    let l:query = '\\timing on\n ' . a:query
  endif

  let l:query = shellescape(l:query)
  let l:query = escape(l:query, '%')
  let l:cmdline =
    \ 'echo -e ' . l:query .
    \ '| psql ' . l:arguments .
    \ ' >& ' . l:tempfile

  new

  call termopen(
    \ l:cmdline,
    \ {
    \   'name' : 'postgres',
    \   'on_exit' : function('<sid>result'),
    \   'filename' : l:tempfile,
    \   'bufnr' : bufnr('%'),
    \   'plot' : a:plot
    \ })
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
