nmap <buffer> <c-s> :Gcommit<cr>
nmap <buffer> <c-a> :Gcommit --amend<cr>

setlocal spell
setlocal nonu
setlocal nornu

augroup GIT
  autocmd!
  autocmd BufEnter COMMIT_EDITMSG nmap <buffer> <c-s> :x<cr>
  autocmd BufEnter COMMIT_EDITMSG imap <buffer> <c-s> <esc>:x<cr>
augroup END
