" -- [[ Runner ]] --------------------------------------------------------------
function! s:GetQuery(first, last)
  let query = ''
  let lines = getline(a:first, a:last)
  for line in lines
    if line !~ '--.*'
      let query .= line . "\\n"
    endif
  endfor
  return query
endfunction

function! RunSQL() range
  let arguments = matchstr(getline(1), '--\s*\zs.*')
  let query = s:GetQuery(a:firstline, a:lastline)

  let tempfile = tempname()

  let query = shellescape('\\timing on\n ' . query)
  let query = escape(query, '%')
  let cmdline =
        \ 'echo -e ' . query .
        \ '| psql ' . arguments .
        \ ' >& ' . tempfile

  new

  call termopen(
        \ cmdline,
        \ {
        \   'name' : 'postgres',
        \   'on_exit' : function('s:Openfile'),
        \   'filename' : tempfile,
        \   'bufnr' : bufnr('%')
        \ })
endfunction

function! Identify(entity)
  let arguments = matchstr(getline(1), '--\s*\zs.*')
  let query = '\d ' . a:entity

  let tempfile = tempname()

  let query = shellescape('\\timing on\n ' . query)
  let query = escape(query, '%')
  let cmdline =
        \ 'echo -e ' . query .
        \ '| psql ' . arguments .
        \ ' >& ' . tempfile

  new

  call termopen(
        \ cmdline,
        \ {
        \   'name' : 'postgres',
        \   'on_exit' : function('s:Openfile'),
        \   'filename' : tempfile,
        \   'bufnr' : bufnr('%')
        \ })
endfunction

function! <sid>Openfile() dict
  execute 'bdelete! ' . self.bufnr
  execute 'new ' . self.filename
  setf postgresql
  match OverLength //
endfunction

command! -range=% RunSQL <line1>,<line2>call RunSQL()
command! Identify call Identify()

nmap <silent> <buffer> <return> :'{,'}RunSQL<cr>
nmap <silent> <buffer> <leader><return> :call Identify('<c-r><c-w>')<cr>

" -- [[ Formatter ]] -----------------------------------------------------------
vmap <silent> <leader>i :!sqlformat - -r -k upper<cr>
