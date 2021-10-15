augroup TEX
  autocmd!
  autocmd InsertCharPre *.tex,*.latex
    \ if search('\v(%^|[.!?]\_s)\_s*%#', 'bcnw') != 0
    \ | let v:char = toupper(v:char)
    \ | endif
augroup END

nnoremap <silent> <buffer> <return> :T xelatex % -o output.pdf<cr>
