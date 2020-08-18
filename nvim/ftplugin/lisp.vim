let g:neoterm_shell = 'rlwrap sbcl'

vnoremap <buffer> <cr> :TREPLSendSelection<cr>
nnoremap <buffer> <cr> :call lisp#run(expand('%'))<cr>
nnoremap <buffer> <leader><cr> :call lisp#test()<cr>

function! lisp#closestSExpression()
  let curchar = matchstr(getline('.'), '\%' . col('.') . 'c.')
  if (l:curchar != "(" && l:curchar != ")")
    " We have to do that because when inside an s-expression over many lines,
    " the ib/ab text object targets the next inner s-expression if any, instead
    " of the “current” one
    execute "keepjumps normal F("
  endif
endfunction

function! lisp#wrapSExpression()
  call lisp#closestSExpression()
  normal ysabb
endfunction

function! lisp#unwrapSExpression()
  call lisp#closestSExpression()
  normal dab
  call lisp#closestSExpression()
  normal vabp%
endfunction

function! lisp#editSurroundingSExpression()
  call lisp#closestSExpression()
  normal dab
  call lisp#closestSExpression()
  normal vibp%
endfunction

" Using vim-surround to wrap in parenthesis
nmap <buffer> <leader>i :call lisp#wrapSExpression()<cr>a
nmap <buffer> dae :call lisp#unwrapSExpression()<cr>
nmap <buffer> cae :call lisp#editSurroundingSExpression()<cr>i

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
