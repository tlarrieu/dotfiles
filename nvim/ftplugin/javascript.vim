nnoremap <buffer> <return> :call neoterm#test#rerun()<cr>

augroup Test
  autocmd!
  autocmd BufEnter *_spec.js
        \ nnoremap <silent> <buffer> <leader><return>
        \ :call neoterm#test#run('file')<cr>
  autocmd BufEnter *_spec.js
        \ nnoremap <silent> <buffer> <return>
        \ :call neoterm#test#run('current')<cr>
augroup END
