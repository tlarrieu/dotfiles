augroup GIT
  autocmd!

  autocmd BufEnter COMMIT_EDITMSG
    \ call setpos('.', [0, 1, 1, 0])
    \ | exec "normal $"
    \ | startinsert!
  autocmd BufEnter COMMIT_EDITMSG nnoremap <silent> <buffer> <cr> :x<cr>
  autocmd BufEnter COMMIT_EDITMSG nnoremap <silent> <buffer> <c-s> :x<cr>
  autocmd BufEnter COMMIT_EDITMSG inoremap <silent> <buffer> <c-s> <esc>:x<cr>

  " Auto capitalization (at the start of the file or after a period)
  autocmd InsertCharPre COMMIT_EDITMSG
    \ if search('\v(%^|[.!?\]]\_s|\n\n)\_s*%#', 'bcnw') != 0
    \ | let v:char = toupper(v:char)
    \ | endif

  autocmd BufEnter index nnoremap <silent> <buffer> <c-s> :Gcommit<cr>
  autocmd BufEnter index nnoremap <silent> <buffer> <c-a> :Gcommit --amend<cr>
augroup END

setlocal spell
setlocal nonumber
setlocal norelativenumber

call bullet#config()
