setlocal spell
setlocal nonumber
setlocal norelativenumber

startinsert!

augroup HG
  autocmd!
  autocmd InsertCharPre hgcommit if search('\v(%^|[.!?]\_s)\_s*%#', 'bcnw') != 0 | let v:char = toupper(v:char) | endif
augroup END
