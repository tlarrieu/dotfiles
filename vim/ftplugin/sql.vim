" vnoremap <buffer> <return> :SimpleDBExecuteSql<cr>
" nnoremap <buffer> <leader><return> m':SimpleDBExecuteSql <cr>g`'
" nnoremap <buffer> <return> m':'{,'}SimpleDBExecuteSql<cr>g`'

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

  let query = shellescape('\\timing on' . query)
  let query = escape(query, '%')
  let cmdline =
        \ 'echo -e ' . query .
        \ '| psql ' . arguments .
        \ ' > ' . tempfile

  new
  call termopen(
        \ cmdline,
        \ {
        \   'name' : 'postgres',
        \   'on_exit' : function('s:Openfile'),
        \   'filename' : tempfile
        \ })
endfunction

function! <sid>Openfile() dict
  execute 'new ' . self.filename
  setf postgresql
endfunction

command! -range=% RunSQL <line1>,<line2>call RunSQL()

vnoremap <silent> <buffer> <return> :RunSQL<cr>
nnoremap <silent> <buffer> <leader><return> m':RunSQL <cr>g`'
nnoremap <silent> <buffer> <return> m':'{,'}RunSQL<cr>g`'
