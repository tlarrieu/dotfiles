setlocal conceallevel=0
setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

setlocal formatprg=prettier

augroup Test
  autocmd!
  autocmd BufEnter *.ts
        \ nnoremap <silent> <buffer> <leader><return>
        \ :TestFile \| Topen<cr>
  autocmd BufEnter *test.ts
        \ nnoremap <silent> <buffer> <leader><return>
        \ :TestFile \| Topen<cr>
  autocmd BufEnter *.test.ts
        \ nnoremap <silent> <buffer> <return>
        \ :TestNearest \| Topen<cr>
augroup END
