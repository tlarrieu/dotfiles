" vnoremap <buffer> <return> :SimpleDBExecuteSql<cr>
" nnoremap <buffer> <leader><return> m':SimpleDBExecuteSql <cr>g`'
" nnoremap <buffer> <return> m':'{,'}SimpleDBExecuteSql<cr>g`'

function! s:GetQuery(first, last)
  let query = ''
  let lines = getline(a:first, a:last)
  for line in lines
    if line !~ '--.*'
      let query .= line . "\n"
    endif
  endfor
  return query
endfunction

function! s:PostgresCommand(conprops, query)
  let sql_text = shellescape('\\timing on \\\ ' . a:query)
  let sql_text = escape(sql_text, '%')
  let cmdline = 'echo -e ' . sql_text . '| psql ' . a:conprops
  return cmdline
endfunction

function! RunSQL() range
  let conprops = matchstr(getline(1), '--\s*\zs.*')
  let adapter = 'psql'
  let query = s:GetQuery(a:firstline, a:lastline)

  let cmdline = s:PostgresCommand(conprops, query)

  new
  call termopen(cmdline)
  execute "normal <c-w>p"
endfunction

command! -range=% RunSQL <line1>,<line2>call RunSQL()

vnoremap <buffer> <return> :RunSQL<cr>
nnoremap <buffer> <leader><return> m':RunSQL <cr>g`'
nnoremap <buffer> <return> m':'{,'}RunSQL<cr>g`'
