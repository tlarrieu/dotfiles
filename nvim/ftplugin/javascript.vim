nnoremap <buffer> <return> :TestLast<cr>

augroup Test
  autocmd!
  autocmd BufEnter *_spec.js
        \ nnoremap <silent> <buffer> <leader><return>
        \ :TestFile<cr>
  autocmd BufEnter *_spec.js
        \ nnoremap <silent> <buffer> <return>
        \ :TestLast<cr>
augroup END
