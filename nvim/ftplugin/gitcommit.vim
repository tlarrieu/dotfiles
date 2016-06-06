augroup GIT
  autocmd!
  autocmd BufEnter COMMIT_EDITMSG nnoremap <buffer> <c-s> :x<cr>
  autocmd BufEnter COMMIT_EDITMSG inoremap <buffer> <c-s> <esc>:x<cr>

  autocmd BufEnter index nnoremap <buffer> <c-s> :Gcommit<cr>
  autocmd BufEnter index nnoremap <buffer> <c-a> :Gcommit --amend<cr>
augroup END

setlocal spell
setlocal nonu
setlocal nornu
