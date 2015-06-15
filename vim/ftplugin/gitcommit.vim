nmap <buffer> <c-s> :Gcommit<cr>
nmap <buffer> <c-a> :Gcommit --amend<cr>

augroup GITCOMMIT
  autocmd!
  autocmd BufWritePost COMMIT_EDITMSG SignifyRefresh
augroup END

setlocal spell
setlocal nonu
setlocal nornu
