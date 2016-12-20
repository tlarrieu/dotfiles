" -- [[ Runner ]] --------------------------------------------------------------
function! s:RunSQL(query)
  let l:arguments = matchstr(getline(1), '--\s*\zs.*')

  let l:tempfile = tempname()

  let l:query = shellescape('\\timing on\n ' . a:query)
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
    \   'on_exit' : 'OpenSQLResult',
    \   'filename' : l:tempfile,
    \   'bufnr' : bufnr('%')
    \ })
endfunction

function! s:Excute() range
  let l:query = ''
  let l:lines = getline(a:firstline, a:lastline)
  for l:line in l:lines
    if l:line !~# '--.*'
      let l:query .= l:line . "\\n"
    endif
  endfor

  call s:RunSQL(l:query)
endfunction

function! s:Identify(entity)
  call s:RunSQL('\d ' . a:entity)
endfunction

command! -range=% ExecuteSQL <line1>,<line2>call s:Excute()

nmap <silent> <buffer> <return> vip:ExecuteSQL<cr>
vmap <silent> <buffer> <return> :'<,'>ExecuteSQL<cr>
nmap <silent> <buffer> <leader><return> :call <sid>Identify('<c-r><c-w>')<cr>

" -- [[ Formatter ]] -----------------------------------------------------------
vmap <silent> <leader>i :!sqlformat - -r -k upper<cr>
