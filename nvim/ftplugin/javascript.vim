augroup Test
  autocmd!
  autocmd BufEnter *.js
        \ nnoremap <silent> <buffer> <leader><return>
        \ :TestLast \| Topen<cr>
  autocmd BufEnter *.js
        \ nnoremap <silent> <buffer> <return>
        \ :T node %<cr>
  autocmd BufEnter *.spec.js
        \ nnoremap <silent> <buffer> <leader><return>
        \ :TestFile \| Topen<cr>
  autocmd BufEnter *.spec.js
        \ nnoremap <silent> <buffer> <return>
        \ :TestNearest \| Topen<cr>
augroup END
