let g:neoterm_shell = 'rlwrap sbcl'

vnoremap <buffer> <cr> :TREPLSendSelection<cr>
nnoremap <buffer> <cr> :call lisp#run(expand('%'))<cr>
nnoremap <buffer> <leader><cr> :call lisp#test()<cr>

function! lisp#run(filename)
  call execute('T (load "' . a:filename . '")', "Topen")
endfunction

function! lisp#test()
  let filename = expand('%:r')

  echom filename

  if (match(filename, '-test$') == -1)
    call lisp#run(filename . '-test.lisp')
  else
    call lisp#run(filename . '.lisp')
  endif
endfunction
