function! sql#execute() range abort
  let l:query = ''
  let l:lines = getline(a:firstline, a:lastline)
  for l:line in l:lines
    if l:line !~# '--.*'
      let l:query .= l:line . "\\n"
    endif
  endfor

  let l:plotcomment = getline(a:firstline, a:firstline)[0]
  if l:plotcomment !~# '-- plot.*'
    call sql#run(l:query, 'noplot')
    return
  endif

  if l:plotcomment =~# '-- plot bars'
    echom 'bars'
    call sql#run(l:query, 'bars')
    return
  endif

  if l:plotcomment =~# '-- plot lines'
    echom 'lines'
    call sql#run(l:query, 'lines')
    return
  endif

  echom 'default'
  call sql#run(l:query, 'bars')
endfunction

function! sql#identify(entity) abort
  let l:query = '\d ' . a:entity . "\\n"
  let l:query .= '\dT+ ' . a:entity
  call sql#run(l:query, 'noplot')
endfunction

function! s:result() dict abort
  execute 'bdelete! ' . l:self.bufnr
  execute 'new ' . l:self.filename
  setf postgresql

  if l:self.plot !=# 'noplot'
    call gnuplot#plot(l:self.filename, l:self.plot)
  endif
endfunction

function! sql#run(query, plot) abort
  let l:arguments = matchstr(getline(1), '--\s*\zs.*')

  let l:tempfile = tempname()

  if a:plot ==# 'noplot'
    let l:query = '\\timing on\n ' . a:query
  else
    let l:query = "copy (" . a:query . ") to stdout delimiter ';' csv header"
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
