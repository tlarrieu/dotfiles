function! lisp#run(filename)
  call execute('T sbcl --load "' . a:filename . '" --quit', "Topen")
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

nnoremap <buffer> <cr> :call lisp#run(expand('%'))<cr>
nnoremap <buffer> <leader><cr> :call lisp#test()<cr>
