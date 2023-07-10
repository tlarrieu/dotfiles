augroup Test
  autocmd!
  autocmd BufEnter *.js
        \ nnoremap <silent> <buffer> <leader><return>
        \ :TestLast \| Topen<cr>
  autocmd BufEnter *.js
        \ nnoremap <silent> <buffer> <return>
        \ :T node %<cr>
  autocmd BufEnter *.spec.js
        \ nnoremap <silent> <buffer> <return>
        \ :TestFile \| Topen<cr>
augroup END
